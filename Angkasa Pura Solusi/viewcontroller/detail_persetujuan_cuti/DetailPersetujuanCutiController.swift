//
//  DetailPersetujuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailPersetujuanCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var labelStatusTop: CustomButton!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelDateSubmitted: UILabel!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelUnitKerja: UILabel!
    @IBOutlet weak var labelJenisIjin: UILabel!
    @IBOutlet weak var labelAlasan: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var statusPersetujuanCollectionView: UICollectionView!
    @IBOutlet weak var statusPersetujuanCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var switchStatusAction: UISwitch!
    @IBOutlet weak var statusActionCollectionView: UICollectionView!
    @IBOutlet weak var statusActionCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFieldCatatan: UIView!
    @IBOutlet weak var fieldCatatan: CustomTextView!
    @IBOutlet weak var buttonProses: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelStatusAction: CustomLabel!
    
    private var listStatusPersetujuan = [ItemApproval]()
    private var listStatusAction = [StatusAction]()
    private var isCalculateStatusAction = false
    private var isCalculateStatusPersetujuan = false
    private var isSetStatusActionHeight = false
    private var isSetStatusPersetujuanHeight = false
    private var detailLeave: ItemDetailLeaveApproval?
    
    var leave_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initEvent()
        
        initCollectionView()
        
        getDetailLeaveApprovalById()
    }
    
    private func initEvent() {
        switchStatusAction.addTarget(self, action: #selector(switchStatusActionChange), for: UIControl.Event.valueChanged)
    }
    
    private func getDetailLeaveApprovalById() {
        SVProgressHUD.show()
        
        informationNetworking.getDetailLeaveApprovalById(leave_id: leave_id) { (error, detailLeaveApproval, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Detail Cuti", error, "Reload", "Cancel", completionHandler: {
                    self.getDetailLeaveApprovalById()
                })
                return
            }
            
            guard let detailLeaveApproval = detailLeaveApproval else { return }
            
            if detailLeaveApproval.data?.leave[0].is_processed == "1" {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.setViewContent(detailLeaveApproval)
        }
    }
    
    private func setViewContent(_ detailLeaveApproval: DetailLeaveApproval) {
        let item = detailLeaveApproval.data?.leave[0]
        
        if item?.is_processed == "1" {
            buttonProses.isEnabled = false
            buttonProses.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            buttonProses.isEnabled = true
            buttonProses.backgroundColor = UIColor(hexString: "42a5f5")
        }
        
        labelStatusTop.setTitle(item?.status, for: .normal)
        labelStatusTop.backgroundColor = UIColor(hexString: String((item?.status_color?.dropFirst())!))
        imageAccount.loadUrl((item?.photo)!)
        labelNama.text = ": \(item?.emp_name ?? "")"
        labelUnitKerja.text = ": \(item?.unit_name ?? "")"
        labelJenisIjin.text = ": \(item?.type_name ?? "")"
        labelAlasan.text = ": \(item?.reason ?? "")"
        labelTanggal.text = (item?.approval_dates.count)! > 0 ? ": -" : ": \(item?.dates ?? "")"
        listStatusPersetujuan = item!.approval
        labelDateSubmitted.text = "Diajukan pada \(item?.date ?? "")"
        labelKodeCuti.text = item?.number
        detailLeave = item
        
        for date in item!.approval_dates {
            self.listStatusAction.append(StatusAction(date: date, isApproved: "0"))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusActionCollectionHeight.constant = self.statusActionCollectionView.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
        
        listStatusPersetujuan = item!.approval
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
        
        self.statusActionCollectionView.reloadData()
        self.statusPersetujuanCollectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        statusActionCollectionView.register(UINib(nibName: "StatusActionCell", bundle: nil), forCellWithReuseIdentifier: "StatusActionCell")
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
        
        statusActionCollectionView.delegate = self
        statusActionCollectionView.dataSource = self
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        imageAccount.layer.cornerRadius = (UIScreen.main.bounds.width * 0.15) / 2
        viewFieldCatatan.giveBorder(3, 1, "dedede")
        labelStatusTop.layer.cornerRadius = labelStatusTop.frame.height / 2
        buttonProses.layer.cornerRadius = 5
    }

}

