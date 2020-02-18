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
    @IBOutlet weak var viewContainer: UIView!
    
    var leave_id: String!
    var overtime_id: String?
    var isFromDetailRealization: Bool?
    var delegate: DialogBatalkanProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        buttonProses.layer.cornerRadius = 5
        buttonProses.giveBorder(5, 1, "7eb73d")
        viewTextView.giveBorder(5, 1, "dedede")
        viewContainer.layer.cornerRadius = 5
    }
    
    private func cancelLeave() {
        SVProgressHUD.show()
        
        informationNetworking.cancelLeave(id: leave_id, cancelNotes: fieldAlasan.text.trim()) { (error, baseResponse, isExpired) in
            DispatchQueue.main.async {
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
    
    private func cancelRequestOvertizeRealization(overtimeId: String) {
        let body: [String: String] = [
            "overtime_id": overtimeId,
            "cancel_notes": fieldAlasan.text.trim()
        ]
        
        SVProgressHUD.show()
        
        informationNetworking.cancelOvertimeRealization(body: body) { (error, success, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Pembatalan Realisasi Lembur", _error, "Ulangi", "Cancel", completionHandler: {
                        self.cancelRequestOvertizeRealization(overtimeId: overtimeId)
                    })
                    return
                }
                
                self.delegate.updateData()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func cancelRequestOvertime(overtimeId: String) {
        SVProgressHUD.show()
        
        informationNetworking.cancelOvertime(overtimeId: overtimeId, cancelNotes: fieldAlasan.text.trim()) { (error, success, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Pembatalan Lembur", error, "Ulangi", "Cancel", completionHandler: {
                        self.cancelRequestOvertime(overtimeId: overtimeId)
                    })
                    return
                }
                
                self.delegate.updateData()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DialogBatalkanCutiController {
    @IBAction func buttonKeluarClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonProsesClick(_ sender: Any) {
        if fieldAlasan.text.trim() == "" {
            self.function.showUnderstandDialog(self, "Alasan Tidak Boleh Kosong", "Anda harus menyertakan alasan yang jelas untuk pembatalan cuti", "Understand")
            return
        }
        
        if let _overtimeId = overtime_id {
            if let _ = isFromDetailRealization {
                cancelRequestOvertizeRealization(overtimeId: _overtimeId)
                return
            }
            
            cancelRequestOvertime(overtimeId: _overtimeId)
            return
        }
        
        cancelLeave()
    }
}
