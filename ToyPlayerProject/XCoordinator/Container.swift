//
//  Container.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//
import UIKit

protocol Container {
    var view: UIView! { get }
    var viewController: UIViewController! { get }
}


extension UIViewController: Container {
    public var viewController: UIViewController! { self }
}

extension UIView: Container {
    public var viewController: UIViewController! {
        viewController(for: self)
    }

    public var view: UIView! { self }
}

extension UIView {
    private func viewController(for responder: UIResponder) -> UIViewController? {
        if let viewController = responder as? UIViewController {
            return viewController
        }

        if let nextResponser = responder.next {
            return viewController(for: nextResponser)
        }

        return nil
    }
}
