//
//  DoneTasks.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 13/2/24.
//

import SwiftUI
import UserNotifications

struct DoneTasks: View {
    @Environment(ToDoModel.self) private var model
    
    var body: some View {
        VStack {
            Button(action: {
                NotificationManager.shared.lanzaNotificacion()
            }) {
                Text("Se han completado \(model.itemsTerminados) items (Dianelys)")
            }.buttonStyle(BorderedProminentButtonStyle())
        }
        .onAppear() {
            model.removeCompletedItems()
        }
    }
}

#Preview {
    DoneTasks()
        .environment(ToDoModel())
}
