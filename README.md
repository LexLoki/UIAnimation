# UIAnimation
This class provides easy implementation of animations with UIView components

Similarly to `SpriteKit`'s `SKAction` of `SKNode`, `UIAnimation` represents an action that can be run on a `UIView`. With it you can move, rotate, and create sequences of actions and blocks. It is possible to store an animation and reuse them with multiple views.

## Methods
#### UIAnimation
* `class func moveTo(point : CGPoint, duration : NSTimeInterval) -> UIAnimation`
* `class func moveBy(point : CGPoint, duration : NSTimeInterval) -> UIAnimation`
* `class func scaleTo(scale : CGPoint, duration : NSTimeInterval) -> UIAnimation`
* `class func scaleBy(scale : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func rotateTo(angle : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func rotateBy(angle : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func sequence(animations : [UIAnimation]) -> UIAnimation`
* `class func group(animations : [UIAnimation]) -> UIAnimation`
* `class func repeatAnimation(animation : UIAnimation, count : Int) -> UIAnimation`
* `class func repeatAnimationForever(animation : UIAnimation) -> UIAnimation`
* `class func runBlock(block : ()->Void) -> UIAnimation`
* `class func waitForDuration(duration : NSTimeInterval) -> UIAnimation`
* `class func fadeAlphaTo(alpha : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func fadeAlphaBy(alpha : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func fadeInWithDuration(duration : NSTimeInterval) -> UIAnimation`
* `class func fadeOutWithDuration(duration : NSTimeInterval) -> UIAnimation`
* `class func followPoints(points : [CGPoint], withSpeed speed : CGFloat) -> UIAnimation`
* `class func shake(force : CGPoint, frequence : CGFloat, duration : NSTimeInterval) -> UIAnimation`
* `class func removeFromSuperview() -> UIAnimation`

#### UIView
* `func runAnimation(animation : UIAnimation)`
* `func runAnimation(animation : UIAnimation, completion : ()->Void)`
* `func removeAllAnimations()`

## How to use + Examples
Consider this simple example: we want to move myView (an UIView) to the origin point, and we want the movement to last 3 seconds:
```swift
let action = UIAnimation.moveTo(point: CGPoint.zero, duration: 3)
myView.runAnimation(action)
//or just
myView.runAnimation(UIAnimation.moveTo(point: CGPoint.zero, duration: 3))
```
A more complete example would be the one present here, in the 'ViewController' file:
```swift
let v = UIView()
v.backgroundColor = UIColor.red
v.center = view.center
v.frame.size = CGSize(width: view.frame.width/3, height: view.frame.width/3)
view.addSubview(v)

let point1 = CGPoint(x: v.frame.width*1.5/2, y: view.frame.height/2)
let point2 = CGPoint(x: view.frame.width-point1.x, y: point1.y)


let anim = UIAnimation.moveTo(point: point1, duration: 1) // This action moves to point1
let anim2 = UIAnimation.moveTo(point: point2, duration: 1) // This action moves to point2

let rot1 = UIAnimation.rotateBy(angle: 90, duration: 0.6) // Rotates 90 degrees clockwise
let rot2 = UIAnimation.rotateBy(angle: -90, duration: 0.6) // Rotates 90 degrees anti-clockwise

let seq = UIAnimation.sequence(animations: [anim,rot1,anim2,rot2]) // Executes, sequentially, the given actions
let rep = UIAnimation.repeatAnimationForever(animation: seq) // Makes the sequence above repeats forever
v.runAnimation(rep) // Executes the animation
```
This produces the animation below:

![alt tag](https://cloud.githubusercontent.com/assets/9408934/14170897/684dd170-f706-11e5-97d9-240e5f9f19fb.gif)
