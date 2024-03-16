//
//  ToDoData.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import Foundation

@Observable
class ToDoModel {
    var toDoItems: [ToDoItem] = []
    var itemsTerminados: Int = 0

    init() {
        loadTestData()
        NotificationManager.shared.requestAuthorization()
    }
    
    func loadTestData() {
        toDoItems.append(ToDoItem(nombreItem: "Poner lavadora"))
        toDoItems.append(ToDoItem(nombreItem: "Pagar recibo seguro"))
        toDoItems.append(ToDoItem(nombreItem: "Terminar ejercicios iOS"))
    }
        
    func addItem(item: ToDoItem) {
        toDoItems.append(item)
    }
    
    func addItem(nombreItem: String) {
        addItem(item: ToDoItem(nombreItem: nombreItem))
    }

    func removeCompletedItems() {
        var itemsPendientes = [ToDoItem]()
        for toDoItem in toDoItems {
            if (!toDoItem.completado) {
                itemsPendientes.append(toDoItem)
            } else {
                itemsTerminados += 1
            }
        }
        toDoItems = itemsPendientes
    }
    
}

