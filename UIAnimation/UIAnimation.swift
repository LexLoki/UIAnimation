//
//  UIAnimation.swift
//  Created by Pietro Ribeiro Pepe on 3/31/16.

//  The MIT License (MIT)
//  Copyright © 2016 Pietro Ribeiro Pepe.

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

extension UIView{
    /**
     * Executes an 'UIAnimation' on the view
     *
     * - Parameter animation: A 'UIAnimation'
    */
    func runAnimation(animation : UIAnimation, completion : ()->Void = {}){
        animation.execute(self,completion)
    }
    /**
     * Removes all the 'UIAnimation' that are running on the view
     */
    func removeAllAnimations(){
        layer.removeAllAnimations()
    }
    /// Not implemented
    func removeAnimationForKey(key : String){
    }
}
/**
 * Specifies an animation cycle that can be executed by an UIView
 *
 * - Movement
 * - Rotation
 * - Actions sequentially
 * - Actions concurrently
 * - Repeat
 * - RunBlock
 * - WaitTime
 * - Fades
 * - FollowPoints
 * - Shake
*/
class UIAnimation : NSObject{
    
    /**
     * Creates an action that moves an UIView's center point to a given point
     *
     * - Parameter point: A 'CGPoint' value specifying where the 'UIView' should move
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the movement
    */
    class func moveTo(point : CGPoint, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [NSValue(CGPoint: point),false], forKeys: ["point","isBy"]), duration, _handleMovement)
    }
    
    /**
     * Creates an action that moves an UIView's by a given distance
     *
     * - Parameter point: A 'CGPoint' value specifying how much the 'UIView' should move
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the movement
     */
    class func moveBy(point : CGPoint, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [NSValue(CGPoint: point),true], forKeys: ["point","isBy"]), duration, _handleMovement)
    }
    
    /**
     * Creates an action that rotates the UIView's to a given angle
     *
     * - Parameter angle: A 'CGFloat' value specifying the angle the 'UIView' should rotate to, in degrees
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func rotateTo(angle : CGFloat, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [angle,false], forKeys: ["angle","isBy"]), duration, _handleRotation)
    }
    
    /**
     * Creates an action that rotates clockwise the UIView's by a relative value.
     *
     * - Parameter angle: A 'CGFloat' value specifying the ammount the UIView should rotate, in degrees
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func rotateBy(angle : CGFloat, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [angle,true], forKeys: ["angle","isBy"]), duration, _handleRotation)
    }
    
    /**
     * Creates an action that adjusts the alpha value of a view by a relative value
     *
     * - Parameter alpha: A 'CGFloat' value specifying the ammount to add to a view's alpha value
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func fadeAlphaBy(alpha : CGFloat, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [alpha,true], forKeys: ["alpha","isBy"]), duration, _handleAlpha)
    }
    
    /**
     * Creates an action that adjusts the alpha value of a view to a given value
     *
     * - Parameter alpha: A 'CGFloat' value specifying the new value of the view's alpha
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func fadeAlphaTo(alpha : CGFloat, duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [alpha,false], forKeys: ["alpha","isBy"]), duration, _handleAlpha)
    }
    
    /**
     * Creates an action that changes a view's alpha value to 1.0
     *
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func fadeInWithDuration(duration : NSTimeInterval) -> UIAnimation{
        return fadeAlphaTo(1, duration: duration)
    }
    
    /**
     * Creates an action that changes a view's alpha value to 0.0
     *
     * - Parameter duration: A 'NSTimerInverval' specifying the duration of the rotation
     */
    class func fadeOutWithDuration(duration : NSTimeInterval) -> UIAnimation{
        return fadeAlphaTo(0, duration: duration)
    }
    
    /**
     * Creates an action that runs a collection of actions sequentially
     *
     * - Parameter animations: An array of 'UIAnimation'
     */
    class func sequence(animations : [UIAnimation]) -> UIAnimation{
        var c : NSTimeInterval = 0
        for a in animations{
            c += a.time
        }
        return UIAnimation(data: NSDictionary(object: animations, forKey: "animations"), c, _handleSequence)
    }
    
    /**
     * Creates an action that runs a collection of actions concurrently
     *
     * - Parameter animations: An array of 'UIAnimation'
     */
    class func group(animations : [UIAnimation]) -> UIAnimation{
        var c : NSTimeInterval = 0
        for a in animations{
            if a.time>c{
                c = a.time
            }
        }
        return UIAnimation(data: NSDictionary(object: animations, forKey: "animations"), c, _handleGroup)
    }
    
    /**
     * Creates an action that repeats another action a specified number of times
     *
     * - Parameter animation: The action to repeat
     * - Parameter count: how many times it should repeat
     */
    class func repeatAnimation(animation : UIAnimation, count : Int) -> UIAnimation{
        return UIAnimation(data: NSDictionary(objects: [animation,count], forKeys: ["animation","repTime"]), animation.time*NSTimeInterval(count), _handleRepeat)
    }
    
    /**
     * Creates an action that repeats another action forever
     *
     * - Parameter animation: The action to repeat
     */
    class func repeatAnimationForever(animation : UIAnimation) -> UIAnimation{
        return repeatAnimation(animation, count: -1)
    }
    
    /**
     * Creates an action that executes a block
     *
     * - Parameter block: The '()->Void' block to be executed
     */
    class func runBlock(block : ()->Void) -> UIAnimation{
        return UIAnimation(data: NSDictionary(object: BlockWrapper(block), forKey: "block"), 0, _handleBlock)
    }
    
    /**
     * Creates an action that idles for a specified period of time
     *
     * - Parameter duration: A 'NSTimeInterval' with how many seconds it should idle
     */
    class func waitForDuration(duration : NSTimeInterval) -> UIAnimation{
        return UIAnimation(data: NSDictionary(), duration, _handleWait)
    }
    
    /**
    * Creates an action that moves a view to collection of points, sequentially
    *
    * - Parameter points: The collection of points the view should move to
    * - Parameter speed: The absolute speed of the view's movement
    */
    class func followPoints(points : [CGPoint], withSpeed speed : CGFloat) -> UIAnimation{
        var v = [NSValue]()
        for p in points{
            v.append(NSValue(CGPoint: p))
        }
        return UIAnimation(data: NSDictionary(objects: [speed,v], forKeys: ["speed","points"]), 0, _handlePath)
    }
    
    /**
     * Creates an action that shakes a view random positions, based on the given frequence and force
     *
     * - Parameter force: A 'CGPPoint' specifying the distance the view will move, from its center position, when shaking
     * - Parameter frequence: A 'CGFloat' specifying how many shakes per second the view should do
     * - Parameter duration: A 'NSTimeInterval' specifying the estimated total duration of the shake animation (might differ a little)
     */
    class func shake(force : CGPoint, frequence : CGFloat, duration : NSTimeInterval) -> UIAnimation{
        let eachDuration = NSTimeInterval(1.0/frequence)
        return UIAnimation(data: NSDictionary(objects: [eachDuration,Int(duration/eachDuration),NSValue(CGPoint: force)], forKeys: ["eachTime","quant","force"]), duration, _handleShake)
    }
    
    private class BlockWrapper{
        let block: ()->Void
        init(_ block: ()->Void){
            self.block = block
        }
    }
    class PrivateTimer : NSObject{
        class func runTimer(timer : NSTimer){
            (timer.userInfo as! BlockWrapper).block()
        }
    }
    
    /// Duration of the animation
    private let time : NSTimeInterval
    /// Information of the animation
    private let data : NSDictionary
    /// The function to be called when a UIView runs the animation
    private let handler : (UIView,UIAnimation,(()->Void)?)->Void
    
    private init(data : NSDictionary, _ time : NSTimeInterval, _ handler : (UIView,UIAnimation,(()->Void)?)->Void){
        self.time = time
        self.data = data
        self.handler = handler
    }
    
    func execute(view : UIView, _ completion : ()->Void){
        handler(view,self,completion)
    }
    
    class private func _handleMovement(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        var p = (anim.data["point"] as! NSValue).CGPointValue()
        if (anim.data["isBy"] as! Bool){
            p.x = view.center.x+p.x; p.y = view.center.y+p.y
        }
        UIView.animateWithDuration(anim.time, animations: { () -> Void in
            view.center = p
            }) { (v) -> Void in
                if v{ comp?() }
        }
    }
    
    class private func _handlePath(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        _runPath(view, anim.data["speed"] as! CGFloat, anim.data["points"] as! [NSValue], 0, comp)
    }
    
    class private func _handleRotation(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        let a = (anim.data["angle"] as! CGFloat) / 180.0 * CGFloat(M_PI)
        UIView.animateWithDuration(anim.time, animations: { () -> Void in
            view.transform = (anim.data["isBy"] as! Bool) ? CGAffineTransformRotate(view.transform, a) : CGAffineTransformMakeRotation(a)
            }) { (v) -> Void in
                if v{ comp?() }
        }
    }
    
    class private func _handleAlpha(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        var a = anim.data["alpha"] as! CGFloat
        if anim.data["isBy"] as! Bool{
            a += view.alpha
        }
        UIView.animateWithDuration(anim.time, animations: { () -> Void in
            view.alpha = a
            }) { (v) -> Void in
                if v{ comp?() }
        }
    }
    
    class private func _handleSequence(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        _run(view, anim.data["animations"] as! [UIAnimation], 0, comp)
    }
    
    class private func _handleGroup(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        let anims = anim.data["animations"] as! [UIAnimation]
        var n_comp = 0
        for a in anims{
            a.handler(view,a,{ () -> Void in
                if(++n_comp == anims.count){
                    comp?()
                }})}
    }
    
    class private func _handleRepeat(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        _repetition(view, anim.data["animation"] as! UIAnimation, anim.data["repTime"] as! Int, comp)
    }
    
    class private func _handleBlock(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        (anim.data["block"] as! BlockWrapper).block();
        comp?();
    }
    
    class private func _handleWait(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        if let c = comp{
            NSTimer.scheduledTimerWithTimeInterval(anim.time, target: UIAnimation.PrivateTimer.self, selector: "runTimer:", userInfo: BlockWrapper(c), repeats: false)
        }
    }
    
    class private func _handleShake(view : UIView, _ anim : UIAnimation, _ comp: (()->Void)?){
        let q = anim.data["quant"] as! Int
        let f = (anim.data["force"] as! NSValue).CGPointValue()
        let e = anim.data["eachTime"] as! NSTimeInterval
        var actions = [UIAnimation]()
        for var i=0;i<q;i++ {
            let a = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * CGFloat(2*M_PI)
            actions.append(UIAnimation.moveTo(CGPointMake(view.center.x+cos(a)*f.x,view.center.y+sin(a)*f.y), duration: e))
        }
        actions.append(UIAnimation.moveTo(view.center, duration: 0))
        view.runAnimation(UIAnimation.sequence(actions)) { () -> Void in
            comp?()
        }
    }
    
    class private func _run(view : UIView, _ anim : [UIAnimation], var _ i : Int, _ completion : (()->Void)?){
        let curr = anim[i]
        curr.handler(view,curr,{ () -> Void in
            if (++i)<anim.count{
                _run(view, anim, i, completion)
            }
            else{ completion?() }
        })
    }
    
    class private func _runPath(view : UIView, _ speed : CGFloat, _ points : [NSValue], var _ i : Int, _ completion : (()->Void)?){
        let curr = points[i].CGPointValue()
        view.runAnimation(UIAnimation.moveTo(curr, duration: NSTimeInterval(speed/sqrt(pow(curr.x-view.center.x, 2)+pow(curr.y-view.center.y, 2))))) { () -> Void in
            if (++i)<points.count{
                _runPath(view, speed, points, i, completion)
            }
            else{ completion?() }
        }
    }
    
    class private func _repetition(view : UIView, _ anim : UIAnimation, var _ rep : Int, _ completion : (()->Void)?){
        anim.handler(view,anim,{ () -> Void in
            if (rep <= -1 || --rep>0){
                _repetition(view, anim, rep, completion)
            }
            else{ completion?() }
        })
    }
}