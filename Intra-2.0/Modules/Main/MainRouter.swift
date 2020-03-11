//
//  MainRouter.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol MainRouterProtocol {
    func navigate(toRoute route: MainRoute)
    func dismiss(animated: Bool)
}

final class MainRouter {
    private let dependencies: MainRouterDependenciesProtocol
    private weak var viewController: UIViewController?

    init(dependencies: MainRouterDependenciesProtocol,
    	 viewController: UIViewController?) {
        self.dependencies = dependencies
        self.viewController = viewController
    }
}

extension MainRouter: MainRouterProtocol {
	func navigate(toRoute route: MainRoute) {
        switch route {
            default: ()
        }
    }

    func dismiss(animated: Bool) {
		viewController?.dismiss(animated: animated, completion: nil)
	}
}
