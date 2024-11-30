//
//  StatusBarController.swift
//  ClearView
//
//  Created by Harshal Ranjhani on 11/30/24.
//


import Cocoa

class StatusBarController {
    private var statusItem: NSStatusItem!
    private var aboutWindowController: AboutWindowController?

    private var toggleMenuItem: NSMenuItem?
    
    init() {
        setupStatusBar()
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "rectangle.stack", accessibilityDescription: "ClearView")
        }
        
        setupMenu()
        registerHotkey()
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        // Create menu items with explicit target and action
        let toggleItem = NSMenuItem(title: "Toggle Windows (⌥⌘H)", action: #selector(toggleWindows), keyEquivalent: "")
        toggleItem.target = self
        
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        
        let aboutItem = NSMenuItem(title: "About ClearView", action: #selector(openAbout), keyEquivalent: "")
        aboutItem.target = self
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        // Add items to menu
        menu.addItem(toggleItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(settingsItem)
        menu.addItem(aboutItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc private func openSettings() {
       //
    }
    
    @objc private func openAbout() {
        if aboutWindowController == nil {
            aboutWindowController = AboutWindowController()
        }
        
        aboutWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func registerHotkey() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Check for Option(⌥) + Command(⌘) + H
            if event.modifierFlags.contains([.option, .command]) && event.keyCode == 4 { // 4 is the keycode for 'H'
                self?.toggleWindows()
            }
        }
    }
    
    @objc private func toggleWindows() {
        WindowManager.shared.toggleWindows()
    }
}
