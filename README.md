# JSSAlertView

A custom "modal" alert view for iOS 7 and 8 written in Swift, with a couple basic themes and support for custom icons and fonts. Inspired by and modeled after [vikmeup's](https://github.com/vikmeup) [SCLAlertView](https://github.com/vikmeup/SCLAlertView-Swift).

![BackgroundImage](https://raw.githubusercontent.com/stakes/JSSAlertView/master/gh-demo.gif)

### How to use

The most minimal alert just has a title. 

```swift
JSSAlertView().show(
  self, // the parent view controller of the alert
  title: "I'm an alert" // the alert's title
)
```

You'll always want to first pass a reference to the view controller that you wish to add the overlay and alert subviews to.

Besides the default `show()` method you can call any of four alert themes: `info()`, `success()`, `warning()`, and `danger()`.

```swift
JSSAlertView().success(
  self, 
  title: "Great success", 
  text: "This is the built-in .success style"
)
```

You can customize button text, add a custom icon and customize the alert color.

```swift
var customIcon:UIImage! // your custom icon UIImage
var customColor:UIColor! // base color for the alert
JSSAlertView().show(
  self, 
  title: "Another alert", 
  text: "An alert with more customizations.", 
  buttonText: "Right on", 
  color: customColor, 
  iconImage: customIcon)
```

And you can also provide a callback function to run after the alert is dismissed, specify custom fonts and change the alert's text color from dark to light.

```swift
func myCallback() { 
  // this'll run after the alert is dismissed
}
var alertview = JSSAlertView().show(self, 
  title: "Yet another alert", 
  text: "Callbacks, fonts and text colors"
)
alertview.addAction(myCallback) // Method to run after dismissal
alertview.setTitleFont("ClearSans-Bold") // Title font
alertview.setTextFont("ClearSans") // Alert body text font
alertview.setButtonFont("ClearSans-Light") // Button text font
alertview.setTextTheme(.Light) // can be .Light or .Dark
```

See the included example project for more!

### How to install

Just add the JSSAlertView.swift file to your Xcode project. Maybe one day I'll make it available through CocoaPods.
