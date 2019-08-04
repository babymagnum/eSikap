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

class DetailBeritaController: BaseViewController, WKUIDelegate {

    @IBOutlet weak var imageBerita: UIImageView!
    @IBOutlet weak var labelTitleBerita: UILabel!
    @IBOutlet weak var labelDateBerita: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setInteractiveRecognizer()
        
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        
        setView()
        
        getDetailNews()
    }
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        let recognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = recognizer
    }
    
    private func setView() {
        guard let news = news else { return }
        
        imageBerita.loadUrl(news.img!)
        labelTitleBerita.text = news.title
        labelDateBerita.text = news.date
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    private func getDetailNews() {
        SVProgressHUD.show()
        
        guard let news = news else { return }
        
        informationNetworking.getNewsDetail(newsId: news.id!) { (error, itemDetailNews) in
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Get Detail News", error, "Retry", completionHandler: { self.getDetailNews() })
                return
            }
            
            guard let item = itemDetailNews else { return }
            
            self.setWebviewContent(item.content!)
        }
    }
    
    private func setWebviewContent(_ content: String) {
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        webView.loadHTMLString(headerString + content, baseURL: nil)
    }

}

extension DetailBeritaController {
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
