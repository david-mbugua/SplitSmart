//
//  SplitSmartApp.swift
//  SplitSmart
//
//  Created by David Mbugua on 25/03/2025.
//

import SwiftUI
import SwiftData

@main
struct SplitSmartApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    // ADD: Configure SwiftData model container
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Expense.self, Group.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                // CHANGE: Use modelContainer modifier instead of environment
                .modelContainer(modelContainer)
        }
    }
}
