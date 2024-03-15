//
//  ToDoSwiftUIApp.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import SwiftUI

@main
struct ToDoSwiftUIApp: App {
    
    @State private var model = ToDoModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ToDoList()
                .environment(model)
        }
    }
}
