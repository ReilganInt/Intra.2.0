//
//  MainView.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol MainViewViewProtocol {

}

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame:) instead")
    }
}

extension MainView: MainViewViewProtocol {

}

extension MainView {
  	private func setupView() {
        addSubviews()
        setupConstraints()
        setColors()
  	}

    private func addSubviews() {

    }
    
    private func setupConstraints() {
        
    }

  	private func setColors() {
        backgroundColor = .white
  	}
}
