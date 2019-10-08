//
//  DetailCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup

class DetailCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewLampiranContent: UIView!
    @IBOutlet weak var labelLampiran: CustomLabel!
    @IBOutlet weak var viewLampiran: UIView!
    @IBOutlet weak var viewLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTitleTop: CustomLabel!
    @IBOutlet weak var labelStatusTop: CustomButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelDateSubmitted: UILabel!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelUnitKerja: UILabel!
    @IBOutlet weak var labelJenisIjin: UILabel!
    @IBOutlet weak var labelAlasan: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var buttonBatalkan: CustomButton!
    @IBOutlet weak var statusPersetujuanCollectionView: UICollectionView!
    @IBOutlet weak var statusPersetujuanCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAwalInput: UILabel!
    @IBOutlet weak var labelInfoPembatalan: CustomLabel!
    @IBOutlet weak var collectionTanggalCuti: UICollectionView!
    @IBOutlet weak var collectionTanggalCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelUbahanTerakhir: CustomLabel!
    
    private var listStatusPersetujuan = [ItemApproval]()
    private var listTanggalCuti = [ItemDateShow]()
    private var attachmentUrl: String?
    
    var leave_id: String!
    var title_content: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initEvent()
        
        initCollectionView()
        
        getData()
    }
    
    private func initEvent() {
        viewLampiranContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLampiranContentClick)))
    }
    
    private func getData() {
        labelTitleTop.text = title_content
        
        if title_content == "Detail Cuti" {
            getDetailLeave()
        } else {
            getDetailLeaveDelegationById()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getDetailLeaveDelegationById() {
        SVProgressHUD.show()
        
        informationNetworking.getDetailLeaveDelegationById(leave_id: leave_id) { (error, detailDelegationList, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Detail Delegasi", error, "Reload", "Cancel", completionHandler: {
                    self.getDetailLeaveDelegationById()
                })
                return
            }
            
            guard let detailDelegationList = detailDelegationList else { return }
            
            self.setViewDelegasi(detailDelegationList)
        }
    }
    
    private func setViewDelegasi(_ detailDelegation: DetailDelegationList) {
        let item = detailDelegation.data?.leave[0]
        
        if item?.attachment_name == "" {
            UIView.animate(withDuration: 0.2) {
                self.viewLampiranHeight.constant = 0
                self.viewLampiran.alpha = 0
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
        attachmentUrl = item?.attachment
        labelLampiran.text = item?.attachment_name
        labelStatusTop.setTitle(item?.status, for: .normal)
        labelStatusTop.backgroundColor = UIColor(hexString: String((item?.status_color?.dropFirst())!))
        imageAccount.loadUrl((item?.photo)!)
        labelNama.text = ": \(item?.emp_name ?? "")"
        labelUnitKerja.text = ": \(item?.unit_name ?? "")"
        labelJenisIjin.text = ": \(item?.type_name ?? "")"
        labelAlasan.text = ": \(item?.reason ?? "")"
        labelTanggal.text = (item?.date_show.count)! > 0 ? ": -" : ": \(item?.dates ?? "")"
        labelInfoPembatalan.text = item?.cancel_notes
        labelAwalInput.text = item?.last_insert
        labelUbahanTerakhir.text = item?.last_update
        listTanggalCuti = item!.date_show
        listStatusPersetujuan = item!.approval
        labelDateSubmitted.text = "Diajukan pada \(item?.date ?? "")"
        labelKodeCuti.text = item?.number
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        collectionTanggalCuti.reloadData()
        statusPersetujuanCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionTanggalCutiHeight.constant = self.collectionTanggalCuti.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        scrollView.alpha = 0
        labelStatusTop.layer.cornerRadius = labelStatusTop.frame.height / 2
        buttonBatalkan.giveBorder(5, 1, "ea1c18")
        imageAccount.clipsToBounds = true
        imageAccount.layer.cornerRadius = (UIScreen.main.bounds.width * 0.15) / 2
        
        scrollView.resizeScrollViewContentSize()
    }
    
    private func getDetailLeave() {
        SVProgressHUD.show()
        
        informationNetworking.getDetailLeaveById(id: leave_id) { (error, detailRiwayatCuti, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Detail Cuti", error, "Reload", "Understand", completionHandler: {
                    self.getDetailLeave()
                })
                return
            }
            
            guard let detailRiwayatCuti = detailRiwayatCuti else { return }
            
            self.setViewContent(detailRiwayatCuti)
        }
    }
    
    private func setViewContent(_ detailRiwayatCuti: DetailRiwayatCuti) {
        let item = detailRiwayatCuti.data?.leave[0]
        
        if item?.attachment_name == "" {
            UIView.animate(withDuration: 0.2) {
                self.viewLampiranHeight.constant = 0
                self.viewLampiran.alpha = 0
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
        
        if item?.cancel_button_is_show == "1" {
            buttonBatalkan.isHidden = false
            labelInfoPembatalan.text = ""
        } else {
            buttonBatalkan.isHidden = true
        }
        
        attachmentUrl = item?.attachment
        labelLampiran.text = item?.attachment_name
        labelStatusTop.setTitle(item?.status, for: .normal)
        labelStatusTop.backgroundColor = UIColor(hexString: String((item?.status_color?.dropFirst())!))
        imageAccount.loadUrl((item?.photo)!)
        labelNama.text = ": \(item?.emp_name ?? "")"
        labelUnitKerja.text = ": \(item?.unit_name ?? "")"
        labelJenisIjin.text = ": \(item?.type_name ?? "")"
        labelAlasan.text = ": \(item?.reason ?? "")"
        labelTanggal.text = (item?.date_show.count)! > 0 ? ": -" : ": \(item?.dates ?? "")"
        labelInfoPembatalan.text = item?.cancel_notes
        labelAwalInput.text = item?.last_insert
        labelUbahanTerakhir.text = item?.last_update
        listTanggalCuti = item!.date_show
        listStatusPersetujuan = item!.approval
        labelDateSubmitted.text = "Diajukan pada \(item?.date ?? "")"
        labelKodeCuti.text = item?.number
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        collectionTanggalCuti.reloadData()
        statusPersetujuanCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionTanggalCutiHeight.constant = self.collectionTanggalCuti.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusPersetujuanCollectionView.collectionViewLayout.invalidateLayout()
        collectionTanggalCuti.collectionViewLayout.invalidateLayout()
    }
    
    private func initCollectionView() {
        collectionTanggalCuti.register(UINib(nibName: "DetailTanggalCutiCell", bundle: nil), forCellWithReuseIdentifier: "DetailTanggalCutiCell")
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
        
        collectionTanggalCuti.delegate = self
        collectionTanggalCuti.dataSource = self
    }
    
}

extension DetailCutiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            return CGSize(width: self.collectionTanggalCuti.frame.width, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusPersetujuanCollectionView {
            return listStatusPersetujuan.count
        } else {
            return listTanggalCuti.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == statusPersetujuanCollectionView {
            let statusPersetujuanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
            statusPersetujuanCell.data = listStatusPersetujuan[indexPath.item]
            return statusPersetujuanCell
        } else {
            let tanggalCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailTanggalCutiCell", for: indexPath) as! DetailTanggalCutiCell
            tanggalCutiCell.data = listTanggalCuti[indexPath.item]
            return tanggalCutiCell
        }
        
    }
}

extension DetailCutiController: DialogBatalkanProtocol, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    func updateData() {
        getDetailLeave()
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
        guard let attachment = attachmentUrl else { return }
        
        guard let url = URL(string: attachment) else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "Sedang mendownload file...")
    }
    
    @IBAction func buttonBatalkanClick(_ sender: Any) {
        let dialogVc = DialogBatalkanCutiController()
        dialogVc.leave_id = leave_id
        dialogVc.delegate = self
        let vc = PopupViewController(contentController: dialogVc, popupWidth: UIScreen.main.bounds.width, popupHeight: UIScreen.main.bounds.height)
        vc.shadowEnabled = false
        present(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
