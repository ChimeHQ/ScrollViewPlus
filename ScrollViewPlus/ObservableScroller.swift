import Cocoa

extension Notification.Name {
    static let thicknessDidChange = Notification.Name("ScrollerThicknessDidChange")
    static let willStartTracking = Notification.Name("ScrollerWillStartTracking")
    static let didEndTracking = Notification.Name("ScrollerDidEndTracking")
}

open class ObservableScroller: NSScroller {
    private var lastSlotThickness: CGFloat = 0.0

    public override class var isCompatibleWithOverlayScrollers: Bool {
        return self == ObservableScroller.self
    }

    private func checkThickness() {
        let currentThickness = knobSlotThickness

        if currentThickness != lastSlotThickness {
            print("posting thickness changed")
            NotificationCenter.default.post(name: .thicknessDidChange, object: self)
        }

        lastSlotThickness = currentThickness
    }

    override public func setNeedsDisplay(_ invalidRect: NSRect) {
        checkThickness()

        super.setNeedsDisplay(invalidRect)
    }

    override public func trackKnob(with event: NSEvent) {
        checkThickness()
        NotificationCenter.default.post(name: .willStartTracking, object: self)

        super.trackKnob(with: event)

        checkThickness()
        NotificationCenter.default.post(name: .didEndTracking, object: self)
    }
}
