[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# ScrollViewPlus

ScrollViewPlus is a small library that provides some helpful extension and capabilities for working with NSScrollView.

## Integration

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/ScrollViewPlus.git")
]
```

### Carthage

```
github "ChimeHQ/ScrollViewPlus"
```

## Classes

### ScrollViewVisibleRectObserver

Simple class to monitor the user-visible portion of an `NSScrollView` document view.

### ObservableScroller

An `NSScroller` subclass that makes it possible to determine the overlay style's slot thickness and detect changes to it.

### ScrollerOverlayObserver

A class that can be used to observe the scroller overlay size and visibily changes. This makes use of some heuristics that aren't perfect, but the end result is quite good. Must be used in combination with `ObservableScroller`, but does not enforce an `NSScrollView` subclass requirement.

### OverlayOnlyScrollView

A very simple `NSScrollView` subclass that will always use overlay style scrollers, regardless of user prefs or input device types.

###PositionJumpingWorkaroundScrollView

A class that works around a pretty esoteric problem:

The scroll-position jumping will occur if this view contains an `NSTextView` and:

- non-contiguous layout enabled for the `NSTextView`'s `NSLayoutManager`
- there are actual non contiguous blocks in the layout
- the `NSTextView` is configured so text does not wrap to the view's bounds
- there are at least some lines of text that are actually larger than the view's bounds
- the containing `NSScrollView` has a vertical ruler present
- the pointing device is a trackpad

## Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
