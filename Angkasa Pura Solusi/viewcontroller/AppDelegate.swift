//
//  AppDelegate.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var mainNavigationController : UINavigationController?
    
    lazy var preference: Preference = { return Preference() }()    
    lazy var staticLet: StaticLet = { return StaticLet() }()

    func changeRootViewController(rootVC : UIViewController){
        mainNavigationController = UINavigationController(rootViewController: rootVC)
        mainNavigationController?.isNavigationBarHidden = true
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = self.mainNavigationController
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcm token \(fcmToken)")
        preference.saveString(value: fcmToken, key: staticLet.FCM_TOKEN)
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //root viewcontroller
        changeRootViewController(rootVC: SplashController())
        
        //keyboard manager
        IQKeyboardManager.shared.enable = true
        
        //google maps
        let releaseKey = "AIzaSyBt-Sef6bIAiMI-412Fg9LeoNGC3aKFnl8"
        let oldMapsKey = "AIzaSyABb3r3kEysXc1ahNhBczZfpFbKCTcEUZY"
        GMSServices.provideAPIKey(oldMapsKey)
        
        //firebase
        FirebaseApp.configure()
        
        //notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print("Receive data message: \(remoteMessage.appData)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // set which screen to proceed when user tap screen
        print("notification data: \(userInfo)")
        //changeRootViewController(rootVC: HomeController())
        
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

