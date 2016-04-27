//
//  ViewController.swift
//  UIAnimation
//
//  Created by Pietro Ribeiro Pepe on 3/31/16.
//  Copyright © 2016 Pietro Ribeiro Pepe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        v.center = view.center
        v.frame.size = CGSizeMake(view.frame.width/3, view.frame.width/3)
        view.addSubview(v)
        
        let point1 = CGPointMake(v.frame.width*1.5/2, view.frame.height/2)
        let point2 = CGPointMake(view.frame.width-point1.x, point1.y)
        
        
        let anim = UIAnimation.moveTo(point1, duration: 1) // This action moves to point1
        let anim2 = UIAnimation.moveTo(point2, duration: 1) // This action moves to point2
        
        let rot1 = UIAnimation.rotateBy(90, duration: 0.6) // Rotates 90 degrees clockwise
        let rot2 = UIAnimation.rotateBy(-90, duration: 0.6) // Rotates 90 degrees anti-clockwise
        
        let shake = UIAnimation.shake(CGPointMake(10, 10), frequence: 40, duration: 1)
        
        let sA = UIAnimation.group([shake,anim2])
        
        let seq = UIAnimation.sequence([anim,rot1,sA,rot2]) // Executes, in the order, the actions given
        let rep = UIAnimation.repeatAnimationForever(seq) // Makes the sequence above repeats forever
        
        v.runAnimation(rep) // Executes the animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

