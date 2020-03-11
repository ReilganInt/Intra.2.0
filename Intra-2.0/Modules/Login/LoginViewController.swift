//
//  LoginViewController.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: LoginProtocol {
    func setPresenter(_ presenter: LoginPresenterProtocol)
}

final class LoginViewController: UIViewController {
    private var presenter: LoginPresenterProtocol?

    private lazy var rootView: (UIView & LoginViewViewProtocol) = {
        let view = LoginView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.didReceiveEvent(.viewDidLoad)
        
    }
}

extension LoginViewController: LoginViewProtocol {
    func setPresenter(_ presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
}

extension LoginViewController: LoginProtocol {
  
}

extension LoginViewController {
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

extension LoginViewController: LoginViewDelegate {
    
    func didLoginButtonTapped() {
        presenter?.didTriggerAction(.didLogin)
    }
    
    
}

