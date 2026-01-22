//
//  ProfileViewController.swift
//  HotwireBridge
//
//  Created by apple on 20/01/26.
//
import UIKit
import HotwireNative

// Add the Profile model
struct Profile: Codable {
    let name: String
    let email: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case avatarUrl = "avatar_url"
    }
}

class ProfileViewController : UIViewController, PathConfigurationIdentifiable {
    static var pathConfigurationIdentifier: String { "profile" }
    weak var navigator: Navigator?
    
    private var profileData: Profile?
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        print("🎯 ProfileViewController initialized with URL: \(url)")
                print("🎯 URL Path: \(url.path)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchProfile()
    }
    
    private func setupUI(){
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.font =  .systemFont(ofSize: 18)
        emailLabel.textColor = .secondaryLabel
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
           avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
           avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           avatarImageView.widthAnchor.constraint(equalToConstant: 100),
           avatarImageView.heightAnchor.constraint(equalToConstant: 100),

           nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
           nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

           emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
           emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func fetchProfile(){
        var jsonURL = url
                if !url.pathExtension.isEmpty {
                    jsonURL = url.deletingPathExtension()
                }
                jsonURL = jsonURL.appendingPathExtension("json")
                
                print("📡 Fetching profile from: \(jsonURL)")
        
        let task = URLSession.shared.dataTask(with: jsonURL) { data, response, error in
            guard let data else { return }
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                DispatchQueue.main.async {
                    self.profileData = profile
                    self.updateUI()
                }
            } catch {
                print("Failed to decode profile:", error)
            }
        }
      task.resume()
    }
    
    private func updateUI() {
        guard let profile = profileData else { return }
        nameLabel.text = profile.name
        emailLabel.text = profile.email
        if let avatarURL = URL(string: profile.avatarUrl) {
            // Simple image loading
            URLSession.shared.dataTask(with: avatarURL) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
