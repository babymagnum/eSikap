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

class SlipGajiController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelTitleTop: CustomLabel!
    @IBOutlet weak var collectionSlipGaji: UICollectionView!
    @IBOutlet weak var labelDataKosong: CustomLabel!
    
    private var listSlipGaji = [ItemSlipGaji]()
    private var isSetSlipGajiHeight = false
    private var currentYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initCollectionView()
        
        getSlipGaji()
    }
    
    private func getSlipGaji() {
        SVProgressHUD.show()
        
        informationNetworking.getPayrollList(year: currentYear) { (error, slipGaji, isExpired) in
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
                self.labelDataKosong.isHidden = false
            } else {
                self.labelDataKosong.isHidden = true
            }
            
            self.listSlipGaji = slipGaji.data
            
            DispatchQueue.main.async { self.collectionSlipGaji.reloadData() }
        }
    }
    
    private func initCollectionView() {
        collectionSlipGaji.register(UINib(nibName: "SlipGajiCell", bundle: nil), forCellWithReuseIdentifier: "SlipGajiCell")
        
        collectionSlipGaji.delegate = self
        collectionSlipGaji.dataSource = self
    }
    
    private func initView() {
        currentYear = function.getCurrentDate(pattern: "yyyy")
        labelTitleTop.text = "Slip Gaji \(currentYear)"
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension SlipGajiController: BottomSheetFilterPresensiProtocol {
    func filterPicked(_ month: String, _ year: String) {
        currentYear = year
        labelTitleTop.text = "Slip Gaji \(currentYear)"
        getSlipGaji()
    }
    
    private func sendEmail(payroll_id: String) {
        SVProgressHUD.show(withStatus: "Sending to your email...")
        
        informationNetworking.sendPayrollSlip(payroll_id: payroll_id) { (error, success, isExpired) in
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
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = BottomSheetFilterPresensi()
        vc.delegate = self
        vc.onlyYear = true
        let sheetController = SheetViewController(controller: vc)
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @objc func kirimEmailClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionSlipGaji.indexPathForItem(at: sender.location(in: collectionSlipGaji)) else { return }
        
        sendEmail(payroll_id: listSlipGaji[indexpath.item].payroll_id!)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
                layout.itemSize = CGSize(width: self.collectionSlipGaji.frame.width - 13.7, height: height)
            }
        }
        return cell
    }
}
