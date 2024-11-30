//
//  AboutWindowController.swift
//  ClearView
//
//  Created by Harshal Ranjhani on 12/1/24.
//


import SwiftUI

class AboutWindowController: NSWindowController {
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 500),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "About ClearView"
        window.contentView = NSHostingView(rootView: AboutView())
        window.center()
        window.level = .floating
        
        // Set identifier for state restoration
        window.identifier = NSUserInterfaceItemIdentifier("AboutWindow")
        
        // Make it center-positioned relative to the screen
        if let screen = NSScreen.main {
            let screenRect = screen.frame
            let windowRect = window.frame
            let x = screenRect.midX - windowRect.width / 2
            let y = screenRect.midY - windowRect.height / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
        self.init(window: window)
        
        // Set window delegate to handle window closing
        window.delegate = self
    }
}

// Handle window closing
extension AboutWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // Clean up when window is closed
        if let windowController = notification.object as? NSWindowController {
            windowController.window?.delegate = nil
        }
    }
}

// AboutView remains the same
struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            // App Icon
            Image(systemName: "rectangle.stack")
                .resizable()
                .frame(width: 128, height: 128)
                .foregroundColor(.blue)
                .padding()
            
            // App Name
            Text("ClearView")
                .font(.system(size: 28, weight: .bold))
            
            // Version
            Text("Version 1.0.0")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            // Description
            Text("A minimal window management tool for macOS")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical)
            
            // Contact Info
            VStack(spacing: 12) {
                LinkButton(
                    icon: "globe",
                    text: "Website",
                    url: "https://yourwebsite.com"
                )
                
                LinkButton(
                    icon: "envelope",
                    text: "Contact",
                    url: "mailto:your@email.com"
                )
                
                LinkButton(
                    icon: "star",
                    text: "Rate on App Store",
                    url: "https://apps.apple.com/app/yourapp"
                )
            }
            
            Spacer()
            
            // Copyright
            Text("© 2024 Your Name. All rights reserved.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct LinkButton: View {
    let icon: String
    let text: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(text)
            }
            .frame(width: 200)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}
