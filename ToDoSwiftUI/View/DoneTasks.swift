//
//  DoneTasks.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 13/2/24.
//

import SwiftUI

struct DoneTasks: View {
    @Environment(ToDoModel.self) private var model
    
    var body: some View {
        VStack {
            Text("Se han completado \(model.itemsTerminados) items \n (Dianelys)")
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
