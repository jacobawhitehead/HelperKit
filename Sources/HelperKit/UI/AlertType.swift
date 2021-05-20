//
//  AlertType.swift
//  Tiidy
//
//  Created by Jacob Whitehead on 19/05/2021.
//

import UIKit

public enum AlertComponent {
    case cancel
    case okay
    case action(title: String, style: UIAlertAction.Style, action: () -> Void)
    case textField((UITextField) -> Void)
}

public struct AlertType {
    public let title: String?
    public let message: String?
    public var components: [AlertComponent]

    public init(title: String?, message: String? = nil, components: [AlertComponent] = []) {
        self.title = title
        self.message = message
        self.components = components
    }

    @discardableResult
    public mutating func addComponent(_ component: AlertComponent) -> Self {
        components.append(component)
        return self
    }

}

// MARK: - Helpers

public extension AlertType {

    func alert() -> UIAlertController {
        createController(isAlert: true)
    }

    func actionSheet(target: CGRect? = nil) -> UIAlertController {
        let controller = createController(isAlert: false)
        controller.popoverPresentationController?.sourceRect = target ?? .zero
        return controller
    }

    private func createController(isAlert: Bool) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message,
                                           preferredStyle: isAlert ? .alert : .actionSheet)
        for component in components {
            addComponent(component, to: controller)
        }
        return controller
    }

    private func addComponent(_ component: AlertComponent, to controller: UIAlertController) {
        switch component {
        case .cancel:
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        case .okay:
            controller.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        case .action(let title, let style, let action):
            controller.addAction(UIAlertAction(title: title, style: style, handler: { _ in action() }))
        case .textField(let setup):
            controller.addTextField(configurationHandler: setup)
        }
    }

}
