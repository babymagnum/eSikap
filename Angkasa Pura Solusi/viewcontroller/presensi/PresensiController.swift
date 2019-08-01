//
//  PresensiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class PresensiController: BaseViewController {

    @IBOutlet weak var labelClock: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewJamMasukKeluar: UIView!
    @IBOutlet weak var viewPresensiMasuk: UIView!
    @IBOutlet weak var viewPresensiKeluar: UIView!
    @IBOutlet weak var labelJamMasuk: UILabel!
    @IBOutlet weak var labelJamPulang: UILabel!
    
    var preparePresence: PreparePresence?
    var seconds = 0
    var minustes = 0
    var hours = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        clickEvent()
    }
    
    private func clickEvent() {
        viewPresensiMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiMasukClick)))
        viewPresensiKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiKeluarClick)))
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1.0)
        
        viewJamMasukKeluar.layer.cornerRadius = viewJamMasukKeluar.frame.height / 2
        viewPresensiMasuk.layer.cornerRadius = 6
        viewPresensiKeluar.layer.cornerRadius = 6
        
        let dateArr = function.getCurrentDate(pattern: "EEEE dd MMMM yyyy").components(separatedBy: " ")
        labelDate.text = "\(dateArr[0])\n\(dateArr[1]) \(dateArr[2]) \(dateArr[3])"
        
        if let presencePrepare = self.preparePresence {
            labelDate.text = "\(presencePrepare.day ?? "")\n\(presencePrepare.date ?? "")"
            labelJamMasuk.text = String((presencePrepare.shift_start?.prefix(5))!)
            labelJamPulang.text = String((presencePrepare.shift_end?.prefix(5))!)
            
            let timeArray = presencePrepare.time?.components(separatedBy: ":")
            
            seconds = Int(timeArray![2])!
            minustes = Int(timeArray![1])!
            hours = Int(timeArray![0])!
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                
                self.seconds += 1
                
                if self.seconds == 60 {
                    self.minustes += 1
                    self.seconds = 0
                }
                
                if self.minustes == 60 {
                    self.hours += 1
                    self.minustes = 0
                }
                
                self.labelClock.text = "\(self.hours):\(self.minustes):\(self.seconds)"
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PresensiController {
    
    @objc func viewPresensiMasukClick() {
        if let presence = preparePresence {
            if presence.is_presence_in == "0" {
                let vc = PresensiMapController()
                preparePresence?.time = "\(hours):\(minustes):\(seconds)"
                vc.preparePresence = preparePresence
                navigationController?.pushViewController(vc, animated: true)
            } else {
                self.function.showUnderstandDialog(self, "Restricted", "Anda sudah melakukan presensi masuk, sekarang anda harus melakukan presensi keluar", "Understand")
            }
        }
    }
    
    @objc func viewPresensiKeluarClick() {
        if let presence = preparePresence {
            if presence.is_presence_in == "1" {
                let vc = PresensiMapController()
                preparePresence?.time = "\(hours):\(minustes):\(seconds)"
                vc.preparePresence = preparePresence
                navigationController?.pushViewController(vc, animated: true)
            } else {
                self.function.showUnderstandDialog(self, "Restricted", "Anda belum melakukan presensi masuk, lakukan presensi masuk terlebih dahulu", "Understand")
            }
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
