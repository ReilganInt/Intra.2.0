//
//  WebWireframe.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//


import UIKit

protocol WebWireframeProtocol {
    static func makeViewController(delegate: WebDelegateProtocol?) -> (UIViewController & WebProtocol)
}

struct WebWireframe: WebWireframeProtocol {
    static func makeViewController(delegate: WebDelegateProtocol?) -> (UIViewController & WebProtocol) {
        let viewController = WebViewController()

        let routerDependencies = WebRouterDependencies()
        let router = WebRouter(dependencies: routerDependencies, viewController: viewController)

        let interactorDependencies = WebInteractorDependencies()
        let presenterDependencies = WebPresenterDependencies()

        let interactor = WebInteractor(dependencies: interactorDependencies)
        let presenter = WebPresenter(dependencies: presenterDependencies, view: viewController, interactor: interactor, router: router, delegate: delegate)
        viewController.setPresenter(presenter)
        
        return viewController
    }
}
