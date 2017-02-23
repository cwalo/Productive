//
//  AppDelegate.swift
//  Productive
//
//  Created by Corey Walo on 2/22/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    var statusItem: NSStatusItem?
    
    var lastKeyDate = Date()
    var lastMouseDate = Date()
    var lastNotificationDate = Date()
    
    var timeout: Double = 60 * 20
    
    let notification = NSUserNotification()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setStatusItem()
        makeNotification()
        setupEvents()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setStatusItem() {
        statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        
        statusItem?.menu = statusMenu
        statusItem?.highlightMode = true
        statusItem?.image = NSImage(named: "stopwatch_white")
        
        statusItem?.action = #selector(self.didClickStatusItem(sender:))
    }
    
    func setupEvents() {
        let opts = NSDictionary(object: kCFBooleanTrue, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
        
        guard AXIsProcessTrustedWithOptions(opts) == true else { return }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if let _ = event.characters {
                self.lastKeyDate = Date()
            }
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            self.lastMouseDate = Date()
            self.checkForActivity()
        }
    }
    
    func checkForActivity() {
        let difference = lastMouseDate.timeIntervalSince(lastKeyDate)
        
        if difference > timeout {
            showNotification()
        }
    }
    
    func makeNotification() {
        notification.title = "Productive"
        notification.informativeText = "You haven't touched the keyboard in a while..."
    }
    
    func didClickStatusItem(sender: Any) {
        print("did click status item")
    }
    
    func showNotification() {
        if lastNotificationDate.timeIntervalSince(Date()) < 60 { return }
        
        NSUserNotificationCenter.default.deliver(notification)
        lastNotificationDate = Date()
    }
}

