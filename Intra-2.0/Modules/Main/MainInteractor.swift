//
//  MainInteractor.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import Foundation

protocol MainInteractorProtocol {

}

final class MainInteractor {
    private let dependencies: MainInteractorDependenciesProtocol
    
    init(dependencies: MainInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension MainInteractor: MainInteractorProtocol {
	
}
