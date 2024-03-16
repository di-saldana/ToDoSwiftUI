//
//  AppDelegate.swift
//  ToDoSwiftUI
//
//  Created by Dianelys Saldaña on 3/15/24.
//

import UIKit
import UserNotifications
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var vecesPulsadaNotificacion = 0
    
    // MARK: - Delegates
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in print(granted)}
        print("En didFinishLanuchingWithOptions")
        let action1 = UNNotificationAction(identifier:"acepto", title: "Acepto", options: [])
        let action2 = UNNotificationAction(identifier:"otro", title: "Otro día", options: [])
        let action3 = UNTextInputNotificationAction(identifier: "mensaje", title: "Mensaje", options: [],
                                                    textInputButtonTitle: "Enviar", textInputPlaceholder: "Comentario")
        let category = UNNotificationCategory(identifier: "invitacion", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("En applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("En applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
          print("En applicationWillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Voy a pedir los settigs")
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler:
            {(settings: UNNotificationSettings) in
                if (settings.alertSetting == UNNotificationSetting.enabled) {
                    print("Alert enabled")
                } else {
                    print("Alert not enabled")
                }
                if (settings.badgeSetting == UNNotificationSetting.enabled) {
                    print("Badge enabled")
                } else {
                    print("Badge not enabled")
                }})
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("En applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("En applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("En userNotificationCenter willPresent notification")
        let userInfo = notification.request.content.userInfo
        let mensaje = userInfo["Mensaje"] as! String
        print("Mensaje: \(mensaje)")
        completionHandler([.list, .banner, .sound]) // .alert
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("En userNotificationCenter didReceive response")
        if let textInput = response as? UNTextInputNotificationResponse {
            print("Repuesta del usuario: \(textInput.userText)")
        } else {
            print("Acción escogida: \(response.actionIdentifier)")
        }
        let userInfo = response.notification.request.content.userInfo
        let mensaje = userInfo["Mensaje"] as! String
        print("Mensaje: \(mensaje)")
        
        // Actualizamos la variables de estado relacionada con la notificación
        // y modificamos la interfaz de usuario accediendo al rootViewController
        
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
