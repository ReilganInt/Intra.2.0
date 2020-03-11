//
//  WebInteractor.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//


import Foundation

protocol WebInteractorProtocol {

}

final class WebInteractor {
    private let dependencies: WebInteractorDependenciesProtocol
    
    init(dependencies: WebInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension WebInteractor: WebInteractorProtocol {
	
}
