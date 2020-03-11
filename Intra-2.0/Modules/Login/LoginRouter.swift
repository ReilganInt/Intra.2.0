//
//  LoginRouter.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol {
    func navigate(toRoute route: LoginRoute)
    func dismiss(animated: Bool)
}

final class LoginRouter {
    private let dependencies: LoginRouterDependenciesProtocol
    private weak var viewController: UIViewController?

    init(dependencies: LoginRouterDependenciesProtocol,
    	 viewController: UIViewController?) {
        self.dependencies = dependencies
        self.viewController = viewController
    }
}

extension LoginRouter: LoginRouterProtocol {
	func navigate(toRoute route: LoginRoute) {
        switch route {
            default: ()
        }
    }

    func dismiss(animated: Bool) {
		viewController?.dismiss(animated: animated, completion: nil)
	}
}
