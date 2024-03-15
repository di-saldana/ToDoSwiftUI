//
//  ToDoList.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import SwiftUI

struct ToDoList: View {
    
    @Environment(ToDoModel.self) private var model
        
    @State var isAddItemPresented : Bool = false

    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            List() {
                ForEach($model.toDoItems) { $item in
                    ToDoRow(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            item.completado.toggle()
                            item.fechaFinalizacion = Date()
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Done") {
                        DoneTasks()
                    }
                    .navigationTitle("Lista To-Do")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Item", systemImage: "plus") {
                        self.isAddItemPresented = true
                    }
                }
            }
            .sheet(isPresented: $isAddItemPresented) {
                // Creamos vista modal para añadir una nueva tarea
                AddTask()
            }
        }
    }
    
}

#Preview {
    ToDoList()
        .environment(ToDoModel())
}

