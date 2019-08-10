//
//  DetailCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DetailCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelDateSubmitted: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelUnitKerja: UILabel!
    @IBOutlet weak var labelJenisIjin: UILabel!
    @IBOutlet weak var labelAlasan: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var statusPersetujuanCollectionView: UICollectionView!
    @IBOutlet weak var statusPersetujuanCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAwalInput: UILabel!
    @IBOutlet weak var labelInfoPembatalan: UILabel!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    var listStatusPersetujuan = [StatusPersetujuan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        getStatusPersetujuan()
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        viewRootHeight.constant -= statusPersetujuanCollectionHeight.constant
        statusPersetujuanCollectionHeight.constant = 0
        
        viewImage.giveBorder(3, 1, "dedede")
    }
    
    private func getStatusPersetujuan() {
        listStatusPersetujuan.append(StatusPersetujuan(index: "1", nama: "Wayan Wijaya", type: "Pengaju", status: "Submited"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "2", nama: "RIYAN TRISNA WIBOWO", type: "-", status: "On Progress"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "3", nama: "A. TOTO PRIYONO", type: "-", status: "Approved"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "4", nama: "FEBRIANA PUTRI KUSUMA", type: "-", status: "Submited"))
        
        statusPersetujuanCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                self.viewRootHeight.constant += self.statusPersetujuanCollectionView.contentSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func initCollectionView() {
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        let statusPersetujuanCell = statusPersetujuanCollectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: IndexPath(item: 0, section: 0)) as! StatusPersetujuanCell
        let statusPersetujuanLayout = statusPersetujuanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        statusPersetujuanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusPersetujuanCell.viewContainer.frame.height)
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
    }
    
}

extension DetailCutiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listStatusPersetujuan.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
        cell.data = listStatusPersetujuan[indexPath.item]
        return cell
    }
}

extension DetailCutiController {
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
