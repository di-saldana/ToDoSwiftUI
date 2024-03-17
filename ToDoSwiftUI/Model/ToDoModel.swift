//
//  ToDoData.swift
//  ToDoSwiftUI
//
//  Created by Miguel Angel Lozano Ortega on 30/1/24.
//

import Foundation
import CloudKit

@Observable
class ToDoModel {
    var toDoItems: [ToDoItem] = []
    var itemsTerminados: Int = 0
    
    let iCloudStore = NSUbiquitousKeyValueStore.default

    init() {
        loadItems()
        NotificationManager.shared.requestAuthorization()
    }
    
    func loadItems() {
        itemsTerminados = Int(iCloudStore.longLong(forKey: "itemsTerminados"))
        
        let privateDB = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
        
        privateDB.fetch(withQuery: query, completionHandler: { (result) in
            switch result {
                case .success(let records):
                    for (_, recordResult) in records.matchResults {
                        if case .success(let record) = recordResult {
                            if let nombre = record["nombre"] as? String {
                                let isPublic = record["publica"] as? Bool ?? true
                                let toDoItem = ToDoItem(nombreItem: nombre, publica: isPublic)
                                self.toDoItems.append(toDoItem)
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print("Error al cargar: \(error)")
                    break
            }
        })
        
        let publicDB = CKContainer.default().publicCloudDatabase
        let publicQuery = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
        
        publicDB.fetch(withQuery: publicQuery, completionHandler: { (result) in
            switch result {
                case .success(let records):
                    for (_, recordResult) in records.matchResults {
                        if case .success(let record) = recordResult {
                            if let nombre = record["nombre"] as? String {
                                let isPublic = record["publica"] as? Bool ?? false
                                let toDoItem = ToDoItem(nombreItem: nombre, publica: isPublic)
                                self.toDoItems.append(toDoItem)
                            }
                        }
                    }
                case .failure(let error):
                    print("Error al cargar tareas públicas: \(error)")
            }
        })
    }
    
    func loadTestData() {
        toDoItems.append(ToDoItem(nombreItem: "Poner lavadora"))
        toDoItems.append(ToDoItem(nombreItem: "Pagar recibo seguro"))
        toDoItems.append(ToDoItem(nombreItem: "Terminar ejercicios iOS"))
    }
        
    func addItem(item: ToDoItem, toPublicDatabase: Bool = false) {
        toDoItems.append(item)
        
        if toPublicDatabase {
            saveTareaToPublicDatabase(item: item)
        } else {
            saveTarea(item: item)
        }
    }
    
    func addItem(nombreItem: String, toPublicDatabase: Bool = false) {
        if toPublicDatabase {
            addItem(item: ToDoItem(nombreItem: nombreItem), toPublicDatabase: true)
        } else {
            addItem(item: ToDoItem(nombreItem: nombreItem), toPublicDatabase: false)
        }
    }

    func removeCompletedItems() {
        var itemsPendientes = [ToDoItem]()
        for toDoItem in toDoItems {
            if (!toDoItem.completado) {
                itemsPendientes.append(toDoItem)
            } else {
                itemsTerminados += 1
                deleteTarea(toDoItem)
                iCloudStore.set(Int64(itemsTerminados), forKey: "itemsTerminados")
                iCloudStore.synchronize()
            }
        }
        toDoItems = itemsPendientes
    }
    
    func deleteTarea(_ toDoItem: ToDoItem) {
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "nombre == %@", toDoItem.nombreItem)
        let query = CKQuery(recordType: "Tarea", predicate: predicate)
        
        privateDB.fetch(withQuery: query, completionHandler: { (result) in
            switch result {
            case .success(let records):
                for (_, recordResult) in records.matchResults {
                    if case .success(let record) = recordResult {
                        privateDB.delete(withRecordID: record.recordID) { (recordID, error) in
                            if let error = error {
                                print("Error deleting record: \(error.localizedDescription)")
                                return
                            }
                            print("Record deleted successfully")
                        }
                    }
                }
            case .failure(_):
                print("Failed to fetch records for deletion")
            }
        })
    }
    
    func saveTarea(item: ToDoItem) {
        let record = CKRecord(recordType: "Tarea")
        record["nombre"] = item.nombreItem as CKRecordValue
        record["publica"] = false as CKRecordValue
        let privateDB = CKContainer.default().privateCloudDatabase
        
        privateDB.save(record) { (savedRecord, error) in
            if let error = error {
                print("Error al guardar tarea en CloudKit: \(error.localizedDescription)")
                return
            }
            print("Tarea guardada en CloudKit")
        }
    }
    
    private func saveTareaToPublicDatabase(item: ToDoItem) {
        let record = CKRecord(recordType: "Tarea")
        record["nombre"] = item.nombreItem as CKRecordValue
        record["publica"] = true as CKRecordValue
        let publicDB = CKContainer.default().publicCloudDatabase
        
        publicDB.save(record) { (savedRecord, error) in
            if let error = error {
                print("Error al guardar tarea en CloudKit (pública): \(error.localizedDescription)")
                return
            }
            print("Tarea guardada en CloudKit (pública)")
        }
    }

}
