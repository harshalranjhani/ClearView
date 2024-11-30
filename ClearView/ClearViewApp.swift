//
//  ClearViewApp.swift
//  ClearView
//
//  Created by Harshal Ranjhani on 11/30/24.
//

import SwiftUI
import AppKit

@main
struct ClearViewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        requestPermissions()
        statusBarController = StatusBarController()
    }
    
    private func requestPermissions() {
        // Request automation permission
        let systemEventsScript = """
        tell application "System Events"
        end tell
        """
        
        if let scriptObject = NSAppleScript(source: systemEventsScript) {
            var error: NSDictionary?
            scriptObject.executeAndReturnError(&error)
            
            if error != nil {
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Permissions Required"
                    alert.informativeText = "ClearView needs permission to control your windows. Please enable automation permissions in System Settings."
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "Open System Settings")
                    alert.addButton(withTitle: "Later")
                    
                    if alert.runModal() == .alertFirstButtonReturn {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!)
                    }
                }
            }
        }
    }
}
