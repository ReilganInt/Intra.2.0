//
//  WebViewController.swift
//  Intra-2.0
//
//  Created admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//


import UIKit
import WebKit

protocol WebViewProtocol: WebProtocol {
    func setPresenter(_ presenter: WebPresenterProtocol)
    
    func load(_ urlString: String)
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
}

final class WebViewController: UIViewController {
    
    var webView: WKWebView?
    
    private var presenter: WebPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.navigationDelegate = self
        webView?.isOpaque = false
        
        setupView()
        presenter?.didReceiveEvent(.viewDidLoad)
    }
}

extension WebViewController: WebViewProtocol {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        let navType = navigationAction.navigationType

        if navType == .formSubmitted || navType == .other {
            if let url = navigationAction.request.url {
                if url.host == "oauth2callback" {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
            navigationController?.title = webView?.url?.host
        }
    }
    
    func setPresenter(_ presenter: WebPresenterProtocol) {
        self.presenter = presenter
    }
}

extension WebViewController: WebProtocol {
  
}

extension WebViewController: WKNavigationDelegate {
    
}

extension WebViewController {
  	private func setupView() {
  		setColors()
  	}

  	private func setColors() {
  		view.backgroundColor = .white
  	}
}
