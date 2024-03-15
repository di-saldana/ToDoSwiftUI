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
    
    var body: some View {
        NavigationView {
            List {
                TextField("Descripción de la tarea", text: $item.nombreItem).focused($isFocused)
            }.toolbar() {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if(!item.nombreItem.isEmpty) {
                            model.addItem(item: item)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }.onAppear() {
                isFocused = true
            }
        
        }
    }
}

#Preview {
    AddTask()
        .environment(ToDoModel())
}
