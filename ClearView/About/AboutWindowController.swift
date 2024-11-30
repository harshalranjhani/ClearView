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
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 600),
            styleMask: [.titled, .closable, .fullSizeContentView],
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
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        
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

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Dynamic background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(colorScheme == .dark ? .darkGray : .white),
                    Color(colorScheme == .dark ? .black : .gray).opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // App Icon with modern design
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 120, height: 120)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "rectangle.stack")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    // App Info
                    VStack(spacing: 12) {
                        Text("ClearView")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("Instant Focus Mode for Your Mac")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    // Feature Cards
                    VStack(spacing: 15) {
                        FeatureCard(
                            icon: "rectangle.stack.badge.minus",
                            title: "One-Click Focus",
                            description: "Instantly hide all windows except your current one"
                        )
                        FeatureCard(
                            icon: "keyboard",
                            title: "Global Shortcut",
                            description: "Trigger from anywhere with a quick keyboard shortcut"
                        )
                        FeatureCard(
                            icon: "video.fill",
                            title: "Perfect for Presentations",
                            description: "Clean up your screen instantly while sharing or recording"
                        )
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                    
                    // Social Links
                    VStack(spacing: 12) {
                        SocialLinkButton(
                            icon: "globe",
                            text: "Visit Website",
                            url: "https://clearview.harshalranjhani.in"
                        )
                        
                        SocialLinkButton(
                            icon: "envelope",
                            text: "Contact Support",
                            url: "mailto:dev@harshalranjhani.in"
                        )
                    }
                    
                    // Copyright
                    Text("© 2024 Harshal Ranjhani. All rights reserved.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 20)
                }
                .padding()
            }
        }
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

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SocialLinkButton: View {
    let icon: String
    let text: String
    let url: String
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                Text(text)
                    .fontWeight(.medium)
            }
            .frame(width: 220)
            .padding(.vertical, 12)
        }
        .buttonStyle(ModernButtonStyle())
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

struct ModernButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(LinearGradient(
                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}
