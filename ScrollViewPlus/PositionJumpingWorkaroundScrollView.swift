import Cocoa

/// Works around a bug in macOS that can cause terrible scroll-position jumping with `NSTextView`.
///
/// The scroll-position jumping will occur if this view contains an `NSTextView` and:
///
/// - non-contiguous layout enabled for the `NSTextView`'s NSLayoutManager
/// - there are actual non contiguous blocks in the layout
/// - the `NSTextView` is configured so text does not wrap to the view's bounds
/// - there are at least some lines of text that are actually larger than the view's bounds
/// - the containing `NSScrollView` has a vertical ruler present
/// - the pointing device is a trackpad
///
/// This class uses a workaround only while these conditions are met, with the exception
/// of the scroll being initiated by a trackpad. Haven't yet figured out how to detect that
/// situation.
@MainActor
open class PositionJumpingWorkaroundScrollView: NSScrollView {
    private var lastPosition: CGFloat = 0.0

    private var textView: NSTextView? {
        return documentView as? NSTextView
    }

    private var hasUnlaidText: Bool {
        guard
            let firstUnlaidIndex = textView?.layoutManager?.firstUnlaidCharacterIndex(),
            let textLength = textView?.textStorage?.length
        else {
            return false
        }

        return firstUnlaidIndex < textLength
    }

    private var workaroundChecksNeeded: Bool {
        guard rulersVisible else {
            return false
        }

        guard hasVerticalRuler else {
            return false
        }

        guard hasUnlaidText else {
            return false
        }

        return true
    }

    private var textPadding: CGFloat {
        let padding = textView?.textContainer?.lineFragmentPadding ?? 0.0
        let inset = textView?.textContainerInset.width ?? 0.0

        return padding + inset
    }

    private var documentOrigin: CGPoint {
        return contentView.documentRect.origin
    }

    private var rulerSideTripLength: CGFloat {
        let thickness = verticalRulerView?.requiredThickness ?? 0.0

        return thickness - textPadding - documentOrigin.x
    }

    private func shouldFilterScrollPoint(_ newPoint: NSPoint) -> Bool {
        guard workaroundChecksNeeded else {
            return false
        }

        let newPos = newPoint.x
        let lastPos = lastPosition

        // Case 1: jump that occurs when leading text is obsecured by the ruler
        //
        // this is -1.0 to give a little slack so that the scroll appears smoother
        if lastPos < -1.0 && newPos == documentOrigin.x {
            return true
        }

        // Case 2: jump that occurs when leading text is obsecured by the ruler
        // and also scrolled far enough to cause elastic behavior
        if lastPos < -rulerSideTripLength && newPos == -rulerSideTripLength {
            return true
        }

        return false
    }

    public override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        if shouldFilterScrollPoint(point) {
            let filteredPoint = NSPoint(x: lastPosition, y: point.y)

            super.scroll(clipView, to: filteredPoint)

            return
        }

        lastPosition = point.x

        super.scroll(clipView, to: point)
    }
}
