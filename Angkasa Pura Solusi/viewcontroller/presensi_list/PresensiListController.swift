//
//  PresensiListController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 04/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import FittedSheets

enum PresensiListFrom {
    case presensiMapController
    case standart
    case bottomSheetMenu
}

class PresensiListController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelPresensiKosong: UILabel!
    @IBOutlet weak var presensiCollectionView: UICollectionView!
    
    var listPresensi = [ItemPresensi]()
    var from: PresensiListFrom?
    var filteredMonth = ""
    var filteredYear = ""
    var isCalculatePresensiHeight = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        getPresenceList(filteredMonth, filteredYear)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presensiCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognnizer))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        presensiCollectionView.addSubview(refreshControl)
        presensiCollectionView.register(UINib(nibName: "PresensiCell", bundle: nil), forCellWithReuseIdentifier: "PresensiCell")
        
        presensiCollectionView.delegate = self
        presensiCollectionView.dataSource = self
    }
    
    private func getPresenceList(_ month: String, _ year: String) {
        SVProgressHUD.show()
        
        presenceNetworking.getPresenceList(request: (month: month, year: year)) { (error, presensi, isExpired) in
            
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Presensi", error, "Reload", "Cancel", completionHandler: {
                    self.getPresenceList(month, year)
                })
                return
            }
            
            guard let presensi = presensi else { return }
            
            if presensi.data.count == 0 {
                self.labelPresensiKosong.text = presensi.message
                self.labelPresensiKosong.isHidden = false
            } else {
                self.labelPresensiKosong.isHidden = true
            }
            
            self.listPresensi = presensi.data
            
            DispatchQueue.main.async {
                self.presensiCollectionView.reloadData()
                self.scrollToIndex()
            }
        }
    }
    
    private func scrollToIndex() {
        var index = 0
        let currentDateInMonth = self.function.getCurrentDate(pattern: "dd")
        if currentDateInMonth.first == "0" {
            index = Int(String(currentDateInMonth.dropFirst()))! - 1
        } else {
            index = Int(currentDateInMonth)! - 1
        }
        
        presensiCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
    }
}

extension PresensiListController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = listPresensi[indexPath.item]
        
        let width = UIScreen.main.bounds.width - 60
        let labelMasukPulangHeight = String("Masuk").getHeight(withConstrainedWidth: width, font_size: 10) + String("Pulang").getHeight(withConstrainedWidth: width, font_size: 10)
        let labelValuePulangHeight = item.date_out?.getHeight(withConstrainedWidth: width, font_size: 10)
        let labelValueMasukHeight = item.date_in?.getHeight(withConstrainedWidth: width, font_size: 10)
        let labelDateHeight = item.date?.getHeight(withConstrainedWidth: width, font_size: 10)
        let labelStatusHeight = item.presence_status?.getHeight(withConstrainedWidth: width, font_size: 10)
        let valuePulangMasukHeight = labelValuePulangHeight! + labelValueMasukHeight!
        let dateStatusHeight = labelDateHeight! + labelStatusHeight!
        let marginHeight: CGFloat = item.presence_status == "" ? 49 : 75

        if item.presence_status == "" {
            return CGSize(width: UIScreen.main.bounds.width - 28, height: labelMasukPulangHeight + valuePulangMasukHeight + labelDateHeight! + marginHeight)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 28, height: labelMasukPulangHeight + valuePulangMasukHeight + dateStatusHeight + marginHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPresensi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presensiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresensiCell", for: indexPath) as! PresensiCell
        presensiCell.data = listPresensi[indexPath.row]
        return presensiCell
    }
}

//click event
extension PresensiListController: BottomSheetFilterPresensiProtocol {
    func filterPicked(_ month: String, _ year: String) {
        self.filteredMonth = month
        self.filteredYear = year
        self.getPresenceList(month, year)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        isCalculatePresensiHeight = false
        getPresenceList(filteredMonth, filteredYear)
        refreshControl.endRefreshing()
    }
    
    @objc func swipeGestureRecognnizer() { popviewcontroller() }
    
    @IBAction func backButtonClick(_ sender: Any) { popviewcontroller() }
    
    @IBAction func filterButtonClick(_ sender: Any) {
        let vc = BottomSheetFilterPresensi()
        vc.delegate = self
        let sheetController = SheetViewController(controller: vc)
        self.present(sheetController, animated: false, completion: nil)
    }
    
    private func popviewcontroller() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
}
