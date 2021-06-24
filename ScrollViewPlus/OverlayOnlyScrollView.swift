import Cocoa

public class OverlayOnlyScrollView: NSScrollView {
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        super.scrollerStyle = .overlay
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        super.scrollerStyle = .overlay
    }

    public override var scrollerStyle: NSScroller.Style {
        get {
            return super.scrollerStyle
        }
        set {
            // AppKit will set this value in a number of places automatically, so the
            // safest bet is to prevent any from taking place
            _ = newValue
        }
    }
}
