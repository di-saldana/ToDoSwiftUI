//
//  ToDoList.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import SwiftUI
import CloudKit

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
            .refreshable {
                loadDataFromICloud()
            }
        }
    }
    
    private func loadDataFromICloud() {
        var iCloudItems: [ToDoItem] = []
        
        let privateDB = CKContainer.default().privateCloudDatabase
        let privateQuery = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
        
        privateDB.fetch(withQuery: privateQuery) { (privateResult) in
            switch privateResult {
            case .success(let privateRecords):
                for (_, privateRecordResult) in privateRecords.matchResults {
                    if case .success(let record) = privateRecordResult {
                        if let nombre = record["nombre"] as? String {
                            let isPublic = record["publica"] as? Bool ?? true
                            let toDoItem = ToDoItem(nombreItem: nombre, publica: isPublic)
                            iCloudItems.append(toDoItem)
                        }
                    }
                }
            case .failure(let privateError):
                print("Error fetching private records: \(privateError)")
            }
            
            let publicDB = CKContainer.default().publicCloudDatabase
            let publicQuery = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
            
            publicDB.fetch(withQuery: publicQuery) { (publicResult) in
                switch publicResult {
                case .success(let publicRecords):
                    for (_, publicRecordResult) in publicRecords.matchResults {
                        if case .success(let record) = publicRecordResult {
                            if let nombre = record["nombre"] as? String {
                                let isPublic = record["publica"] as? Bool ?? false
                                let toDoItem = ToDoItem(nombreItem: nombre, publica: isPublic)
                                iCloudItems.append(toDoItem)
                            }
                        }
                    }
                case .failure(let publicError):
                    print("Error fetching public records: \(publicError)")
                }
                
                DispatchQueue.main.async {
                    for item in iCloudItems {
                        if !model.toDoItems.contains(where: { $0.nombreItem == item.nombreItem }) {
                            model.addItem(item: item)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ToDoList()
        .environment(ToDoModel())
}

