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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let v = UIView()
        v.backgroundColor = UIColor.red
        v.center = view.center
        v.frame.size = CGSize(width:view.frame.width/3, height:view.frame.width/3)
        view.addSubview(v)
        
        let point1 = CGPoint(x: v.frame.width*1.5/2, y: view.frame.height/2)
        let point2 = CGPoint(x: view.frame.width-point1.x, y: point1.y)
        
        
        let anim = UIAnimation.moveTo(point: point1, duration: 1) // This action moves to point1
        let anim2 = UIAnimation.moveTo(point: point2, duration: 1) // This action moves to point2
        
        let rot1 = UIAnimation.rotateBy(angle: 90, duration: 0.6) // Rotates 90 degrees clockwise
        let rot2 = UIAnimation.rotateBy(angle: -90, duration: 0.6) // Rotates 90 degrees anti-clockwise
        
        let seq = UIAnimation.sequence(animations: [anim,rot1,anim2,rot2]) // Executes, in the order, the actions given
        let rep = UIAnimation.repeatAnimationForever(animation: seq) // Makes the sequence above repeats forever
        
        v.runAnimation(rep) // Executes the animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

