//
//  CutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 09/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CutiController: BaseViewController, IndicatorInfoProvider, UICollectionViewDelegate {
    
    @IBOutlet weak var cutiCollectionView: UICollectionView!
    
    var listCuti = [Cuti]()
    var isCalculateCutiHeight = false
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CUTI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        
        getCuti()
    }
    
    // use this function to call protocol to notify the tablayout that page is change
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func getCuti() {
        listCuti.append(Cuti(id: "1", image: "", name: "Wayan", kode: "LVE.2019.05.000410", typeCuti: "Sakit Dengan Surat Dokter", tanggalCuti: "31 Mei 2019 - 01 Juni 2019", timeSubmitted: "14:25"))
        listCuti.append(Cuti(id: "2", image: "", name: "Hendra", kode: "LVE.2019.05.039210", typeCuti: "Izin Meninggalkan Pekerjaan Sementara", tanggalCuti: "31 Mei 2019", timeSubmitted: "14:10"))
        listCuti.append(Cuti(id: "3", image: "", name: "Putri", kode: "LVE.2019.05.123410", typeCuti: "Cuti Tahunan", tanggalCuti: "31 Mei 2019 - 02 Juni 2019", timeSubmitted: "14:20"))
        
        cutiCollectionView.reloadData()
    }
    
    private func initCollectionView() {
        cutiCollectionView.register(UINib(nibName: "CutiCell", bundle: nil), forCellWithReuseIdentifier: "CutiCell")
        
        cutiCollectionView.delegate = self
        cutiCollectionView.dataSource = self
    }
}

extension CutiController {
    @objc func cutiContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = cutiCollectionView.indexPathForItem(at: sender.location(in: cutiCollectionView)) else { return }
        
        let vc = DetailPersetujuanCutiController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CutiController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CutiCell", for: indexPath) as! CutiCell
        
        if !isCalculateCutiHeight {
            self.isCalculateCutiHeight = true
            DispatchQueue.main.async {
                let cutiLayout = self.cutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                cutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 26, height: cutiCell.viewContainer.frame.height + 10)
            }
        }
        
        cutiCell.data = listCuti[indexPath.item]
        cutiCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cutiContainerClick(sender:))))
        return cutiCell
    }
}
