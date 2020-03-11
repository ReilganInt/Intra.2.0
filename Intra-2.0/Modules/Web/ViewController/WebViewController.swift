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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        webView = WKWebView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.navigationDelegate = self
        webView?.isOpaque = false
        
        setupView()
        setupNavigationBar()
        presenter?.didReceiveEvent(.viewDidLoad)
        addContraints()
    }
}

extension WebViewController: WebViewProtocol {
    
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
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
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
}

extension WebViewController {
    
  	private func setupView() {
  		setColors()
        setupWebView()
  	}
    
    private func setupWebView() {
        view.addSubview(webView!)
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelButtonTapped))
        navigationItem.setLeftBarButton(cancelButton, animated: true)
    }
    
    private func addContraints() {
        
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

  	private func setColors() {
  		view.backgroundColor = .white
  	}
}

extension WebViewController {
    
    @objc private func didCancelButtonTapped() {
        presenter?.didTriggerAction(.didCancelButtonTapped)
    }
}
