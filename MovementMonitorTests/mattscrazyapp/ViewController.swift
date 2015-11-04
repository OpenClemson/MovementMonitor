//
//  ViewController.swift
//  mattscrazyapp
//
//  Created by Matt Smith on 1/20/15.
//  Copyright (c) 2015 Matt Smith. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let field = UITextField(frame: CGRectZero)
        field.placeholder = "Robot Noise App"
        self.view.addSubview(field)
        
        
        let button=UIButton(frame: CGRectZero)
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Crazy Button", forState: .Normal)
        button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        button.alpha=0.6
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 2
        button.addTarget(self, action: "pressme:", forControlEvents: .TouchUpInside)
        button.titleLabel?.textAlignment = .Center
        
        
        constrain(self.view, field) { view, field in
            field.left == view.left + 20
            field.top == view.top + 40
        }
        
        let switchTest = UISwitch(frame:CGRectMake(150, 300, 0, 0))
        switchTest.on = true
        switchTest.setOn(true, animated: false)
        switchTest.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(switchTest)
        
        constrain(self.view, switchTest) { view, swTest in
            swTest.centerX == view.right - 50
            swTest.centerY == view.top + 150
        }
        
        view.setNeedsUpdateConstraints()
        
        
        
    
    }
    
    
    func switchValueDidChange(sender:UISwitch!){
        if (sender.on == true){
            print("button-on")
        }
        else{
            print("button-off")
        }
    }
    
    func pressme(sender:UIButton!){
        print("Button Pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

