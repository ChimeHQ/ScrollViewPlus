import Cocoa

/// Observes the state of overlay-style NSScrollers.
///
/// This class monitors the state of overlay-style NSScrollers. It can invoke callbacks when
/// interesting events occur, like visibility and thickness changes.
///
/// Because AppKit does not provide sufficient hooks for these events, in some cases
/// `ScrollerOverlayObserver` depends on heuristics that aren't always correct in all situations
/// across all OS releases.
@MainActor
public final class ScrollerOverlayObserver: NSObject {
    private enum TrackingState: Hashable {
        case idle
        case visible(Date, TimeInterval)
        case tracking

        mutating func handleVisbilityEvent(with interval: TimeInterval) -> Bool {
            switch self {
            case .idle:
                self = .visible(Date(), interval)
                return true
            case .visible:
                self = .visible(Date(), interval)
            case .tracking:
                break
            }

            return false
        }

        var invisible: Bool {
            switch self {
            case .idle:
                return true
            default:
                return false
            }
        }

        mutating func handleVisibilityCheck(with date: Date) -> TimeInterval? {
            switch self {
            case .idle:
                return nil
            case .tracking:
                return nil
            case .visible(let startDate, let interval):
                let elasped = date.timeIntervalSince(startDate)

                if elasped >= interval {
                    self = .idle
                    return nil
                }

                return interval - elasped
            }
        }
    }

    private weak var scrollView: NSScrollView?
    private var horizontalState: TrackingState
    private var verticalState: TrackingState
    private var lastPoint: CGPoint
    public var visibilityChangedHandler: (() -> Void)?
    public var scrollerThicknessChangedHandler: (() -> Void)?

    public init(scrollView: NSScrollView) {
        self.scrollView = scrollView
        self.horizontalState = .idle
        self.verticalState = .idle
        self.lastPoint = .zero

        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(scrollerWillStartTracking(_:)), name: .willStartTracking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollerDidEndTracking(_:)), name: .didEndTracking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollerThicknessDidChange(_:)), name: .thicknessDidChange, object: nil)
    }

    var horizontalScroller: NSScroller? {
        return scrollView?.horizontalScroller
    }

    var verticalScroller: NSScroller? {
        return scrollView?.verticalScroller
    }

    public var horizontalScrollerVisible: Bool {
        return horizontalState.invisible == false
    }

    public var verticalScrollerVisible: Bool {
        return verticalState.invisible == false
    }

    private func postScrollerVisibilityChanged() {
        visibilityChangedHandler?()
    }

    @objc private func scrollerWillStartTracking(_ notification: Notification) {
        guard let obj = notification.object as? NSScroller else { return }

        var postNotification = false

        if let scroller = horizontalScroller, scroller == obj {
            if horizontalState.invisible {
                postNotification = true
            }

            self.horizontalState = .tracking
        }

        if let scroller = verticalScroller, scroller == obj {
            if verticalState.invisible {
                postNotification = true
            }

            self.verticalState = .tracking
        }

        guard postNotification else { return }

        postScrollerVisibilityChanged()
    }

    @objc private func scrollerDidEndTracking(_ notification: Notification) {
        guard let obj = notification.object as? NSScroller else { return }

        var affected = false
        let interval = trackingVisibilityTimeInterval

        if let scroller = horizontalScroller, scroller == obj {
            self.horizontalState = .visible(Date(), interval)
            affected = true
        }

        if let scroller = verticalScroller, scroller == obj {
            self.verticalState = .visible(Date(), interval)
            affected = true
        }

        guard affected else { return }

        scheduleCheck(for: interval)
    }

    @objc private func scrollerThicknessDidChange(_ notification: Notification) {
        guard let obj = notification.object as? NSScroller else { return }

        var affected = false

        if let scroller = horizontalScroller, scroller == obj {
            affected = true
        }

        if let scroller = verticalScroller, scroller == obj {
            affected = true
        }

        if affected {
            scrollerThicknessChangedHandler?()
        }
    }

    private var flashVisibilityTimeInterval: TimeInterval {
        return 0.80
    }

    private var scrollVisibilityTimeInterval: TimeInterval {
        return 0.50
    }

    private var trackingVisibilityTimeInterval: TimeInterval {
        return 0.50
    }

    private func scheduleCheck(for interval: TimeInterval) {
        precondition(interval > 0.0)

        let time = DispatchTime.now() + .milliseconds(Int(interval * 1000.0))
        let currentTime = Date()

        // because this is just a plain delay, we have to be sure
        // we do not keep ourselve alive
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            self?.checkVisibility(startingAt: currentTime, interval: interval)
        }
    }

    private func checkVisibility(startingAt date: Date, interval: TimeInterval) {
        let oldHoriz = horizontalState.invisible
        let oldVert = verticalState.invisible

        let remainingHoriz = horizontalState.handleVisibilityCheck(with: date)
        let remainingVert = verticalState.handleVisibilityCheck(with: date)

        switch (remainingHoriz, remainingVert) {
        case (nil, nil):
            break
        case (let a?, nil):
            scheduleCheck(for: a)
        case (nil, let b?):
            scheduleCheck(for: b)
        case (let a?, let b?):
            scheduleCheck(for: min(a, b))
        }

        if oldHoriz != horizontalState.invisible || oldVert != verticalState.invisible {
            postScrollerVisibilityChanged()
        }
    }

}

extension ScrollerOverlayObserver {
    public func flashScrollers() {
        let interval = flashVisibilityTimeInterval
        let horizVisble = self.horizontalState.handleVisbilityEvent(with: interval)
        let vertVisible = self.verticalState.handleVisbilityEvent(with: interval)

        if horizVisble || vertVisible {
            postScrollerVisibilityChanged()
        }

        // it's safer to check every time, because the expectation is this method
        // is called infrequently
        scheduleCheck(for: flashVisibilityTimeInterval)
    }

    public func scroll(_ clipView: NSClipView, to point: NSPoint) {
        let horizScroll = lastPoint.x != point.x
        let vertScroll = lastPoint.y != point.y
        let interval = scrollVisibilityTimeInterval

        lastPoint = point

        let oldHoriz = horizontalState.invisible
        let oldVert = verticalState.invisible

        if horizScroll {
            _ = self.horizontalState.handleVisbilityEvent(with: interval)
        }

        if vertScroll {
            _ = self.verticalState.handleVisbilityEvent(with: interval)
        }

        if oldHoriz != horizontalState.invisible || oldVert != verticalState.invisible {
            postScrollerVisibilityChanged()

            // here, we only schedule a check if we have transitioned to visible, because
            // we know this method gets called a lot
            scheduleCheck(for: interval)
        }
    }
}
