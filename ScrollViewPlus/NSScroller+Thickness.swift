import Cocoa

public extension NSScroller {
    var knobSlotThickness: CGFloat {
        let rect = rect(for: .knobSlot)

        return min(rect.width, rect.height)
    }

    var knobThickness: CGFloat {
        let rect = rect(for: .knob)

        return min(rect.width, rect.height)
    }

    var defaultKnobSlotThickness: CGFloat {
        return NSScroller.scrollerWidth(for: controlSize, scrollerStyle: scrollerStyle)
    }

    var knobSlotVisible: Bool {
        return knobSlotThickness >= defaultKnobSlotThickness
    }
}

