//
//  BonusController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 20/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup
import FittedSheets
import XLPagerTabStrip

class BonusController: BaseViewController, UICollectionViewDelegate, IndicatorInfoProvider {

    @IBOutlet weak var collectionBonus: UICollectionView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    private var listBonus = [BonusItem]()
    private var isSetBonusHeight = false
    
    var year: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        getBonusSlip()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BONUS")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionBonus.collectionViewLayout.invalidateLayout()
    }
    
    private func getBonusSlip() {
        SVProgressHUD.show()
        
        informationNetworking.getBonusList(year: year ?? function.getCurrentDate(pattern: "yyyy")) { (error, bonus, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Bonus", error, "Reload", "Cancel", completionHandler: {
                        self.getBonusSlip()
                    })
                    return
                }
                
                guard let _bonus = bonus else { return }
                
                if _bonus.data.count == 0 {
                    self.labelEmpty.text = _bonus.message
                    self.labelEmpty.isHidden = false
                } else {
                    self.labelEmpty.isHidden = true
                }
                
                self.listBonus = _bonus.data
                
                self.collectionBonus.reloadData()
            }
        }
    }
    
    private func initCollectionView() {
        collectionBonus.register(UINib(nibName: "BonusCell", bundle: nil), forCellWithReuseIdentifier: "BonusCell")
        
        collectionBonus.delegate = self
        collectionBonus.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}

extension BonusController {
    
    private func sendEmail(bonusItem: BonusItem) {
        SVProgressHUD.show(withStatus: "Sending to your email...")
        
        informationNetworking.sendBonusSlip(bonusId: bonusItem.id ?? "", type: bonusItem.type ?? "") { (error, success, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mengirimkan Slip Gaji", error, "Mengerti")
                    return
                }
                
                guard let success = success else { return }
                
                let vc = DialogSendEmailController()
                vc.email = success.message?.components(separatedBy: "<br>")[1]
                let popup = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width - 44, popupHeight: vc.view.getHeight())
                popup.cornerRadius = 5
                popup.shadowEnabled = false
                self.present(popup, animated: true)
            }
        }
    }
    
    @objc func kirimEmailClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionBonus.indexPathForItem(at: sender.location(in: collectionBonus)) else { return }
        
        function.showUnderstandDialog(self, "Kirim Slip Gaji ke email?", "", "Kirim", "Keluar") {
            self.sendEmail(bonusItem: self.listBonus[indexpath.item])
        }
    }
    
}

extension BonusController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listBonus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BonusCell", for: indexPath) as! BonusCell
        let item = listBonus[indexPath.item]
        cell.data = item
        cell.viewKirimEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kirimEmailClick(sender:))))
        
        if !isSetBonusHeight {
            self.isSetBonusHeight = true
            
            DispatchQueue.main.async {
                let layout = self.collectionBonus.collectionViewLayout as! UICollectionViewFlowLayout
                let height = cell.viewContainer.getHeight() + 13
                layout.itemSize = CGSize(width: self.collectionBonus.frame.width - 26.6, height: height)
            }
        }
        return cell
    }
}
