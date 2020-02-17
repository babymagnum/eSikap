//
//  DetailPeminjamanMobilController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailPeminjamanMobilController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelAreaTujuan: CustomLabel!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var labelAlamat: CustomLabel!
    @IBOutlet weak var labelPropinsi: CustomLabel!
    @IBOutlet weak var labelKabupaten: CustomLabel!
    @IBOutlet weak var labelTujuan: CustomLabel!
    @IBOutlet weak var labelKategori: CustomLabel!
    @IBOutlet weak var labelJumlahOrang: CustomLabel!
    @IBOutlet weak var labelNamaPenumpang: CustomLabel!
    @IBOutlet weak var labelUndangan: CustomLabel!
    @IBOutlet weak var labelInformasiStatus: CustomLabel!
    @IBOutlet weak var labelKendaraan: CustomLabel!
    @IBOutlet weak var collectionInformasiPersetujuan: UICollectionView!
    @IBOutlet weak var collectionInformasiPersetujuanHeight: NSLayoutConstraint!
    
    var requestId: String?
    
    private var listInformasiPersetujuan = [DetailRequestCarApprovalItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getDetail()
    }
    
    private func getDetail() {
        guard let _requestId = requestId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailRequestCar(requestId: _requestId) { (error, detailRequest, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload") {
                        self.getDetail()
                    }
                    return
                }
                
                guard let _detailRequest = detailRequest else { return }
                
                UIView.animate(withDuration: 0.2) {
                    self.updateLayout(detailRequest: _detailRequest)
                }
            }
        }
    }
    
    private func updateLayout(detailRequest: DetailRequestCar) {
        guard let data = detailRequest.data else { return }
        viewContent.isHidden = false
        labelTujuan.text = data.purpose
        labelAlamat.text = data.address
        labelPropinsi.text = data.state_name
        labelKabupaten.text = data.city_name
        labelAreaTujuan.text = data.dest_name
        labelKategori.text = data.category_name
        labelJumlahOrang.text = data.passenger_qty
        var passengerName = ""
        for (index, item) in data.participants.enumerated() {
            passengerName += index == data.participants.count - 1 ? item.emp_name : "\(item.emp_name)\n\n"
        }
        labelNamaPenumpang.text = passengerName
        let kendaraan = "Nopol: \(data.vehicle_nopol ?? "-")\nMerk: \(data.vehicle_name ?? "-")\nDriver: \(data.driver_name ?? "-")\nCapacity: \(data.vehicle_capacity ?? "-") orang"
        labelKendaraan.text = kendaraan
        labelUndangan.text = data.invitation
        labelInformasiStatus.text = data.status_name
        labelInformasiStatus.textColor = UIColor(hexString: "\(data.status_color?.dropFirst() ?? "9ccc65")")
        
        data.approval.forEach { (item) in
            self.listInformasiPersetujuan.append(item)
        }
        
        collectionInformasiPersetujuan.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.collectionInformasiPersetujuanHeight.constant = self.collectionInformasiPersetujuan.contentSize.height
            self.scrollView.resizeScrollViewContentSize()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionInformasiPersetujuan.collectionViewLayout.invalidateLayout()
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        viewContent.isHidden = true
        collectionInformasiPersetujuanHeight.constant = 0
        scrollView.resizeScrollViewContentSize()
        self.view.layoutIfNeeded()
        
        let collectionLayout = collectionInformasiPersetujuan.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: collectionInformasiPersetujuan.frame.size.width, height: 20)
        collectionInformasiPersetujuan.register(UINib(nibName: "InformasiPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "InformasiPersetujuanCell")
        collectionInformasiPersetujuan.delegate = self
        collectionInformasiPersetujuan.dataSource = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension DetailPeminjamanMobilController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listInformasiPersetujuan.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiPersetujuanCell", for: indexPath) as! InformasiPersetujuanCell
        cell.data = listInformasiPersetujuan[indexPath.item]
        return cell
    }
}

extension DetailPeminjamanMobilController {
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
