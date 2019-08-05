//
//  DaftarKaryawanController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class DaftarKaryawanController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var daftarKaryawanCollectionView: UICollectionView!
    
    var lastVelocityYSign = 0
    var allowLoadMore = false
    var listKaryawan = [ItemKaryawan]()
    var totalPage = 0
    var currentPage = 0
    var request: (emp_name: String, unit_id: String, workarea_id: String, gender: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        request = (emp_name: "", unit_id: preference.getString(key: staticLet.UNIT), workarea_id: preference.getString(key: staticLet.WORKAREA), gender: preference.getString(key: staticLet.GENDER))
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initCollectionView()
        
        getEmpList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private func initCollectionView() {
        daftarKaryawanCollectionView.register(UINib(nibName: "KaryawanCell", bundle: nil), forCellWithReuseIdentifier: "KaryawanCell")
        
        let karyawanCell = daftarKaryawanCollectionView.dequeueReusableCell(withReuseIdentifier: "KaryawanCell", for: IndexPath(item: 0, section: 0)) as! KaryawanCell
        let karyawanCellLayout = daftarKaryawanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        karyawanCellLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: karyawanCell.viewContainer.frame.height)
        
        daftarKaryawanCollectionView.delegate = self
        daftarKaryawanCollectionView.dataSource = self
    }
    
    private func getEmpList() {
        SVProgressHUD.show()
        
        informationNetworking.getEmpList((emp_name: request!.emp_name, unit_id: request!.unit_id, workarea_id: request!.workarea_id, gender: request!.gender, page: String(currentPage))) { (error, karyawan) in
        
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Karyawan", error, "Reload", "Cancel", completionHandler: {
                    self.getEmpList()
                })
            }
            
            guard let karyawan = karyawan else { return }
            
            self.totalPage = karyawan.total_page!
            self.currentPage += 1
            
            for itemKaryawan in karyawan.emp {
                self.listKaryawan.append(itemKaryawan)
            }
            
            DispatchQueue.main.async { self.daftarKaryawanCollectionView.reloadData() }
        }
    }
}

extension DaftarKaryawanController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listKaryawan.count - 1 {
            if self.allowLoadMore && currentPage + 1 < totalPage {
                self.getEmpList()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allowLoadMore = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listKaryawan.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KaryawanCell", for: indexPath) as! KaryawanCell
        cell.data = listKaryawan[indexPath.item]
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(karyawanContainerClick(sender:))))
        return cell
    }
}

//click event
extension DaftarKaryawanController: FilterKaryawanControllerProtocol {
    func reloadKaryawan(empName: String) {
        print("reload karyawan")
        request = (emp_name: empName, unit_id: preference.getString(key: staticLet.UNIT), workarea_id: preference.getString(key: staticLet.WORKAREA), gender: preference.getString(key: staticLet.GENDER))
        
        listKaryawan.removeAll()
        currentPage = 0
        getEmpList()
    }
    
    @objc func karyawanContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = daftarKaryawanCollectionView.indexPathForItem(at: sender.location(in: daftarKaryawanCollectionView)) else { return }
        
        let vc = ProfilController()
        vc.open = .otherProfile
        vc.empId = listKaryawan[indexpath.item].emp_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterKaryawanController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
