//
//  DetailBeritaController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class DetailBeritaController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonBackTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var imageBerita: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var webviewHeight: NSLayoutConstraint!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initView()
        
        setView()
        
        getDetailNews()
    }
    
    private func initView() {
        webview.navigationDelegate = self
        webview.scrollView.isScrollEnabled = false
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        buttonBack.layer.cornerRadius = buttonBack.frame.height / 2
        scrollView.addSubview(refreshControl)
        checkTopMargin(viewRootTopMargin: buttonBackTopMargin)
    }
    
    private func setView() {
        guard let news = news else { return }
        
        imageBerita.loadUrl(news.img!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.webviewHeight.constant = self.webview.scrollView.contentSize.height
            self.scrollView.resizeScrollViewContentSize()
        }
    }
    
    private func getDetailNews() {
        SVProgressHUD.show()
        
        guard let news = news else { return }
        
        informationNetworking.getNewsDetail(newsId: news.id!) { (error, itemDetailNews, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Error Get Detail News", error, "Retry", completionHandler: { self.getDetailNews() })
                    return
                }
                
                guard let item = itemDetailNews else { return }
                
                let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                self.webview.loadHTMLString("\(headerString) \(item.content ?? "")", baseURL: nil)
                
                self.scrollView.resizeScrollViewContentSize()
            }
        }
    }

}

extension DetailBeritaController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getDetailNews()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
