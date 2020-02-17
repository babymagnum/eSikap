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

class DetailBeritaController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonBackTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var imageBerita: UIImageView!
    @IBOutlet weak var labelTitleBerita: UILabel!
    @IBOutlet weak var labelDateBerita: UILabel!
    @IBOutlet weak var labelDescriptionBerita: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
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
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        buttonBack.layer.cornerRadius = buttonBack.frame.height / 2
        scrollView.addSubview(refreshControl)
        checkTopMargin(viewRootTopMargin: buttonBackTopMargin)
    }
    
    private func setView() {
        guard let news = news else { return }
        
        imageBerita.loadUrl(news.img!)
        labelTitleBerita.text = news.title
        labelDateBerita.text = news.date
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
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
                
                let regex = "<[^>]+>" // remove <> tag
                let nextRegex = "&[^;]+;" // remove &;
                let advanceRegex = "&[^ ]+ " // remove leftover &
                let cleanContent = item.content?.replacingOccurrences(of: regex, with: "", options: .regularExpression, range: nil)
                let nextContent = cleanContent?.replacingOccurrences(of: nextRegex, with: "", options: .regularExpression, range: nil)
                
                self.labelDescriptionBerita.text = nextContent?.replacingOccurrences(of: advanceRegex, with: "", options: .regularExpression, range: nil)
                
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