extension DetailPersetujuanCutiController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusPersetujuanCollectionView {
            return listStatusPersetujuan.count
        } else {
            return listStatusAction.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == statusPersetujuanCollectionView {
            let statusPersetujuanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
            
            statusPersetujuanCell.data = listStatusPersetujuan[indexPath.item]
            
            if !isCalculateStatusPersetujuan {
                self.isCalculateStatusPersetujuan = true
                DispatchQueue.main.async {
                    let statusPersetujuanHeight = ((UIScreen.main.bounds.width - 28) * 0.075) + 5.3 + 2.7 + 5.2 + statusPersetujuanCell.labelStatus.getHeight(width: statusPersetujuanCell.labelStatus.frame.width)
                    let statusPersetujuanLayout = self.statusPersetujuanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    statusPersetujuanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusPersetujuanHeight)
                }
            }
            
            return statusPersetujuanCell
        } else {
            let statusActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusActionCell", for: indexPath) as! StatusActionCell
            
            statusActionCell.data = listStatusAction[indexPath.item]
            statusActionCell.delegate = self
            statusActionCell.position = indexPath.item
            
            if !isCalculateStatusAction {
                self.isCalculateStatusAction = true
                DispatchQueue.main.async {
                    let statusActionLayout = self.statusActionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    statusActionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusActionCell.viewContainer.frame.height)
                }
            }
            
            return statusActionCell
        }
    }
}

extension DetailPersetujuanCutiController: StatusActionCellProtocol {
    private func approvalLeaveByDate() {
        SVProgressHUD.show()
        
        informationNetworking.approvalLeaveByDate(leave_id: detailLeave!.id!, approval_notes: fieldCatatan.text.trim(), listStatusAction: listStatusAction) { (error, success, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Melakukan Approval Cuti", error, "Mengerti")
                return
            }
            
            guard let success = success else { return }
            
            self.function.showUnderstandDialog(self, "Sukses Melakukan Approval Cuti", success.message!, "Mengerti", completionHandler: {
                self.listStatusAction.removeAll()
                self.getDetailLeaveApprovalById()
            })
        }
    }
    
    private func approvalLeaveOneDayAndRange() {
        SVProgressHUD.show()
        
        informationNetworking.approvalLeaveOneDayAndRange(leave_id: detailLeave!.id!, approval_notes: fieldCatatan.text.trim(), status_date: switchStatusAction.isOn ? "1" : "0") { (error, success, isExpired) in
            
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Melakukan Approval Cuti", error, "Mengerti")
                return
            }
            
            guard let success = success else { return }
            
            self.function.showUnderstandDialog(self, "Sukses Melakukan Approval Cuti", success.message!, "Mengerti", completionHandler: {
                self.listStatusAction.removeAll()
                self.getDetailLeaveApprovalById()
            })
        }
    }
    
    func switchChange(status: String, position: Int) {
        listStatusAction[position].isApproved = status
        statusActionCollectionView.reloadItems(at: [IndexPath(item: position, section: 0)])
        print(listStatusAction)
    }
    
    @objc func switchStatusActionChange(mySwitch: UISwitch) {
        
        if mySwitch.isOn {
            self.labelStatusAction.text = "APPROVE ALL"
            for index in 0...self.listStatusAction.count - 1 {
                self.listStatusAction[index].isApproved = "1"
                self.statusActionCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        } else {
            self.labelStatusAction.text = "REJECT ALL"
            for index in 0...self.listStatusAction.count - 1 {
                self.listStatusAction[index].isApproved = "0"
                self.statusActionCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        
        print(listStatusAction)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @IBAction func buttonProsesClick(_ sender: Any) {
        guard let detailLeave = detailLeave else { return }
        
        if detailLeave.is_day == "1" && detailLeave.is_range == "0" {
            self.approvalLeaveByDate()
        } else {
            self.approvalLeaveOneDayAndRange()
        }
    }
}
