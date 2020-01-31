//
//  DetailPersetujuanLemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift

struct TanggalLemburPersetujuanModel {
    var tanggalMulai: String
    var tanggalSelesai: String
    var isOn: Bool
}

class DetailPersetujuanLemburController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonStatus: CustomButton!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var switchApprove: UISwitch!
    @IBOutlet weak var labelApprove: CustomLabel!
    @IBOutlet weak var collectionTanggalLembur: UICollectionView!
    @IBOutlet weak var collectionTanggalLemburHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCatatanStatus: UIView!
    @IBOutlet weak var textviewCatatanStatus: CustomTextView!
    @IBOutlet weak var buttonProses: CustomButton!
    
    private var listTanggalLembur = [TanggalLemburPersetujuanModel]()
    private var datetime_id = [String]()
    
    var isBackToHome: Bool?
    var overtimeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initEvent()
        
        initView()
        
        getDetailApproval()
    }
    
    private func getDetailApproval() {
        guard let _overtimeId = overtimeId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailOvertimeApprovalById(overtimeId: _overtimeId) { (error, detailApproval, isExpired) in
            
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getDetailApproval()
                }
                return
            }
            
            guard let _data = detailApproval?.data else { return }
            
            self.textviewCatatanStatus.text = _data.status_notes
            self.imageProfile.loadUrl(_data.photo ?? "")
            self.buttonStatus.setTitle(_data.status, for: .normal)
            self.buttonStatus.backgroundColor = UIColor(hexString: _data.status_color?.replacingOccurrences(of: "#", with: "") ?? "#")
            self.labelNumber.text = _data.number
            self.labelDate.text = "Diajkukan pada \(_data.date ?? "")"
            self.labelNama.text = ": \(_data.emp_name ?? "")"
            self.labelUnitKerja.text = ": \(_data.unit_name ?? "")"
            self.labelKeterangan.text = ": \(_data.reason ?? "")"
            self.datetime_id = _data.datetime_id
            
            for index in 0..._data.datetimes_start.count - 1 {
                self.listTanggalLembur.append(TanggalLemburPersetujuanModel(tanggalMulai: _data.datetimes_start_show[index], tanggalSelesai: _data.datetimes_end_show[index], isOn: true))
            }
            
            self.collectionTanggalLembur.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionTanggalLemburHeight.constant = self.collectionTanggalLembur.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                    self.scrollView.alpha = 1
                }
            }
        }
    }

    private func initView() {
        scrollView.alpha = 0
        constraintViewRoot.constant += UIApplication.shared.statusBarFrame.height
        imageProfile.giveBorder(UIScreen.main.bounds.width * 0.16 / 2, 0, "fff")
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        buttonStatus.giveBorder(17 / 2, 0, "fff")
        buttonProses.giveBorder(5, 0, "fff")
        viewCatatanStatus.giveBorder(3, 1, "dedede")
        collectionTanggalLembur.register(UINib(nibName: "TanggalLemburPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "TanggalLemburPersetujuanCell")
        collectionTanggalLembur.delegate = self
        collectionTanggalLembur.dataSource = self
        let collectionLayout = collectionTanggalLembur.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 91)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initEvent() {
        switchApprove.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionTanggalLembur.collectionViewLayout.invalidateLayout()
    }
}

extension DetailPersetujuanLemburController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTanggalLembur.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalLemburPersetujuanCell", for: indexPath) as! TanggalLemburPersetujuanCell
        let item = listTanggalLembur[indexPath.item]
        cell.labelTanggalMulai.text = item.tanggalMulai
        cell.labelTanggalSelesai.text = item.tanggalSelesai
        cell.labelStatus.text = item.isOn ? "APPROVED" : "REJECTED"
        cell.switchStatus.setOn(item.isOn, animated: true)
        cell.switchStatus.addTarget(self, action: #selector(collectionSwitchChanged), for: UIControl.Event.valueChanged)
        return cell
    }
}

extension DetailPersetujuanLemburController {
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        labelApprove.text = value ? "APPROVE ALL" : "REJECT ALL"
        
        for index in 0...listTanggalLembur.count - 1 {
            listTanggalLembur[index].isOn = value
            collectionTanggalLembur.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    @objc func collectionSwitchChanged(mySwitch: UISwitch) {
        //Get the point in cell
        let center: CGPoint = mySwitch.center
        let rootViewPoint: CGPoint = mySwitch.superview?.convert(center, to: collectionTanggalLembur) ?? CGPoint(x: 0, y: 0)
         // Now get the indexPath
        let indexPath = collectionTanggalLembur.indexPathForItem(at: rootViewPoint)
        
        guard let _indexpath = indexPath else { return }
        
        let value = mySwitch.isOn
        
        listTanggalLembur[_indexpath.item].isOn = value
        collectionTanggalLembur.reloadItems(at: [_indexpath])
        
        if listTanggalLembur.contains(where: {($0.isOn == false)}){
            switchApprove.setOn(false, animated: true)
            labelApprove.text = "REJECT ALL"
            return
        }
        
        switchApprove.setOn(true, animated: true)
        labelApprove.text = "APPROVE ALL"
    }
    
    @IBAction func buttonProsesClick(_ sender: Any) {
        approvalOvertime()
    }
    
    private func approvalOvertime() {
        guard let _overtimeId = overtimeId else { return }
        var body: [String: String] = [
            "overtime_id": _overtimeId,
            "approval_notes": textviewCatatanStatus.text.trim(),
        ]
        
        for (index, item) in datetime_id.enumerated() {
            body.updateValue(item, forKey: "datetimes_id[\(index)]")
            body.updateValue(listTanggalLembur[index].isOn ? "1" : "0", forKey: "datetimes_status[\(index)]")
        }
        
        SVProgressHUD.show()
        
        informationNetworking.approvalOvertime(body: body) { (error, success, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                if _error.contains("</ul>") || _error.contains("</li>") || _error.contains("</span>") {
                    let vc = DialogPengajuanCutiController()
                    vc.exception = _error
                    self.showCustomDialog(vc)
                } else {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Persetujuan", _error, "Ulangi", "Cancel") {
                        self.approvalOvertime()
                    }
                }
                return
            }
            
            guard let _success = success else { return }
            
            self.view.makeToast(_success.message)
            
            self.getDetailApproval()
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if let _ = isBackToHome {
            backToHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func backToHome() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
}
