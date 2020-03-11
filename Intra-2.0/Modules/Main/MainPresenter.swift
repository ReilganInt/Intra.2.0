//
//  MainPresenter.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol MainPresenterProtocol: class {
    func didReceiveEvent(_ event: MainEvent)
    func didTriggerAction(_ action: MainAction)
}

final class MainPresenter {
    private let dependencies: MainPresenterDependenciesProtocol
    private weak var view: (MainViewProtocol & UIViewController)?
    private let interactor: MainInteractorProtocol
    private let router: MainRouterProtocol
    private weak var delegate: MainDelegateProtocol?
    
    init(dependencies: MainPresenterDependenciesProtocol, 
         view: (MainViewProtocol & UIViewController), 
         interactor: MainInteractorProtocol, 
         router: MainRouterProtocol, 
         delegate: MainDelegateProtocol?) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }
}

extension MainPresenter: MainPresenterProtocol {
    func didReceiveEvent(_ event: MainEvent) {
        switch event {
            case .viewDidLoad:
                debugPrint("viewDidLoad")
        }
    }

    func didTriggerAction(_ action: MainAction) {
        switch action {
            default: ()
        }
    }
}
