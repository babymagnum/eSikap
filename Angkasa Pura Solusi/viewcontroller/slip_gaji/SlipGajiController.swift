//
//  SlipGajiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup
import FittedSheets
import XLPagerTabStrip

class SlipGajiController: BaseViewController, UICollectionViewDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionSlipGaji: UICollectionView!
    @IBOutlet weak var labelDataKosong: CustomLabel!
    
    private var listSlipGaji = [ItemSlipGaji]()
    private var isSetSlipGajiHeight = false
    
    var year: String?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SLIP GAJI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        getSlipGaji()
    }
    
    private func getSlipGaji() {
        SVProgressHUD.show()
        
        informationNetworking.getPayrollList(year: year ?? function.getCurrentDate(pattern: "yyyy")) { (error, slipGaji, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Gaji", error, "Reload", "Understand", completionHandler: {
                        self.getSlipGaji()
                    })
                    return
                }
                
                guard let slipGaji = slipGaji else { return }
                
                if slipGaji.data.count == 0 {
                    self.labelDataKosong.text = slipGaji.message
                    self.labelDataKosong.isHidden = false
                } else {
                    self.labelDataKosong.isHidden = true
                }
                
                self.listSlipGaji = slipGaji.data
                
                self.collectionSlipGaji.reloadData()
            }
        }
    }
    
    private func initCollectionView() {
        collectionSlipGaji.register(UINib(nibName: "SlipGajiCell", bundle: nil), forCellWithReuseIdentifier: "SlipGajiCell")
        
        collectionSlipGaji.delegate = self
        collectionSlipGaji.dataSource = self
    }
}

extension SlipGajiController {
    private func sendEmail(payroll_id: String) {
        SVProgressHUD.show(withStatus: "Sending to your email...")
        
        informationNetworking.sendPayrollSlip(payroll_id: payroll_id) { (error, success, isExpired) in
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
        guard let indexpath = collectionSlipGaji.indexPathForItem(at: sender.location(in: collectionSlipGaji)) else { return }
        
        function.showUnderstandDialog(self, "Kirim Slip Gaji ke email?", "", "Kirim", "Keluar") {
            self.sendEmail(payroll_id: self.listSlipGaji[indexpath.item].payroll_id!)
        }
    }
}

extension SlipGajiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSlipGaji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlipGajiCell", for: indexPath) as! SlipGajiCell
        let item = listSlipGaji[indexPath.item]
        cell.data = item
        cell.viewKirimEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kirimEmailClick(sender:))))
        
        if !isSetSlipGajiHeight {
            self.isSetSlipGajiHeight = true
            
            DispatchQueue.main.async {
                let layout = self.collectionSlipGaji.collectionViewLayout as! UICollectionViewFlowLayout
                let height = cell.viewContainer.getHeight() + 13
                layout.itemSize = CGSize(width: self.collectionSlipGaji.frame.width - 26.6, height: height)
            }
        }
        return cell
    }
}
