//
//  AppDelegate.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/23/21.
//

import UIKit
import CoreData
import MobileRTC
import SkeletonView

let sdkUserID: String = "trandinhtonhieu2@gmail.com"
let sdkKey: String = "4ZYpiKOuWpLha1YFHtkNOYnRan43sKXvi1lw"
let sdkSecret: String = "a1PeJyrXUI6rV3LGlq80j4GuOF5EKlzeIKDx"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Set up light mode only for this application.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // Set up MobileRTC SDK
        setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: .clouds)
        SkeletonAppearance.default.multilineCornerRadius = 2
        
        // Open LaunchViewController first.
        let launchVC = LaunchViewController()
        self.window?.rootViewController = launchVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Study_Saga")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - MobileRTC Set up
    
    // 2. Create a method that handles the initialization and authentication of the SDK
    func setupSDK(sdkKey: String, sdkSecret: String) {
        
        // Create a MobileRTCSDKInitContext. This class contains
        // attributes for determining how the SDK will be used.
        // You must supply the context with a domain.
        let context = MobileRTCSDKInitContext()
        // The domain we will use is zoom.us
        context.domain = "zoom.us"
        // Turns on SDK logging. This is optional.
        context.enableLog = true
        
        // Call initialize(_ context: MobileRTCSDKInitContext) to create an instance of the Zoom SDK.
        // Without initialization, the SDK will not be operational.
        // This call will return true if the SDK was initialized successfully.
        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)
        
        if sdkInitializedSuccessfully == true,
           let authorizationService = MobileRTC.shared().getAuthService() {
            authorizationService.clientKey = sdkKey
            authorizationService.clientSecret = sdkSecret
            authorizationService.delegate = self
            authorizationService.sdkAuth()
        }
    }
}

extension AppDelegate: MobileRTCAuthDelegate {
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case .success:
            print("SDK successfully initialized.")
        case .keyOrSecretEmpty:
            assertionFailure("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case .keyOrSecretWrong, .unknown:
            assertionFailure("SDK Key/Secret is not valid.")
        default:
            assertionFailure("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
        }
    }
}

