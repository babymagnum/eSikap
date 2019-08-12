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
    
    var listRiwayatCuti = [RiwayatCuti]()
    
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
        //let millis = PublicFunction.instance.dateStringToInt(stringDate: listHistory[indexPath.row].trans_date!, pattern: "yyyy-MM-dd kk:mm:ss")
        //let date = PublicFunction.instance.dateLongToString(dateInMillis: millis, pattern: "dd MMMM yyyy")
        
        if indexPath.row > 0 {
            //let millisBefore = PublicFunction.instance.dateStringToInt(stringDate: listHistory[indexPath.row - 1].trans_date!, pattern: "yyyy-MM-dd kk:mm:ss")
            //let dateBefore = PublicFunction.instance.dateLongToString(dateInMillis: millisBefore, pattern: "dd MMMM yyyy")
            
            let before = listRiwayatCuti[indexPath.item - 1]
            
            let dateBefore = before.date
            let dateItem = item.date
            
            if dateBefore == dateItem {
                item.isSameDate = true
            } else {
                item.isSameDate = false
            }
        } else {
            item.isSameDate = false
        }
        
        cell.data = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiwayatCutiCell", for: indexPath) as! RiwayatCutiCell
        
        let originalHeight = cell.labelDate.frame.height + 20 + cell.viewInformation.frame.height
        let withoutDateHeight = cell.viewInformation.frame.height + 18
        
        if indexPath.row > 0 {
            //let millis = PublicFunction.instance.dateStringToInt(stringDate: listHistory[indexPath.row].trans_date!, pattern: "yyyy-MM-dd kk:mm:ss")
            //let date = PublicFunction.instance.dateLongToString(dateInMillis: millis, pattern: "dd MMMM yyyy")
            //let millisBefore = PublicFunction.instance.dateStringToInt(stringDate: listHistory[indexPath.row - 1].trans_date!, pattern: "yyyy-MM-dd kk:mm:ss")
            //let dateBefore = PublicFunction.instance.dateLongToString(dateInMillis: millisBefore, pattern: "dd MMMM yyyy")
            
            let dateBefore = listRiwayatCuti[indexPath.item - 1].date
            let dateItem = listRiwayatCuti[indexPath.item].date
            
            if dateBefore == dateItem {
                return CGSize(width: UIScreen.main.bounds.width - 24, height: withoutDateHeight)
            } else {
                return CGSize(width: UIScreen.main.bounds.width - 24, height: originalHeight)
            }
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 24, height: originalHeight)
        }
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
