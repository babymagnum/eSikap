//
//  DialogBatalkanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol DialogBatalkanProtocol {
    func updateData()
}

class DialogBatalkanCutiController: BaseViewController {

    @IBOutlet weak var viewTextView: UIView!
    @IBOutlet weak var fieldAlasan: CustomTextView!
    @IBOutlet weak var buttonProses: CustomButton!
    
    var cuti: ItemRiwayatCuti!
    var delegate: DialogBatalkanProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        buttonProses.layer.cornerRadius = 5
        buttonProses.giveBorder(5, 1, "7eb73d")
        viewTextView.giveBorder(5, 1, "dedede")
    }

    @IBAction func buttonProsesClick(_ sender: Any) {
        if fieldAlasan.text.trim() == "" {
            self.function.showUnderstandDialog(self, "Alasan Tidak Boleh Kosong", "Anda harus menyertakan alasan yang jelas untuk pembatalan cuti", "Understand")
            return
        }
        
        cancelLeave()
    }
    
    private func cancelLeave() {
        SVProgressHUD.show()
        
        informationNetworking.cancelLeave(id: cuti.id!, cancelNotes: fieldAlasan.text.trim()) { (error, baseResponse, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Melakukan Pembatalan Cuti", error, "Ulangi", "Cancel", completionHandler: {
                    self.cancelLeave()
                })
                return
            }
            
            self.delegate.updateData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
