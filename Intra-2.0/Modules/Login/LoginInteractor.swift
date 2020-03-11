//
//  LoginInteractor.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import Foundation

protocol LoginInteractorProtocol {
    func startOAuthLogin()
}

final class LoginInteractor {
    private let dependencies: LoginInteractorDependenciesProtocol
    
    init(dependencies: LoginInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    
    func startOAuthLogin() {
        API42Manager.shared.startOAuthLogin()
    }
    
	
}
