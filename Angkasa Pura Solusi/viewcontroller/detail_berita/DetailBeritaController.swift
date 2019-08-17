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

    @IBOutlet weak var buttonBackTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageBerita: UIImageView!
    @IBOutlet weak var labelTitleBerita: UILabel!
    @IBOutlet weak var labelDateBerita: UILabel!
    @IBOutlet weak var labelDescriptionBerita: UILabel!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
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
     
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        checkTopMargin(viewRootTopMargin: buttonBackTopMargin)
        checkRootHeight(viewRootHeight: viewRootHeight, 0, addHeightFor11Above: false, addHeightFor11Below: false)
        
        setInteractiveRecognizer()
        
        setView()
        
        getDetailNews()
    }
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        let recognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = recognizer
    }
    
    private func setView() {
        buttonBack.layer.cornerRadius = buttonBack.frame.height / 2
        
        viewRootHeight.constant -= labelTitleBerita.getHeight(width: labelTitleBerita.frame.width) + labelDescriptionBerita.getHeight(width: labelDescriptionBerita.frame.width) + labelDateBerita.getHeight(width: labelDateBerita.frame.width)
        
        scrollView.addSubview(refreshControl)
        
        guard let news = news else { return }
        
        imageBerita.loadUrl(news.img!)
        labelTitleBerita.text = news.title
        labelDateBerita.text = news.date
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.viewRootHeight.constant += self.labelTitleBerita.getHeight(width: self.labelTitleBerita.frame.width) + self.labelDateBerita.getHeight(width: self.labelDateBerita.frame.width)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getDetailNews() {
        SVProgressHUD.show()
        
        guard let news = news else { return }
        
        informationNetworking.getNewsDetail(newsId: news.id!) { (error, itemDetailNews, isExpired) in
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
            
            if (item.content?.contains("<p>"))! {
                let cleanContent = item.content?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<div>", with: "").replacingOccurrences(of: "<br />", with: "\n").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "</strong>", with: "")
                self.labelDescriptionBerita.text = cleanContent
            } else {
                self.labelDescriptionBerita.text = item.content
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewRootHeight.constant += self.labelDescriptionBerita.getHeight(width: self.labelDescriptionBerita.frame.width)
                    self.view.layoutIfNeeded()
                })
            }
            
        }
    }

}

extension DetailBeritaController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getDetailNews()
    }
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
