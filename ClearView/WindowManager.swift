//
//  WindowManager.swift
//  ClearView
//
//  Created by Harshal Ranjhani on 11/30/24.
//

import Cocoa

class WindowManager {
    static let shared = WindowManager()
    private var hiddenWindows: [(application: NSRunningApplication, windowNumber: Int)] = []
    
    func toggleWindows() {
        if hiddenWindows.isEmpty {
            minimizeOtherWindows()
        } else {
            restoreWindows()
        }
    }
    
    private func minimizeOtherWindows() {
        guard let currentApp = NSWorkspace.shared.frontmostApplication else { return }
        let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
        let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] ?? []
        
        for window in windowList {
            guard let windowNumber = window[kCGWindowNumber as String] as? Int,
                  let pid = window[kCGWindowOwnerPID as String] as? pid_t,
                  let app = NSRunningApplication(processIdentifier: pid),
                  pid != currentApp.processIdentifier,
                  let layer = window[kCGWindowLayer as String] as? Int,
                  layer == 0
            else { continue }
            
            if let bundleIdentifier = app.bundleIdentifier {
                hiddenWindows.append((application: app, windowNumber: windowNumber))
                
                let script = """
                tell application "System Events"
                    tell application process "\(app.localizedName ?? "")"
                        if exists window 1 then
                            perform action "AXMinimize" of window 1
                        end if
                    end tell
                end tell
                """
                
                var error: NSDictionary?
                if let scriptObject = NSAppleScript(source: script) {
                    scriptObject.executeAndReturnError(&error)
                    if let error = error {
                        print("AppleScript error for \(app.localizedName ?? ""): \(error)")
                    }
                }
            }
        }
        print("Minimized windows count: \(hiddenWindows.count)")
    }
    
    private func restoreWindows() {
        for window in hiddenWindows {
            // First activate the app
            window.application.activate(options: .activateIgnoringOtherApps)
            
            let script = """
            tell application "System Events"
                tell application process "\(window.application.localizedName ?? "")"
                    if exists window 1 then
                        perform action "AXRaise" of window 1
                        set value of attribute "AXMinimized" of window 1 to false
                    end if
                end tell
            end tell
            """
            
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: script) {
                scriptObject.executeAndReturnError(&error)
                if let error = error {
                    print("AppleScript error for \(window.application.localizedName ?? ""): \(error)")
                }
            }
            
            // Small delay to allow windows to animate
            Thread.sleep(forTimeInterval: 0.1)
        }
        hiddenWindows.removeAll()
    }
}
