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

    @IBOutlet weak var labelPresensiKosong: UILabel!
    @IBOutlet weak var presensiCollectionView: UICollectionView!
    
    var listPresensi = [ItemPresensi]()
    var from: PresensiListFrom?
    var filteredMonth = ""
    var filteredYear = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if from == .standart {
            setInteractiveRecognizer()
        }

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initView()
        
        initCollectionView()
        
        getPresenceList(filteredMonth, filteredYear)
    }
    
    private func initView() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognnizer))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        let recognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = recognizer
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        presensiCollectionView.addSubview(refreshControl)
        
        presensiCollectionView.register(UINib(nibName: "PresensiCell", bundle: nil), forCellWithReuseIdentifier: "PresensiCell")
        
        let presensiCell = presensiCollectionView.dequeueReusableCell(withReuseIdentifier: "PresensiCell", for: IndexPath(item: 0, section: 0)) as! PresensiCell
        let presensiLayout = presensiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let presensiCellHeight = presensiCell.buttonStatusPresensi.frame.height + presensiCell.labelMasuk.getHeight(width: presensiCell.labelMasuk.frame.width) + presensiCell.labelPulang.getHeight(width: presensiCell.labelPulang.frame.width) + presensiCell.labelPresensiMasuk.getHeight(width: presensiCell.labelPresensiMasuk.frame.width) + presensiCell.labelPresensiPulang.getHeight(width: presensiCell.labelPresensiPulang.frame.width) + 8.9 + 13.3 + 5.1 + 8.7 + 5.1 + 26.4
        presensiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: presensiCellHeight)
        
        presensiCollectionView.delegate = self
        presensiCollectionView.dataSource = self
    }
    
    private func getPresenceList(_ month: String, _ year: String) {
        SVProgressHUD.show()
        
        presenceNetworking.getPresenceList(request: (month: month, year: year)) { (error, listPresensi, isExpired) in
            
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
            
            guard let list = listPresensi else { return }
            
            if list.count == 0 {
                self.labelPresensiKosong.isHidden = false
            } else {
                self.labelPresensiKosong.isHidden = true
            }
            
            self.listPresensi = list
            
            DispatchQueue.main.async {
                self.presensiCollectionView.reloadData()
                
                if self.listPresensi.count > 0 {
                    var index = 0
                    let currentDateInMonth = self.function.getCurrentDate(pattern: "dd")
                    if currentDateInMonth.first == "0" {
                        index = Int(String(currentDateInMonth.dropFirst()))! - 1
                    } else {
                        index = Int(currentDateInMonth)! - 1
                    }
                    
                    self.presensiCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
                }
            }
        }
    }
}

extension PresensiListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPresensi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresensiCell", for: indexPath) as! PresensiCell
        cell.data = listPresensi[indexPath.row]
        return cell
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
