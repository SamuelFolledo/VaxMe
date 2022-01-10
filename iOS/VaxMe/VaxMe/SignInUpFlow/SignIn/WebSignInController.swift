//
//  WebSignInController.swift
//  VaxMe
//
//  Created by Samuel Folledo on 1/5/22.
//

import UIKit
import WebKit

class WebSignInController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.vaxmepass.com/u/login")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
