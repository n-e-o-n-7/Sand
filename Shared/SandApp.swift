//
//  SandApp.swift
//  Shared
//
//  Created by 许滨麟 on 2021/5/23.
//

import SwiftUI

@main
struct SandApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
