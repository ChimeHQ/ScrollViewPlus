import Cocoa

public class ScrollViewVisibleRectObserver {
    public typealias ObservationHandler = (NSScrollView) -> Void

    public let scrollView: NSScrollView
    public var frameChangedHandler: ObservationHandler?
    public var contentBoundsChangedHandler: ObservationHandler?

    public init(scrollView: NSScrollView) {
        self.scrollView = scrollView

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(frameDidChange(_:)),
                                               name: NSView.frameDidChangeNotification,
                                               object: scrollView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentBoundsDidChange(_:)),
                                               name: NSView.boundsDidChangeNotification,
                                               object: scrollView.contentView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func frameDidChange(_ notification: Notification) {
        frameChangedHandler?(scrollView)
    }

    @objc private func contentBoundsDidChange(_ notification: Notification) {
        contentBoundsChangedHandler?(scrollView)
    }

    public func withViewFrameChangeNotificationsDisabled(_ withDisabledBlock: () -> Void) {
        scrollView.postsFrameChangedNotifications = false
        scrollView.contentView.postsBoundsChangedNotifications = false

        withDisabledBlock()

        scrollView.postsFrameChangedNotifications = true
        scrollView.contentView.postsBoundsChangedNotifications = true
    }
}
