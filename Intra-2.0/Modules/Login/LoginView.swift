//
//  LoginView.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import UIKit


protocol LoginViewDelegate {
    func didLoginButtonTapped()
}

protocol LoginViewViewProtocol {
    
}

final class LoginView: UIView {
    
    private var backgroundImageView = UIImageView()
    private var loginButton = UIButton(type: .system)
    
    var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame:) instead")
    }
}

extension LoginView: LoginViewViewProtocol {
    
}

extension LoginView {
    private func setupView() {
        addSubviews()
        setupConstraints()
        setColors()
    }
    
    private func addSubviews() {
        addBackgroundImage()
        addLoginButton()
    }
    
    private func setupConstraints() {
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setColors() {
        backgroundColor = .white
    }
}

extension LoginView {
    private func addBackgroundImage() {
        backgroundImageView.image = UIImage(named: "Login/backgroundImage")
        addSubview(backgroundImageView)
        
    }
    private func addLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 15
        loginButton.backgroundColor = .gray
        loginButton.addTarget(self, action: #selector(didLoginButtonTapped), for: .touchUpInside)
        addSubview(loginButton)
    }
}

extension LoginView {
    @objc private func didLoginButtonTapped() {
        delegate?.didLoginButtonTapped()
    }
}
