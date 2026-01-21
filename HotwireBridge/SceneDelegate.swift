import HotwireNative
import UIKit

let rootURL = URL(string: "http://192.168.1.15:3000")!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
//    private lazy var pathConfiguration = PathConfiguration(sources: [
//            .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!)
//        ])
    
    private lazy var pathConfiguration: PathConfiguration = {
            guard let url = Bundle.main.url(forResource: "path-configuration", withExtension: "json") else {
                print("❌ ERROR: path-configuration.json NOT FOUND!")
                fatalError("Missing path-configuration.json")
            }
            print("✅ Found path-configuration.json at: \(url)")
            
            // Read and print the JSON content
            if let data = try? Data(contentsOf: url),
               let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON Content:\n\(jsonString)")
            }
            
            return PathConfiguration(sources: [.file(url)])
        }()
    
    private lazy var navigator: Navigator = {
            let nav = Navigator(
                configuration: .init(
                    name: "main",
                    startLocation: rootURL
                ),
                delegate: self
            )
        nav.session.pathConfiguration = pathConfiguration
        print("✅ Navigator created and pathConfiguration set")
            return nav
        }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = navigator.rootViewController
        navigator.start()
    }
}

extension SceneDelegate: NavigatorDelegate {
    func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
        print("==================================================")
               print("🔔 NAVIGATION DETECTED!")
               print("📍 Full URL: \(proposal.url)")
               print("📍 URL Path: \(proposal.url.path)")
               print("📍 URL Last Component: \(proposal.url.lastPathComponent)")
               print("📍 View Controller: \(proposal.viewController ?? "nil")")
               print("📍 Context: \(proposal.context)")
               print("📍 Presentation: \(proposal.presentation)")
        // Check for native screens
        switch proposal.viewController {
        case WelcomeViewController.pathConfigurationIdentifier:
            let welcomeVC = WelcomeViewController(url: proposal.url)
            welcomeVC.navigator = navigator
            return .acceptCustom(welcomeVC)
        case ProfileViewController.pathConfigurationIdentifier:
            let profileVC = ProfileViewController(url: proposal.url)
            print("profileVC")
            return .acceptCustom(profileVC)
        default:
            return .accept
        }
    }
}
