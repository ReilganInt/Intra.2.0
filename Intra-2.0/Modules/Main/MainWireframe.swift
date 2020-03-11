//
//  MainWireframe.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol MainWireframeProtocol {
    static func makeViewController(delegate: MainDelegateProtocol?) -> (UIViewController & MainProtocol)
}

struct MainWireframe: MainWireframeProtocol {
    static func makeViewController(delegate: MainDelegateProtocol?) -> (UIViewController & MainProtocol) {
        let viewController = MainViewController()

        let routerDependencies = MainRouterDependencies()
        let router = MainRouter(dependencies: routerDependencies, viewController: viewController)

        let interactorDependencies = MainInteractorDependencies()
        let presenterDependencies = MainPresenterDependencies()

        let interactor = MainInteractor(dependencies: interactorDependencies)
        let presenter = MainPresenter(dependencies: presenterDependencies, view: viewController, interactor: interactor, router: router, delegate: delegate)
        viewController.setPresenter(presenter)
        
        return viewController
    }
}
