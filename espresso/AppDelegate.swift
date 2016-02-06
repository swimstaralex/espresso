//
//  AppDelegate.swift
//  espresso
//
//  Created by Alexander Sinn on 28.01.16.
//  Copyright © 2016 swimStarAlex. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var task = NSTask()
    let menu = NSMenu()
    var launched = false

    @IBOutlet weak var window: NSWindow!



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        
        menu.addItem(NSMenuItem(title: "off", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Espresso Patronum", action: Selector("espresso:"), keyEquivalent: "e"))
        menu.addItem(NSMenuItem(title: "Finite", action: Selector("finite:"), keyEquivalent: "f"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Preferences ...", action: Selector("settings:"), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit espresso", action: Selector("terminate:"), keyEquivalent: "q"))
        
        menu.itemAtIndex(1)?.image = NSImage(named: "StatusBarButtonImageFilled")
        menu.itemAtIndex(2)?.image = NSImage(named: "StatusBarButtonImage")
        menu.itemAtIndex(1)?.toolTip = "This starts the system process caffeinate."
        menu.itemAtIndex(2)?.toolTip = "This stops the system process caffeinate."
        
        statusItem.menu = menu
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        if task.running {
            task.terminate()
        }
        print("about to close application...")
    }
    
    func settings(sender: AnyObject){
        self.window.orderFront(self)
    }
    
    func getParams() ->[String]{
        if (defaults.objectForKey("infinite") != nil) {
            if defaults.boolForKey("infinite"){
                print("infinite: caffeinate -d")
                menu.itemArray.first?.title = "on infinite"
                return ["-d"]
            }
            else {
                if (defaults.objectForKey("time") != nil) {
                    let time = Int(defaults.doubleForKey("time"))
                    print("limited: caffeinate -d -t \(time)")
                    menu.itemArray.first?.title = "on for \(time) seconds"
                    return ["-d", "-t", String(time)]
                }
                else {
                    print("limited: caffeinate -d -t 5400")
                    menu.itemArray.first?.title = "on for 5400 seconds"
                    return ["-d", "-t", String(5400)]
                }
            }
        }
        print("limited: caffeinate -d -t 5400")
        menu.itemArray.first?.title = "on for 5400 seconds"
        return ["-d", "-t", String(5400)]
    }
    
    func espresso(sender: AnyObject){
        
        if (!task.running){
            launched = false
        }
        
        if !launched {
            task = NSTask()
            task.launchPath = "/usr/bin/caffeinate"
            task.arguments = getParams()
        
            let pipe = NSPipe()
            task.standardOutput = pipe
            task.launch()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskCompletion", name: NSTaskDidTerminateNotification, object: task)
        
            
            if let button = statusItem.button {
                button.image = NSImage(named: "StatusBarButtonImageFilled")
            }
            launched = true
        }
        else {
            print("process already launched")
        }
    }
    
    func finite(sender: AnyObject){
        if launched {
            task.terminate()
        
            menu.itemArray.first?.title = "off"
            if let button = statusItem.button {
                button.image = NSImage(named: "StatusBarButtonImage")
            }
            launched = false
        }
        else {
            print("process not launched")
        }
    }
    
    func taskCompletion(){
        print("task COMPLETED")
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        menu.itemArray.first?.title = "off"
    }


}

