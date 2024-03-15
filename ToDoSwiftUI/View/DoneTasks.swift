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
                lanzaNotificacion()
            }) {
                Text("Se han completado \(model.itemsTerminados) items (Dianelys)")
            }.buttonStyle(BorderedProminentButtonStyle())
        }
        .onAppear() {
            model.removeCompletedItems()
        }
    }
}

func lanzaNotificacion() {
    let content = UNMutableNotificationContent()
    content.title = "Introducción a Notificaciones"
    content.body = "Mensaje de prueba"
    content.sound = UNNotificationSound.default
    if let attachment = UNNotificationAttachment.create(identifier: "prueba",
                                                        image: UIImage(named: "gatito.png")!,
                                                        options: nil) {
        content.attachments = [attachment]
    }
    content.userInfo = ["Mensaje":"Hola, estoy en la demo"]
    content.categoryIdentifier = "invitacion"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let requestIdentifier = "peticionEjemplo"
    let request = UNNotificationRequest(identifier: requestIdentifier,
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request) {
        (error) in
        if (error != nil) {
            print ("Error al lanzar la notificación: \(String(describing: error))")
        } else {
            print("Notificación lanzada correctamente")
        }
    }
}

extension UNNotificationAttachment {
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = image.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}

#Preview {
    DoneTasks()
        .environment(ToDoModel())
}
