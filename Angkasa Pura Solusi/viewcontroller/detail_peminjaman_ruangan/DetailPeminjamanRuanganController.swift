//
//  DetailPeminjamanRuanganController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 23/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailPeminjamanRuanganController: BaseViewController {

    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var labelPengaju: CustomLabel!
    @IBOutlet weak var labelJudul: CustomLabel!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var labelRuang: CustomLabel!
    @IBOutlet weak var labelWaktu: CustomLabel!
    @IBOutlet weak var labelPartisipan: CustomLabel!
    @IBOutlet weak var labelJumlahOrang: CustomLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionLampiran: UICollectionView!
    @IBOutlet weak var collectionLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var labelLampiran: CustomLabel!
    @IBOutlet weak var buttonBatalkanHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBatalkanBot: NSLayoutConstraint!
    
    private var listLampiran = [DetailsRequestRoomsAttachment]()
    
    var requestRoomId: String?
    var isFromHistory: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getDetailData()
    }
    
    private func getDetailData() {
        guard let _isFromHistory = isFromHistory else { return }
        
        if _isFromHistory {
            getDetailPeminjamanRuanganByUser()
        } else {
            getDetailPeminjamanRuangan()
        }
    }
    
    private func getDetailPeminjamanRuanganByUser() {
        guard let _requestRoomId = requestRoomId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailRequestRoomsByUser(requestRoomId: _requestRoomId) { (error, detailRequest, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getDetailPeminjamanRuangan()
                    }
                    return
                }
                
                guard let _detailRequest = detailRequest else { return }
                
                self.updateLayout(_detailRequest.data[0])
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getDetailPeminjamanRuangan() {
        guard let _requestRoomId = requestRoomId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailsRequestRooms(requestRoomId: _requestRoomId) { (error, detailRequest, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getDetailPeminjamanRuangan()
                    }
                    return
                }
                
                guard let _detailRequest = detailRequest else { return }
                
                self.updateLayout(_detailRequest.data[0])
            }
        }
    }
    
    private func updateLayout(_ detailRequest: DetailsRequestRoomsData) {
        labelPengaju.text = detailRequest.requestor
        labelJudul.text = detailRequest.title_agenda
        labelKeterangan.text = detailRequest.description
        labelRuang.text = detailRequest.room_name
        labelWaktu.text = "Mulai   - \(detailRequest.start ?? "")\nSelesai   - \(detailRequest.end ?? "")"
        var partisipan = ""
        for (index, item) in detailRequest.participants.enumerated() {
            partisipan += index == detailRequest.participants.count - 1 ? "\(index + 1). \(item.trim())" : "\(index + 1). \(item.trim())\n\n"
        }
        labelLampiran.isHidden = detailRequest.attachment.count == 0
        labelPartisipan.text = partisipan
        labelJumlahOrang.text = detailRequest.total_person
        listLampiran = detailRequest.attachment
        collectionLampiran.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.collectionLampiranHeight.constant = self.collectionLampiran.contentSize.height
            self.scrollView.resizeScrollViewContentSize()
            self.view.layoutIfNeeded()
            self.scrollView.isHidden = false
        }
        
        guard let _buttonCancelIsShow = detailRequest.button_cancel_is_show else { return }

        if _buttonCancelIsShow == "0" {
            buttonAction.setTitle("Realisasi", for: .normal)
            buttonAction.backgroundColor = UIColor(hexString: "9ccc65")
            buttonAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonActionRealisasi)))
        } else {
            buttonAction.setTitle("Batalkan", for: .normal)
            buttonAction.backgroundColor = UIColor(hexString: "e23d3d")
            buttonAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonActionBatalkan)))
        }
    }

    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        buttonAction.giveBorder(5, 0, "fff")
        collectionLampiran.register(UINib(nibName: "LampiranCell", bundle: nil), forCellWithReuseIdentifier: "LampiranCell")
        collectionLampiran.delegate = self
        collectionLampiran.dataSource = self
        let collectionLampiranLayout = collectionLampiran.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLampiranLayout.itemSize = CGSize(width: collectionLampiran.frame.size.width - 20, height: 20)
        if let _isFromHistory = isFromHistory {
            buttonAction.isHidden = _isFromHistory ? false : true
            
            if !_isFromHistory {
                print("from home tanggal")
                buttonBatalkanHeight.constant = 0
                buttonBatalkanBot.constant = 0
                scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension DetailPeminjamanRuanganController: URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate, RealisasiPeminjamanRuanganProtocol {
    
    func updateData() {
        getDetailData()
    }
    
    private func cancelRequestRoom() {
        guard let _requestRoomId = requestRoomId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.cancelRequestRooms(requestRoomId: _requestRoomId) { (error, success, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Pembatalan", _error, "Reload", "Cancel") {
                        self.cancelRequestRoom()
                    }
                    return
                }
                
                guard let _ = success else { return }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonActionRealisasi() {
        guard let _requestRoomId = requestRoomId else { return }
        
        let vc = RealisasiPeminjamanRuanganController()
        vc.requestRoomId = _requestRoomId
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonActionBatalkan() {
        cancelRequestRoom()
    }
    
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionLampiran.indexPathForItem(at: sender.location(in: collectionLampiran)) else { return }
        
        guard let url = URL(string: listLampiran[indexpath.item].file ?? "") else {
            self.function.showUnderstandDialog(self, "File Tidak Ditemukan", "File yang ingin didownload tidak tersedia di server.", "Mengerti")
            return
        }
        
        print("file \(url)")
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "Sedang mendownload file...")
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        SVProgressHUD.dismiss()
        
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
}

extension DetailPeminjamanRuanganController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listLampiran.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LampiranCell", for: indexPath) as! LampiranCell
        cell.labelLampiran.text = "\(indexPath.item + 1). \(listLampiran[indexPath.item].title ?? "")"
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}
