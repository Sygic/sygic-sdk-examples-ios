import UIKit
import SygicMaps

extension Notification.Name {
    static let DidInitSygicMaps = Notification.Name("DidInitSygicMaps")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let initRequest = SYContextInitRequest(configuration: [
            "Authentication": [
                "app_key": NoCommitConstants.appKey // in case of error, see NoCommitConstants-TEMPLATE.txt
            ],
            "MapReaderSettings": [
                "startup_online_maps_enabled": true
            ]
        ])
        SYContext.initWithRequest(initRequest) { (result, description) in
            if result == .success {
                // since now, the app can use SygicMaps functionality
                print("SygicMaps init success")
                NotificationCenter.default.post(name: .DidInitSygicMaps, object: nil)
            } else {
                // handle SygicMaps initialization fail
                print("Error: SygicMaps init failed (\(result.rawValue)): \(description)")
            }
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SYContext.terminate()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
