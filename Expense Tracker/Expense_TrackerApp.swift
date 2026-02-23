//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Asim on 20/02/2026.
//

import SwiftData
import SwiftUI

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Transaction.self)
    }
}
