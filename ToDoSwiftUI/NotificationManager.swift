//
//  NotificationManager.swift
//  ToDoSwiftUI
//
//  Created by Dianelys Saldaña on 3/16/24.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    var vecesPulsadaNotificacion = 0

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        requestAuthorization()
        setupNotificationCategories()
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission approved!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func setupNotificationCategories() {
        let action1 = UNNotificationAction(identifier:"acepto", title: "Acepto", options: [])
        let action2 = UNNotificationAction(identifier:"otro", title: "Otro día", options: [])
        let action3 = UNTextInputNotificationAction(identifier: "mensaje", title: "Mensaje", options: [],
                                                    textInputButtonTitle: "Enviar", textInputPlaceholder: "Comentario")
        let category = UNNotificationCategory(identifier: "invitacion", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
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
            if let error = error {
                print ("Error al lanzar la notificación: \(error)")
            } else {
                print("Notificación lanzada correctamente")
            }
        }
    }

    // UNUserNotificationCenterDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let mensaje = userInfo["Mensaje"] as! String
        print("Mensaje: \(mensaje)")
        completionHandler([.list, .banner, .sound]) // .alert
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let textInput = response as? UNTextInputNotificationResponse {
            print("Repuesta del usuario: \(textInput.userText)")
        } else {
            print("Acción escogida: \(response.actionIdentifier)")
        }
        let userInfo = response.notification.request.content.userInfo
        let mensaje = userInfo["Mensaje"] as! String
        print("Mensaje: \(mensaje)")

        vecesPulsadaNotificacion += 1

        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Acción escogida",
                                                    message: "La acción escogida fue: \(response.actionIdentifier)",
                                                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }

        completionHandler()
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
