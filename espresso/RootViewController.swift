//
//  RootViewController.swift
//  espresso
//
//  Created by Alexander Sinn on 29.01.16.
//  Copyright © 2016 swimStarAlex. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController {
    var defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var sliderLabel: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var infiniteCB: NSButton!

    
    @IBAction func infiniteAction(sender: AnyObject) {
        if infiniteCB.state == NSOnState{
            defaults.setBool(true, forKey: "infinite")
            slider.enabled = false
            sliderLabel.textColor = NSColor.grayColor()
        }
        else {
            defaults.setBool(false, forKey: "infinite")
            slider.enabled = true
            sliderLabel.textColor = NSColor.blackColor()
        }
    }
    
    @IBAction func sliderAction(sender: AnyObject) {
        defaults.setDouble(slider.doubleValue, forKey: "time")
        sliderLabel.stringValue = String(Int(slider.doubleValue))
        defaults.synchronize()
    }
    
    
    override func awakeFromNib() {
        slider.toolTip = "This sets the time for which your mac won't sleep. Time in seconds."
        infiniteCB.toolTip = "If this is checked espresso will prevent your mac from sleeping as long as you don't stop it."
        if (defaults.objectForKey("time") != nil) {
            slider.doubleValue = defaults.doubleForKey("time")
            print(defaults.doubleForKey("time"))
        }
        sliderLabel.stringValue = String(Int(slider.doubleValue))
        if (defaults.objectForKey("infinite") != nil){
            if defaults.boolForKey("infinite") {
                infiniteCB.state = NSOnState
                slider.enabled = false
                sliderLabel.textColor = NSColor.grayColor()
            }
            else {
                infiniteCB.state = NSOffState
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
