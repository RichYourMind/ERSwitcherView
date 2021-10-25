# ERSwitcherView

An iOS switch component implemented in Swift with full Interface Builder support. 

![Image of Neumorphic Label](https://i.ibb.co/6g9F2SL/switcher-xxxiii-by-volorf.gif)

## Installation
Requirements
.iOS(.v11)

#### Swift Package Manager 
1. In Xcode, open your project and navigate to File → Swift Packages → Add Package Dependency.
2. Paste the repository URL (https://github.com/RichYourMind/ERSwitcherView.git) and click Next.
3. For Rules, select version.
4. Click Finish.

#### Swift Package
```swift
.package(url: "https://github.com/RichYourMind/ERSwitcherView.git")
```
## Usage
Import ERSwitcherView package to your class.

```swift
import ERSwitcherView
```

 Put custom view to your scene and change its class to SwitcherView.

![Image of usage](https://i.ibb.co/28PzqD4/Screen-Shot-2021-10-25-at-2-30-51-PM.png)

## Customize
Modify size , on color and off color directly from your class. Having outlet from switcher view to your code is what you need.
Simply use **.boxViewSize** and **.onBackColor** and **.offBackColor** properties to set size and color for view.
```swift
        switcherView.boxViewSize = CGSize(width: 100, height: 50)
        switcherView.onBackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        switcherView.offBackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
```

## Delegate
To get notifyed when ever switcher changes just set your class as switcher delegate
```swift
        switcherView.delegate = self
```

Now just implement this delegate method to be notified
```swift
extension ViewController: SwitcherDelegate {
    func switcherStateChanged(to: Bool) {
        
    }
}
```


## Contacts
implementedmind@gmail.com
