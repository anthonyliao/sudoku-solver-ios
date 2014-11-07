//
//  AppDelegate.swift
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import UIKit
import XCGLogger

let LOG: XCGLogger = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        LOG.setup(logLevel: XCGLogger.LogLevel.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        LOG.info("application started")
        
        var square = [
            [0,0,0,0,0,6,9,2,0],
            [0,0,0,7,8,0,0,0,0],
            [0,7,9,0,5,0,1,0,0],
            [1,9,0,0,0,0,0,0,0],
            [0,0,8,0,0,0,3,0,0],
            [0,0,0,0,0,0,0,7,5],
            [0,0,1,0,9,0,4,3,0],
            [0,0,0,0,3,7,0,0,0],
            [0,3,5,6,0,0,0,0,0]
        ]
        var start = NSDate()
        var solver = Solver(initialArray: square)
        solver.solve()
        var executionTime = NSDate().timeIntervalSinceDate(start)
        LOG.info("solved in \(executionTime)")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

