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
import SwiftyJSON


// Написал на будущее
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
    
    // MARK: - API Credentials (Временные clientUID, clientSecret, redirectURI)
    /// после изменения этих данных не забыть изменить URL Scheme!
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
    /// Таймер для запросов, нужно будет ставить ограничене по секундам на авторизациюю
    /// time out, не знаю пока на сколько стаивть, поэтому пока просто лежит здесь и ждет
    /// своего часа
    var requestTimer: Timer?
    /// Access Token от API после авторизациии (OAuth 2.0)
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
    /// Refresh Token получаемый от API после авторизациии (OAuth 2.0)
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
        // Первесети на страничку входа, но не здесь а там где происходит logout
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
        /// Cкачать какие-то важные данные для стартовой страницы приложения
        /// ВАЖНО: нужно отловить ошибки от API, вдруг ключ уже устарел и нужно тогда вызывать
        /// startОAuthLogin()
    }
    
    /// Очистка токенов
    private func clearTokenKeys() {
        oAuthAccessToken = nil
        oAuthRefreshToken = nil
    }
    
    
}

extension API42Manager {
    
    func startOAuthLogin() {
        if hasOAuthToken() {
            /// ВАЖНО: нужно отловить ошибки от API, вдруг ключ уже устарел и нужно тогда вызывать
            /// startОAuthLogin()
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
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
            else { return }
        
        var codeValue: String?
        
        for item in queryItems {
            if item.name.lowercased() == "code" {
                codeValue = item.value
            } else if item.name.lowercased() == "state" {
                if item.value != state { return }
            } else if item.name.lowercased() == "error" {
                if let completionHandler = self.oAuthTokenCompletionHandler {
                    completionHandler(.failure(NSError(domain: "err", code: 0, userInfo: nil)))
                    self.webViewController?.dismiss(animated: true, completion: nil)
                    return
                }
            }
            guard let code = codeValue else {
                self.webViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            let url = URL(string: oAuthURLPath)!
            let tokenParams = [
                "grant_type": "authorization_code",
                "client_id": clientUID,
                "client_secret": clientSecret,
                "code": code,
                "redirect_uri": redirectURI,
                "state": state
            ]
            
            var request = URLRequest(url: url)
            /**
                Значения кодируются в кортежах с ключом, разделенных
                символом '&', с '=' между ключом и значением:
 
                    application/x-www-form-urlencoded
             
                Не буквенно-цифровые символы - percent encoded: '%' это причина, по которой этот тип не подходит для использования с двоичными данными (вместо этого используется multipart/form-data).
                Но в данном случае у меня не получилось с ним поработать, поэтому я просто исключил процент
                функцией:
                    
                    percentEscaped()
            */
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = tokenParams.percentEscaped().data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    guard error == nil, let data = data, let valueJSON = try? JSON(data: data) else {
                        if let error = error {
                            print("OAuth Response Error: \(error)")
                        }
                        if let completionHandler = self.oAuthTokenCompletionHandler {
                            completionHandler(.failure(error!))
                        }
                        self.webViewController?.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    guard valueJSON["token_type"].string == "bearer",
                        let accessToken = valueJSON["access_token"].string,
                        let refreshToken = valueJSON["refresh_token"].string
                        else {
                            self.webViewController?.dismiss(animated: true, completion: nil)
                            return
                    }
                    
                    self.oAuthAccessToken = accessToken
                    self.oAuthRefreshToken = refreshToken
                    
                    self.setupAPIData()
                    // Редирект на логин контроллер
                    self.webViewController?.dismiss(animated: true, completion: nil)
                }
            }.resume()
        }
    }
}


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    /**
        Компонент запроса содержит неиерархические данные, которые наряду с
      данные в компоненте пути , служат для идентификации
      ресурс в рамках схемы URI и полномочий по именованию
      (если есть). Компонент запроса обозначен первым вопросом
      знак ("?") и оканчивается символом цифры ("#")
      или к концу URI.

       - Общий синтаксис URI RFC 3986 январь 2005:
        
                    query = * (pchar / "/" / "?")
    
        Символы косой черты ("/") и вопросительного знака ("?") Могут представлять данные
      внутри компонента запроса. Некоторые старые, ошибочные
      реализации могут не обрабатывать такие данные правильно, когда они используются как
      базовый URI для относительных ссылок , по-видимому
      потому что они не могут отличить данные запроса от данных пути, когда
      ищет иерархические разделители. Однако в качестве компонентов запроса
      часто используются для переноса идентифицирующей информации в форме
      пары «ключ - значение» и одно часто используемое значение является ссылкой на
      другой URI, иногда для удобства использования лучше избегать
      кодирование этих символов.
    
       - Обработанный синтаксис на 2020:
    
                    query = * (pchar)
    */
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
