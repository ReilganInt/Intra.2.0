//
//  WebPresenter.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//


import UIKit

protocol WebPresenterProtocol: class {
    func didReceiveEvent(_ event: WebEvent)
    func didTriggerAction(_ action: WebAction)
}

final class WebPresenter {
    private let dependencies: WebPresenterDependenciesProtocol
    private weak var view: (WebViewProtocol & UIViewController)?
    private let interactor: WebInteractorProtocol
    private let router: WebRouterProtocol
    private weak var delegate: WebDelegateProtocol?
    
    init(dependencies: WebPresenterDependenciesProtocol, 
         view: (WebViewProtocol & UIViewController), 
         interactor: WebInteractorProtocol, 
         router: WebRouterProtocol, 
         delegate: WebDelegateProtocol?) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }
}

extension WebPresenter: WebPresenterProtocol {
    func didReceiveEvent(_ event: WebEvent) {
        switch event {
            case .viewDidLoad:
                debugPrint("viewDidLoad")
        }
    }

    func didTriggerAction(_ action: WebAction) {
        switch action {
        case .didCancelButtonTapped:
            router.dismiss(animated: true)
        }
    }
}
