//
//  ToDoItem.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import Foundation

struct ToDoItem: Identifiable {
    var id = UUID()
    var nombreItem: String
    var completado: Bool = false
    var fechaFinalizacion: Date? = nil        
}
