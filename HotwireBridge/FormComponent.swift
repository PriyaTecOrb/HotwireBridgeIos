import HotwireNative
import UIKit

@MainActor
final class FormComponent: BridgeComponent {
    override class nonisolated(unsafe) var name: String { "native-form" }
    
    override func onReceive(message: Message) {
        guard let data: MessageData = message.data() else { return }
        
        switch message.event {
                case "showNativeForm":
                    presentForm(
                        title: "Edit Profile",
                        fields: data.fields,
                        event: message.event
                    )

                case "showSignupForm":
                    presentForm(
                        title: "Sign Up",
                        fields: data.fields,
                        event: message.event
                    )

                default:
                    break
                }
            }
    
    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }

        private func presentForm(title: String, fields: [FormField],event: String) {
            guard let viewController = viewController else { return }
            
            let alert = UIAlertController(
                title: "Fill Form",
                message: "Enter your information",
                preferredStyle: .alert
            )
            
            for field in fields {
                alert.addTextField { textField in
                    textField.placeholder = field.label
                    textField.keyboardType = field.type == "email" ? .emailAddress : .default
                    textField.isSecureTextEntry = field.type == "password"
                }
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
                var formData: [String: String] = [:]
                
                for (index, field) in fields.enumerated() {
                    if let textField = alert.textFields?[index] {
                        formData[field.name] = textField.text ?? ""
                    }
                }
                
                let response = FormResponse(
                                        submitted: true,
                                        data: formData
                                    )

                self.reply(to: event, with: response)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                let response = FormResponse(
                                submitted: false,
                                data: [:]
                            )

                            self.reply(to: event, with: response)
            })
            
            viewController.present(alert, animated: true)
        }
}

// MARK: - Data Models

private extension FormComponent {
    struct MessageData: Decodable {
        let fields: [FormField]
    }
    
    struct FormField: Decodable {
        let name: String
        let type: String
        let label: String
    }
    
    // Response struct
    struct FormResponse: Encodable {
        let submitted: Bool
        let data: [String: String]
    }
}
