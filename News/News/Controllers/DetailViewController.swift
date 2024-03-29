//
//  DetailViewController.swift
//  News
//
//  Created by Joaquin Jacinto on 8/13/19.
//  Copyright © 2019 Joaquin Jacinto. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var webURL: String?
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let webURL = webURL {
            let url = URL(string: webURL)
            webView.load(URLRequest(url: url!))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
