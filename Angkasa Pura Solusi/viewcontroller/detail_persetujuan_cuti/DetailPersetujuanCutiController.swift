//
//  DetailPersetujuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class DetailPersetujuanCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewLampiranContent: UIView!
    @IBOutlet weak var viewLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLampiran: UIView!
    @IBOutlet weak var labelLampiran: CustomLabel!
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
    
    private var attachment: String?
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
        viewLampiranContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLampiranContentClick)))
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
        
        if item?.attachment_name == "" {
            UIView.animate(withDuration: 0.2) {
                self.viewLampiranHeight.constant = 0
                self.viewLampiran.alpha = 0
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
        
        if item?.is_processed == "1" {
            buttonProses.isEnabled = false
            buttonProses.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            buttonProses.isEnabled = true
            buttonProses.backgroundColor = UIColor(hexString: "42a5f5")
        }
        
        if item?.approval_dates.count == 0 {
            self.labelStatusAction.text = "REJECTED"
        }
        
        attachment = item?.attachment
        labelLampiran.text = item?.attachment_name
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
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusPersetujuanCollectionView.collectionViewLayout.invalidateLayout()
        statusActionCollectionView.collectionViewLayout.invalidateLayout()
    }
    
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
        scrollView.alpha = 0
    }

}

extension DetailPersetujuanCutiController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == statusPersetujuanCollectionView {
            let item = listStatusPersetujuan[indexPath.item]
            
            let statusDateHeight = item.status_date?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 28, font_size: 7)
            let statusHeight = (item.status?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 28, font_size: 7))!
            let imageHeight = ((UIScreen.main.bounds.width - 28) * 0.075)
            
            let fullHeight = imageHeight + 25 + statusHeight + statusDateHeight!
            let withoutDateHeight = imageHeight + 25 + statusHeight
            
            return CGSize(width: UIScreen.main.bounds.width - 28, height: item.status_date == "" ? withoutDateHeight : fullHeight)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 28, height: 50)
        }
    }
    
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
            return statusPersetujuanCell
        } else {
            let statusActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusActionCell", for: indexPath) as! StatusActionCell
            statusActionCell.data = listStatusAction[indexPath.item]
            statusActionCell.delegate = self
            statusActionCell.position = indexPath.item
            return statusActionCell
        }
    }
}

extension DetailPersetujuanCutiController: StatusActionCellProtocol, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
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
            
            self.buttonProses.isEnabled = false
            self.view.makeToast(success.message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.navigationController?.popViewController(animated: true)
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
            
            self.buttonProses.isEnabled = false
            self.view.makeToast(success.message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func switchChange(status: String, position: Int) {
        listStatusAction[position].isApproved = status
        statusActionCollectionView.reloadItems(at: [IndexPath(item: position, section: 0)])
        print(listStatusAction)
    }
    
    @objc func switchStatusActionChange(mySwitch: UISwitch) {
        
        if listStatusAction.count == 0 {
            self.labelStatusAction.text = mySwitch.isOn ? "APPROVED" : "REJECTED"
        } else {
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
        }
        
        print(listStatusAction)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        SVProgressHUD.dismiss()
        
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                let docOpener = UIDocumentInteractionController.init(url: destinationURL)
                docOpener.delegate = self
                docOpener.presentPreview(animated: true)
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    @objc func viewLampiranContentClick() {
        guard let attachment = attachment else { return }
        
        guard let url = URL(string: attachment) else {
            self.function.showUnderstandDialog(self, "File Tidak Ditemukan", "File yang ingin didownload tidak tersedia di server.", "Mengerti")
            return
        }
        
        print("lampiran clicked \(url)")
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "Sedang mendownload file...")
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @IBAction func buttonProsesClick(_ sender: Any) {
        if fieldCatatan.text.trim() == "" {
            self.view.makeToast("Catatan Status harus diisi.")
            return
        }
        
        guard let detailLeave = detailLeave else { return }
        
        if detailLeave.is_day == "1" && detailLeave.is_range == "0" {
            self.approvalLeaveByDate()
        } else {
            self.approvalLeaveOneDayAndRange()
        }
    }
}
