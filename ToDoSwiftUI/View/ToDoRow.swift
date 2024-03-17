//
//  ToDoRow.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import SwiftUI

struct ToDoRow: View {
    @Environment(\.colorScheme) var colorScheme
    var item: ToDoItem
    
    var body: some View {
        HStack {
            Text(item.nombreItem)
                .foregroundColor(!item.publica ? .blue : (colorScheme == .dark ? .white : .black))
            Spacer()
            if item.completado {
                Image(systemName: "checkmark")
            }
        }
    }
}

#Preview {
    ToDoRow(item: ToDoItem(nombreItem: "Item de ejemplo"))
}
