//
//  AddTask.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 13/2/24.
//

import SwiftUI

struct AddTask: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ToDoModel.self) private var model
    @State private var item: ToDoItem = ToDoItem(nombreItem: "")
    @FocusState private var isFocused: Bool
    @State private var isShowingActionSheet = false
    
    var body: some View {
        NavigationView {
            List {
                TextField("Descripción de la tarea", text: $item.nombreItem).focused($isFocused)
            }.toolbar() {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !item.nombreItem.isEmpty {
                            isShowingActionSheet = true
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(title: Text("Añadir a"), buttons: [
                    .default(Text("Récord Público")) {
                        model.addItem(item: item, toPublicDatabase: true)
                        dismiss()
                    },
                    .default(Text("Récord Privado")) {
                        model.addItem(item: item, toPublicDatabase: false)
                        dismiss()
                    },
                    .cancel()
                ])
            }
            .onAppear() {
                isFocused = true
            }
            .navigationTitle("Añadir Tarea")
        }
    }
}

#Preview {
    AddTask()
        .environment(ToDoModel())
}
