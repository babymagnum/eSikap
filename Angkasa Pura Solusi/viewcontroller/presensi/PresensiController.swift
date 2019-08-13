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
    @IBOutlet weak var iconKeluar: UIImageView!
    @IBOutlet weak var viewJamMasukKeluarHeight: NSLayoutConstraint!
    @IBOutlet weak var labelJamPulangMini: CustomLabel!
    @IBOutlet weak var labelPresensiPulang: CustomLabel!
    @IBOutlet weak var imagePresensiPulang: UIImageView!
    @IBOutlet weak var stackViewPresensiHeight: NSLayoutConstraint!
    
    var preparePresence: ItemPreparePresence?
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInteractiveRecognizer()
        
        initView()
        
        clickEvent()
    }
    
    private func clickEvent() {
        viewPresensiMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiMasukClick)))
        viewPresensiKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiKeluarClick)))
    }
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        let recognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = recognizer
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1.0)
        
        viewPresensiMasuk.layer.cornerRadius = 6
        viewPresensiKeluar.layer.cornerRadius = 6
        
        let dateArr = function.getCurrentDate(pattern: "EEEE dd MMMM yyyy").components(separatedBy: " ")
        labelDate.text = "\(dateArr[0])\n\(dateArr[1]) \(dateArr[2]) \(dateArr[3])"
        
        UIView.animate(withDuration: 0.2) {
            self.viewJamMasukKeluarHeight.constant = self.labelJamPulangMini.getHeight(width: self.labelJamPulangMini.frame.width) + self.labelJamPulang.getHeight(width: self.labelJamPulang.frame.width) + 11.5
            self.stackViewPresensiHeight.constant = self.labelPresensiPulang.getHeight(width: self.labelPresensiPulang.frame.width) + self.imagePresensiPulang.frame.height + 28.4 + 6.2 + 20.1
            self.viewJamMasukKeluar.layer.cornerRadius = self.viewJamMasukKeluarHeight.constant / 2
            self.view.layoutIfNeeded()
        }
        
        if let presencePrepare = self.preparePresence {
            labelDate.text = "\(presencePrepare.day ?? "")\n\(presencePrepare.date_formated ?? "")"
            labelJamMasuk.text = String((presencePrepare.shift_start?.prefix(5))!)
            labelJamPulang.text = String((presencePrepare.shift_end?.prefix(5))!)
            
            let timeArray = presencePrepare.time?.components(separatedBy: ":")
            
            seconds = Int(timeArray![2])!
            minutes = Int(timeArray![1])!
            hours = Int(timeArray![0])!
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                
                self.seconds += 1
                
                if self.seconds == 60 {
                    self.minutes += 1
                    self.seconds = 0
                }
                
                if self.minutes == 60 {
                    self.hours += 1
                    self.minutes = 0
                }
                
                self.labelClock.text = "\(String(self.hours).count == 1 ? "0\(self.hours)" : "\(self.hours)"):\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(self.minutes)"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(self.seconds)") \(self.preparePresence?.timezone ?? "")"
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PresensiController {
    @IBAction func buttonPresenceListClick(_ sender: Any) {
        let vc = PresensiListController()
        vc.from = .standart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewPresensiMasukClick() {
        if let presence = preparePresence {
            if presence.is_presence_in == "0" {
                let vc = PresensiMapController()
                preparePresence?.time = "\(hours):\(minutes):\(seconds)"
                vc.preparePresence = preparePresence
                vc.presenceType = "in"
                vc.titleString = "Presensi Masuk"
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DialogPreparePresenceController()
                vc.stringDescription = "Anda sudah melakukan presensi masuk, sekarang anda harus melakukan presensi pulang."
                self.showCustomDialog(vc)
            }
        }
    }
    
    @objc func viewPresensiKeluarClick() {
        if let presence = preparePresence {
            if presence.is_presence_in == "1" {
                let vc = PresensiMapController()
                preparePresence?.time = "\(hours):\(minutes):\(seconds)"
                vc.preparePresence = preparePresence
                vc.presenceType = "out"
                vc.titleString = "Presensi Pulang"
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DialogPreparePresenceController()
                vc.stringDescription = "Anda belum melakukan presensi masuk, lakukan presensi masuk terlebih dahulu."
                self.showCustomDialog(vc)
            }
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
