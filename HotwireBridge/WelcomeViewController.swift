//
//  WelcomeViewController.swift
//  HotwireBridge
//
//  Created by apple on 15/01/26.
//

import UIKit
import HotwireNative

class WelcomeViewController: UIViewController, PathConfigurationIdentifiable {
    static var pathConfigurationIdentifier: String { "welcome" }
    weak var navigator: Navigator?
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                
        let titleLabel = UILabel()
        titleLabel.text = "Welcome!"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = "Your account has been created successfully"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Get Started", for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                continueButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
                continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                continueButton.widthAnchor.constraint(equalToConstant: 200),
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc private func continueTapped() {
            let userId = 5 // Replace with dynamic ID if needed
            guard let profileURL = URL(string: "http://192.168.1.15:3000/profiles/\(userId).json") else { return }
            
            navigator?.route(profileURL)
    }

}
