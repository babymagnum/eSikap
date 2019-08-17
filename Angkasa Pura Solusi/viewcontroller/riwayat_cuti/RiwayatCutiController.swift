//
//  RiwayatCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class RiwayatCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var riwayatCutiCollectionView: UICollectionView!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    
    var listRiwayatCuti = [RiwayatCuti]()
    var isCalculatRiwayatCutiHeight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        getRiwayatCuti()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getRiwayatCuti() {
        listRiwayatCuti.append(RiwayatCuti(date: "15 Mei 2019", kode: "LVE.2019.05.123410", status: "Saved", type: "Cuti Tahunan", tanggal: "20 Mei 2019 - 30 Mei 2019", time: "14:48", isSameDate: false))
        listRiwayatCuti.append(RiwayatCuti(date: "15 Mei 2019", kode: "LVE.2019.05.000410", status: "Submited", type: "Sakit Dengan Surat Dokter", tanggal: "31 Mei 2019 - 01 Juni 2019", time: "14:48", isSameDate: false))
        listRiwayatCuti.append(RiwayatCuti(date: "14 Mei 2019", kode: "LVE.2019.05.000410", status: "Submited", type: "Sakit Dengan Surat Dokter", tanggal: "31 Mei 2019 - 01 Juni 2019", time: "14:48", isSameDate: false))
        
        DispatchQueue.main.async {
            self.riwayatCutiCollectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.riwayatCutiCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func initCollectionView() {
        riwayatCutiCollectionView.register(UINib(nibName: "RiwayatCutiCell", bundle: nil), forCellWithReuseIdentifier: "RiwayatCutiCell")
        
        riwayatCutiCollectionView.delegate = self
        riwayatCutiCollectionView.dataSource = self
        riwayatCutiCollectionView.isPrefetchingEnabled = false
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
    }
    
}

extension RiwayatCutiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRiwayatCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiwayatCutiCell", for: indexPath) as! RiwayatCutiCell
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cutiContainerClick(sender:))))
        
        var item = listRiwayatCuti[indexPath.item]
        
        DispatchQueue.main.async {
            if !self.isCalculatRiwayatCutiHeight {
                self.isCalculatRiwayatCutiHeight = true
                let originalHeight = cell.labelDate.getHeight(width: cell.labelDate.frame.width) + cell.labelKodeCuti.getHeight(width: cell.labelKodeCuti.frame.width) + cell.labelTypeIjin.getHeight(width: cell.labelTypeIjin.frame.width) + cell.labelTanggalIjin.getHeight(width: cell.labelTanggalIjin.frame.width) + 7.1 + 6.2 + 7.8 + 1.6 + 7.8
                let riwayatCutiLayout = self.riwayatCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                riwayatCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 24, height: originalHeight + 2)
            }
        }
        
        if indexPath.item > 0 {
            let before = self.listRiwayatCuti[indexPath.item - 1]
            let dateBefore = before.date
            let dateItem = item.date
            
            if dateItem == dateBefore {
                
                item.isSameDate = true
            }
            else { item.isSameDate = false }
        } else { item.isSameDate = false }
        
        cell.data = item
        return cell
    }
}

extension RiwayatCutiController {
    @objc func cutiContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = riwayatCutiCollectionView.indexPathForItem(at: sender.location(in: riwayatCutiCollectionView)) else { return }
        
        let vc = DetailCutiController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
