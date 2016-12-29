# MJSlideMenu
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An implementation of sliding menu for iOS as seen in Instagram, Reddit app and others.

![Demo](https://raw.githubusercontent.com/MindaugasJucius/MJSlideMenu/master/demogif.gif)

## Usage

- create `Segments` for the menu 
```swift
let photosSegment = Segment(title: "Photos", contentView: photosContentView)
let collectionSegment = Segment(title: "Collections", contentView: collectionsContentView)
let segments = [photosSegment, collectionSegment]
```
- set them to `MJSlideMenu`'s instance property `segments` that you've created with one of the factory methods
```swift
let slideMenuInView = MJSlideMenu.create(withParent: containerView)
slideMenuInView.segments = segments
// or
let slideMenuInVC = MJSlideMenu.create(withParentVC: containerViewController)
slideMenuInVC.segments = segments
```
- have fun with the sliding menu :)

### Customization
There are multiple public properties with the purpose of customizing the menu's appearance.

- For the segments menu
```swift
public var menuBackgroundColor: UIColor // default is .white
public var menuTextColorSelected: UIColor // default is .black
public var menuTextColor: UIColor // default is .lightGray
public var menuTextFont: UIFont // default is System font with System size 
public var menuHeight: CGFloat // default is 35
```
- For the index separator
```swift
public var indexViewColor: UIColor // default is .black
public var indexViewHeight: CGFloat // default is 2
```
- For the content views
```swift
public var contentBackgroundColor: UIColor // default is .white
```

## Installation
This project is [Carthage](https://github.com/Carthage/Carthage) compatible. Add `github "MindaugasJucius/MJSlideMenu"` to your `Cartfile` and run `carthage update`.

## Missing features
There are several features still missing from the library.

- Landscape orientation support
- More customization for index separator view
- Support for translucent nav/tab bars
