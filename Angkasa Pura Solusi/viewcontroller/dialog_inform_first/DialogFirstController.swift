//
//  DialogFirstController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class DialogFirstController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var webviewHeight: NSLayoutConstraint!
    
    var resources: (image: String?, title: String?, description: String?)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRootClick)))
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewContainerClick)))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.webviewHeight.constant = self.webview.scrollView.contentSize.height
        }
    }
    
    private func initView() {
        webview.navigationDelegate = self
        viewContainer.layer.cornerRadius = 4
        imageAnnouncement.loadUrl(resources.image ?? "")
        labelTitle.text = resources.title
        
        let fontSetting = """
        <style>
        @font-face
        {
            font-family: 'Roboto';
            font-weight: 400;
            src: url(roboto_medium.ttf);
        }
        </style>
        <span style="font-family: 'Roboto'; font-weight: 400; font-size: \(12 + function.dynamicCustomDevice()); color: #333333">\(resources.description ?? "")</span>
        """
        
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        
        webview.loadHTMLString("\(headerString) \(fontSetting)", baseURL: Bundle.main.bundleURL)
    }
    
    private func cancel() {
        print("cancel click")
        preference.saveBool(value: true, key: staticLet.IS_SHOW_FIRST_DIALOG)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iconCancelClick(_ sender: Any) { cancel() }
    
    @objc func viewRootClick() { cancel() }
    
    @objc func viewContainerClick() { cancel() }
}
