//
//  PresensiListController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 04/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

enum PresensiListFrom {
    case presensiMapController
    case standart
    case bottomSheetMenu
}

class PresensiListController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var presensiCollectionView: UICollectionView!
    
    var listPresensi = [ItemPresensi]()
    var from: PresensiListFrom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if from == .standart {
            setInteractiveRecognizer()
        }

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initView()
        
        initCollectionView()
        
        getPresenceList()
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
        presensiCollectionView.register(UINib(nibName: "PresensiCell", bundle: nil), forCellWithReuseIdentifier: "PresensiCell")
        
        let presensiCell = presensiCollectionView.dequeueReusableCell(withReuseIdentifier: "PresensiCell", for: IndexPath(item: 0, section: 0)) as! PresensiCell
        let presensiLayout = presensiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        presensiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: presensiCell.viewContainer.frame.height)
        
        presensiCollectionView.delegate = self
        presensiCollectionView.dataSource = self
    }
    
    private func getPresenceList() {
        SVProgressHUD.show()
        
        let date = function.getCurrentDate(pattern: "MM-yyyy").components(separatedBy: "-")
        presenceNetworking.getPresenceList(request: (month: date[0], year: date[1])) { (error, listPresensi) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Fetch Presensi List", error, "Retry", completionHandler: {
                    self.getPresenceList()
                })
                return
            }
            
            guard let list = listPresensi else { return }
            
            self.listPresensi = list
            
            DispatchQueue.main.async {
                self.presensiCollectionView.reloadData()
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

extension PresensiListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPresensi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresensiCell", for: indexPath) as! PresensiCell
        cell.data = listPresensi[indexPath.item]
        return cell
    }
}

//click event
extension PresensiListController {
    @objc func swipeGestureRecognnizer() { popviewcontroller() }
    
    @IBAction func backButtonClick(_ sender: Any) { popviewcontroller() }
    
    @IBAction func filterButtonClick(_ sender: Any) {
    }
    
    private func popviewcontroller() {
        switch from {
        case .standart?:
            self.navigationController?.popViewController(animated: true)
        case .presensiMapController?:
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(HomeController(), animated: true)
        case .bottomSheetMenu?:
            self.dismiss(animated: true, completion: nil)
        default: break
        }
    }
}
