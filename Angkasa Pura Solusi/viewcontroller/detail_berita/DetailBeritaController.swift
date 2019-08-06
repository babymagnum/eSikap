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
    @IBOutlet weak var imageBerita: UIImageView!
    @IBOutlet weak var labelTitleBerita: UILabel!
    @IBOutlet weak var labelDateBerita: UILabel!
    @IBOutlet weak var labelDescriptionBerita: UILabel!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        scrollView.addSubview(refreshControl)
        
        guard let news = news else { return }
        
        imageBerita.loadUrl(news.img!)
        labelTitleBerita.text = news.title
        labelDateBerita.text = news.date
        
        self.labelTitleBerita.font = UIFont.systemFont(ofSize: 12)
        let width = UIScreen.main.bounds.width - 42
        let height = self.labelTitleBerita.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant += height
            self.view.layoutIfNeeded()
        }
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
            
            if (item.content?.contains("<p>"))! {
                let cleanContent = item.content?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<div>", with: "").replacingOccurrences(of: "<br />", with: "\n").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "</strong>", with: "")
                self.labelDescriptionBerita.text = cleanContent
            } else {
                self.labelDescriptionBerita.text = item.content
            }
            
            self.labelDescriptionBerita.font = UIFont.systemFont(ofSize: 12)
            let width = UIScreen.main.bounds.width - 42
            let height = self.labelDescriptionBerita.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            UIView.animate(withDuration: 0.2, animations: {
                self.viewRootHeight.constant += height
                self.view.layoutIfNeeded()
            })
            
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
