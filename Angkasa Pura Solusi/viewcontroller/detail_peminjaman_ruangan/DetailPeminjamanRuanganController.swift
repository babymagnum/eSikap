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
    
    private var listLampiran = [DetailsRequestRoomsAttachment]()
    
    var requestRoomId: String?
    var isFromHistory: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getDetailPeminjamanRuangan()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getDetailPeminjamanRuangan() {
        guard let _requestRoomId = requestRoomId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailsRequestRooms(requestRoomId: _requestRoomId) { (error, detailRequest, isExpired) in
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
            
            DispatchQueue.main.async {
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
            partisipan += index == detailRequest.participants.count - 1 ? "\(index + 1). \(item)" : "\(index + 1). \(item)\n\n"
        }
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
        }
    }
}

extension DetailPeminjamanRuanganController: URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionLampiran.indexPathForItem(at: sender.location(in: collectionLampiran)) else { return }
        
        guard let url = URL(string: listLampiran[indexpath.item].file ?? "") else {
            self.function.showUnderstandDialog(self, "File Tidak Ditemukan", "File yang ingin didownload tidak tersedia di server.", "Mengerti")
            return
        }
        
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
        cell.labelLampiran.text = listLampiran[indexPath.item].title
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}
