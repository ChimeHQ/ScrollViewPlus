import Cocoa

public extension NSScroller {
    var knobSlotThickness: CGFloat {
        let thicknessRect = rect(for: .knobSlot)

        return min(thicknessRect.width, thicknessRect.height)
    }

    var knobThickness: CGFloat {
        let thicknessRect = rect(for: .knob)

        return min(thicknessRect.width, thicknessRect.height)
    }

    var defaultKnobSlotThickness: CGFloat {
        return NSScroller.scrollerWidth(for: controlSize, scrollerStyle: scrollerStyle)
    }

    var knobSlotVisible: Bool {
        return knobSlotThickness >= defaultKnobSlotThickness
    }
}

