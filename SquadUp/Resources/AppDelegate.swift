//
//  AppDelegate.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/1/20.
//

import UIKit
import CoreData
import ChatSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SquadUp-v4")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    func saveContext() {
       let context = persistentContainer.viewContext
       if context.hasChanges {
         do {
           try context.save()
         } catch {
           let error = error as NSError
           fatalError("Unresolved error \(error), \(error.userInfo)")
         }
       }
     }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let tabBarVC = UITabBarController()
        tabBarVC.addChild(GameMapViewController())
        self.window?.rootViewController = GameMapViewController()
        self.window?.makeKeyAndVisible()
       
        /* Uncomment to view chat UI features
        let config = BConfiguration.init();
        config.rootPath = "test"
        // Configure other options here...
        config.googleMapsApiKey = "AIzaSyBo262rV-7JGB-h7ASN4aggtB_Zg_4hw6w"
        config.allowUsersToCreatePublicChats = true
        
        BChatSDK.initialize(config, app: application, options: launchOptions)
        AddContactWithQRCodeModule().activate()

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BChatSDK.ui()?.splashScreenNavigationController()
        self.window?.makeKeyAndVisible();
         */
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BChatSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return BChatSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }

}

