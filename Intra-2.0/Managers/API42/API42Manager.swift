//
//  API42Manager.swift
//  Intra-2.0
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case post = "POST"
    case delete = "DELETE"
}


// Синглтон 42 API Менеджер
final class API42Manager {

    // MARK: - Singlton API42Manager
    /// Общий экземпляр менеджера для доступа к  42 API Менеджеру
    static let shared = API42Manager()
    
    // MARK: - API Credentials (Временно)
    /// API Уникальный идентификатор приложения (UID)
    let clientUID = "de1fa280fe72d947587a287623172724172ce26c678f9d25bdb94029107d49df"
    /// API Уникальный секретный ключ (Secret)
    let clientSecret = "90c7a9cf0615f6427acc56735ca1c866e5deadbd5426262401600af0b04286cc"
    /// Перенаправляемый адресс, вызываемый API после авторизациии (OAuth 2.0)
    let redirectURI = "com.vmormont.swifty://oauth2callback"
    var state = ""
    
    
    // MARK: - API Paths for requests
    /// URL для потока учетных данных клиента (OAuth 2.0 Flow)
    let oAuthURLPath = "https://api.intra.42.fr/oauth/token"
    /// Базовый URL для доступа к API
    let baseURLPath = "https://api.intra.42.fr/v2/"
    
    
    // MARK: - Keychain
    /// Keychain хранилище
    let keychain = KeychainSwift()
    /// Keychain ключ для хранения токена
    let keychainAccessToken = "IntraAccessToken"
    /// Keychain ключ для обновления токена
    let keychainRefreshToken = "IntraRefreshToken"
    
    
    // MARK: - Request controller
    /// Контроллер обработки OAuth запроса
    var webViewController: WebViewController?
    /// Таймер для запросов
    var requestTimer: Timer?
    /// Токен получаемый от API после авторизациии (OAuth 2.0)
    var oAuthAccessToken: String? {
        get { keychain.get(keychainAccessToken) }
        set {
            if let value = newValue {
                keychain.set(value, forKey: keychainAccessToken)
            } else {
                keychain.delete(keychainAccessToken)
            }
        }
    }
    /// Обновленный токен получаемый от API после авторизациии (OAuth 2.0)
    var oAuthRefreshToken: String? {
        get { keychain.get(keychainRefreshToken) }
        set {
            if let value = newValue {
                keychain.set(value, forKey: keychainRefreshToken)
            } else {
                keychain.delete(keychainRefreshToken)
            }
        }
    }
    /// Замыкание вызываемое после заверешния получения потока учетных
    /// данных клиента (OAuth 2.0 Flow)
    var oAuthTokenCompletionHandler: ((Result<Void, Error>) -> Void)?
    
    
    /// Выход пользователя из приложения
    func logoutUser() {
        clearTokenKeys()
        // Первесети на страничку входа
    }
    
    
    private init() {
        if hasOAuthToken() {
            setupAPIData()
        }
    }
    
    /// Проверка на наличие токена для доступа к API
    private func hasOAuthToken() -> Bool {
        guard let token = oAuthAccessToken else { return false }
        return !token.isEmpty
    }
    
    /// ...
    private func setupAPIData() {
        /// ???
    }
    
    /// Очистка токенов после входа из приложения
    private func clearTokenKeys() {
        oAuthAccessToken = nil
        oAuthRefreshToken = nil
    }
    
    
}

extension API42Manager {
    
    func startOAuthLogin() {
        if hasOAuthToken() {
            if let completionHandler = oAuthTokenCompletionHandler {
                completionHandler(.success(()))
            }
            return
        }
        
        state = generateRandomString()
        let authPath = "https://api.intra.42.fr/oauth/authorize?"
        + "client_id=\(clientUID)&redirect_uri=\(redirectURI)"
        + "&state=\(state)&response_type=code&scope=public+profile+projects"
        
        let webViewController = WebWireframe.makeViewController(delegate: nil)
        webViewController.load(authPath)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            UIApplication.getTopMostViewController()?.present(navigationController, animated: true, completion: nil)
        }
        
    }
    
    private func generateRandomString() -> String {
        let length = Int.random(in: 43...128)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension API42Manager {
    
    
    func processOAuthResponse(_ url: URL) {
        // ???
    }
}
