<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Matrix][matrix badge]][matrix]

</div>

# ScrollViewPlus

ScrollViewPlus is a small library that provides some helpful extension and capabilities for working with `NSScrollView`.

## Integration

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/ScrollViewPlus.git")
]
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

### PositionJumpingWorkaroundScrollView

A class that works around a pretty esoteric problem:

The scroll-position jumping will occur if this view contains an `NSTextView` and:

- non-contiguous layout enabled for the `NSTextView`'s `NSLayoutManager`
- there are actual non contiguous blocks in the layout
- the `NSTextView` is configured so text does not wrap to the view's bounds
- there are at least some lines of text that are actually larger than the view's bounds
- the containing `NSScrollView` has a vertical ruler present
- the pointing device is a trackpad

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me on [the web](https://www.massicotte.org).

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/ScrollViewPlus/actions
[build status badge]: https://github.com/ChimeHQ/ScrollViewPlus/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/ScrollViewPlus
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FScrollViewPlus%2Fbadge%3Ftype%3Dplatforms
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
[discord]: https://discord.gg/esFpX6sErJ
