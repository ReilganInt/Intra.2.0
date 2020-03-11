//
//  MainViewController.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol MainViewProtocol: MainProtocol {
    func setPresenter(_ presenter: MainPresenterProtocol)
}

final class MainViewController: UIViewController {
    private var presenter: MainPresenterProtocol?

    private lazy var rootView: (UIView & MainViewViewProtocol) = {
        let view = MainView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.didReceiveEvent(.viewDidLoad)
    }
}

extension MainViewController: MainViewProtocol {
    func setPresenter(_ presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
}

extension MainViewController: MainProtocol {
  
}

extension MainViewController {
    private func setupView() {
        addSubviews()
        setupConstraints()
        setColors()
    }

    private func addSubviews() {
        view.addSubview(rootView)
    }
    
    private func setupConstraints() {
        rootView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setColors() {
        view.backgroundColor = .white
    }
}

