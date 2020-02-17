//
//  RealisasiPeminjamanRuanganController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 25/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD

protocol RealisasiPeminjamanRuanganProtocol {
    func updateData()
}

class RealisasiPeminjamanRuanganController: BaseViewController {

    @IBOutlet weak var viewKeterangan: UIView!
    @IBOutlet weak var textviewKeterangan: CustomTextView!
    @IBOutlet weak var imageTambahLampiran: UIImageView!
    @IBOutlet weak var collectionLampiran: UICollectionView!
    @IBOutlet weak var buttonSimpan: UIButton!
    
    private var listLampiran = [LampiranModel]()
    
    var requestRoomId: String?
    var delegate: RealisasiPeminjamanRuanganProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        imageTambahLampiran.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTambahLampiranClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionLampiran.collectionViewLayout.invalidateLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        buttonSimpan.giveBorder(5, 0, "fff")
        viewKeterangan.giveBorder(3, 1, "dedede")
        
        let collectionLampiranLayout = collectionLampiran.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLampiranLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 89)
        
        collectionLampiran.register(UINib(nibName: "LampiranPeminjamanRuangCell", bundle: nil), forCellWithReuseIdentifier: "LampiranPeminjamanRuangCell")
        collectionLampiran.dataSource = self
        collectionLampiran.delegate = self
    }
    
    private func realizationRequestRooms(body: [String: String]) {
        SVProgressHUD.show()
        
        informationNetworking.realizationRequestRooms(body: body, listFiles: listLampiran) { (error, success, isExpired) in
            DispatchQueue.main.async {
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
                        self.function.showUnderstandDialog(self, "Gagal Melakukan Realisasi", _error, "Ulangi", "Cancel") {
                            self.realizationRequestRooms(body: body)
                        }
                    }
                    return
                }
                
                guard let _success = success else { return }
                
                self.view.makeToast(_success.message ?? "", duration: 1)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let _delegate = self.delegate {
                        _delegate.updateData()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

extension RealisasiPeminjamanRuanganController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listLampiran.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LampiranPeminjamanRuangCell", for: indexPath) as! LampiranPeminjamanRuangCell
        cell.data = listLampiran[indexPath.item]
        cell.imageDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionImageDeleteClick(sender:))))
        return cell
    }
}

extension RealisasiPeminjamanRuanganController: DialogTambahLampiranProtocol {
    func tambahClick(title: String, file: String, data: Data) {
        listLampiran.append(LampiranModel(title: title, file: file, data: data))
        collectionLampiran.reloadData()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSimpanClick(_ sender: Any) {
        guard let _requestRoomId = requestRoomId else { return }
        
        var body: [String: String] = [
            "requestrooms_id": _requestRoomId,
            "description": textviewKeterangan.text.trim()
        ]
        
        if listLampiran.count > 0 {
            for (index, item) in listLampiran.enumerated() {
                body.updateValue(item.title, forKey: "attachment_title[\(index)]")
            }
        }
        
        realizationRequestRooms(body: body)
    }
    
    @objc func collectionImageDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionLampiran.indexPathForItem(at: sender.location(in: collectionLampiran)) else { return }
        
        listLampiran.remove(at: indexpath.item)
        collectionLampiran.reloadData()
    }
    
    @objc func imageTambahLampiranClick() {
        let vc = DialogTambahLampiran()
        vc.delegate = self
        self.showCustomDialog(vc)
    }
}
