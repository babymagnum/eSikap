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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        clickEvent()
    }
    
    private func clickEvent() {
        viewPresensiMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiMasukClick)))
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1.0)
        
        viewJamMasukKeluar.layer.cornerRadius = viewJamMasukKeluar.frame.height / 2
        viewPresensiMasuk.layer.cornerRadius = 6
        viewPresensiKeluar.layer.cornerRadius = 6
        
        let dateArr = function.getCurrentDate(pattern: "EEEE dd MMMM yyyy").components(separatedBy: " ")
        labelDate.text = "\(dateArr[0])\n\(dateArr[1]) \(dateArr[2]) \(dateArr[3])"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PresensiController {
    @objc func viewPresensiMasukClick() {
        navigationController?.pushViewController(PresensiMapController(), animated: true)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
