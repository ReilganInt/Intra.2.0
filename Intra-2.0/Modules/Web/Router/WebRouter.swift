//
//  WebRouter.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//


import UIKit

protocol WebRouterProtocol {
    func navigate(toRoute route: WebRoute)
    func dismiss(animated: Bool)
}

final class WebRouter {
    private let dependencies: WebRouterDependenciesProtocol
    private weak var viewController: UIViewController?

    init(dependencies: WebRouterDependenciesProtocol,
    	 viewController: UIViewController?) {
        self.dependencies = dependencies
        self.viewController = viewController
    }
}

extension WebRouter: WebRouterProtocol {
	func navigate(toRoute route: WebRoute) {
        switch route {
            default: ()
        }
    }
    
    func dismiss(animated: Bool) {
		viewController?.dismiss(animated: animated, completion: nil)
	}
}
