//
//  BookScoutApp.swift
//  BookScout
//
//  Created by Niklas Fischer on 17/6/23.
//

import SwiftUI

@main
struct BookScoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
