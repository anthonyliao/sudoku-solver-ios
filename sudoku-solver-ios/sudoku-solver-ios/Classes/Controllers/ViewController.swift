//
//  ViewController.swift
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var views: ([[UIView]])!
    var size = 9
    var menu: UIButton!
    var blank: UIImage!
    var one: UIImage!
    var two: UIImage!
    var three: UIImage!
    var four: UIImage!
    var five: UIImage!
    var six: UIImage!
    var seven: UIImage!
    var eight: UIImage!
    var nine: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dark = UIColor.orangeColor()
        var light = UIColor.yellowColor()
        var alternate = true
        
        self.views = [[UIView]]()
        for var i = 0; i < self.size; i++ {
            self.views.insert([], atIndex: i)
            for var j = 0; j < self.size; j++ {
                var view = UIView()
                view.backgroundColor = alternate ? dark : light
                alternate = !alternate
                self.views[i].append(view)
//                self.view.addSubview(view)
            }
        }
        
        var imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        blank = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("1")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        one = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("2")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        two = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("3")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        three = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("4")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        four = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("5")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        five = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("6")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        six = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("7")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        seven = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("8")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        eight = imageView.image!
        
        imageView = UIImageView(frame: CGRectMake(100, 200, 50, 50))
        imageView.setImageWithString("9")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        nine = imageView.image!
        
        
//        self.imageView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
//        self.imageView.layer.borderWidth = 1
//        
//        self.imageView.layer.shadowOffset = CGSizeMake(0, 0)
//        self.imageView.layer.shadowRadius = 1.5
//        self.imageView.layer.shadowOpacity = 0.3
        
        var ylView = YLLongTapShareView(frame: CGRectMake(10, 10, 200, 200))
        ylView.layer.borderColor = UIColor.magentaColor().CGColor
        ylView.layer.borderWidth = 1
        ylView.backgroundColor = UIColor.lightGrayColor()
        ylView.addShareItem(YLShareItem(icon: one, andTitle: "one"))
        ylView.addShareItem(YLShareItem(icon: two, andTitle: "two"))
        ylView.addShareItem(YLShareItem(icon: three, andTitle: "three"))
        ylView.addShareItem(YLShareItem(icon: four, andTitle: "four"))
        ylView.addShareItem(YLShareItem(icon: five, andTitle: "five"))
        ylView.addShareItem(YLShareItem(icon: six, andTitle: "six"))
        ylView.addShareItem(YLShareItem(icon: seven, andTitle: "seven"))
        ylView.addShareItem(YLShareItem(icon: eight, andTitle: "eight"))
        ylView.addShareItem(YLShareItem(icon: nine, andTitle: "nine"))
        self.menu = UIButton.buttonWithType(UIButtonType.System) as UIButton
        menu.setTitle("test", forState: UIControlState.Normal)
        menu.addShareItem(YLShareItem(icon: one, andTitle: "one"))
        menu.addShareItem(YLShareItem(icon: two, andTitle: "two"))
        menu.addShareItem(YLShareItem(icon: three, andTitle: "three"))
        menu.addShareItem(YLShareItem(icon: four, andTitle: "four"))
        menu.addShareItem(YLShareItem(icon: five, andTitle: "five"))
        menu.addShareItem(YLShareItem(icon: six, andTitle: "six"))
        menu.addShareItem(YLShareItem(icon: seven, andTitle: "seven"))
        menu.addShareItem(YLShareItem(icon: eight, andTitle: "eight"))
        menu.addShareItem(YLShareItem(icon: nine, andTitle: "nine"))
        menu.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)
        menu.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        menu.backgroundColor = UIColor.blackColor()
        menu.frame = CGRectMake(100, 100, 75, 75)
        ylView.addSubview(menu)
        self.view.addSubview(ylView)
    }
    
    override func viewDidLayoutSubviews() {
        var inset: CGFloat = 20
        var f = self.view.frame
        var w = f.width - inset * 2
        var h = f.height - inset * 2
        var smallest = min(w, h)
        var sizePerBox = smallest/CGFloat(self.size)
        
        var x: CGFloat = inset
        var y: CGFloat = inset
        for var i = 0; i < self.size; i++ {
            for var j = 0; j < self.size; j++ {
                self.views[i][j].frame = CGRectMake(x, y, sizePerBox, sizePerBox)
                x += sizePerBox
            }
            x = inset
            y += sizePerBox
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

