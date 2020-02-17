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

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelKaryawanKosong: UILabel!
    @IBOutlet weak var daftarKaryawanCollectionView: UICollectionView!
    
    var lastVelocityYSign = 0
    var allowLoadMore = false
    var isCalculateKaryawanHeight = false
    var listKaryawan = [ItemKaryawan]()
    var totalPage = 0
    var currentPage = 0
    var request: (emp_name: String, unit_id: String, workarea_id: String, gender: String, order_id: String)?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        request = (emp_name: "", unit_id: "", workarea_id: "", gender: "", order_id: "")
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        initCollectionView()
        
        getEmpList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        daftarKaryawanCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private func initCollectionView() {
        daftarKaryawanCollectionView.register(UINib(nibName: "KaryawanCell", bundle: nil), forCellWithReuseIdentifier: "KaryawanCell")
        
        daftarKaryawanCollectionView.delegate = self
        daftarKaryawanCollectionView.dataSource = self
        daftarKaryawanCollectionView.addSubview(refreshControl)
    }
    
    private func getEmpList() {
        SVProgressHUD.show()
        
        informationNetworking.getEmpList((emp_name: request!.emp_name, unit_id: request!.unit_id, workarea_id: request!.workarea_id, gender: request!.gender, page: String(currentPage), order_id: request!.order_id)) { (error, karyawan, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Karyawan", error, "Reload", "Cancel", completionHandler: {
                        self.getEmpList()
                    })
                }
                
                guard let karyawan = karyawan else { return }
                
                if self.currentPage == 0 { self.listKaryawan.removeAll() }
                
                if karyawan.data!.emp.count == 0 && self.listKaryawan.count == 0 {
                    self.labelKaryawanKosong.text = karyawan.message
                    self.labelKaryawanKosong.isHidden = false
                } else {
                    self.labelKaryawanKosong.isHidden = true
                }
                
                self.totalPage = (karyawan.data?.total_page!)!
                self.currentPage += 1
                
                for itemKaryawan in karyawan.data!.emp {
                    self.listKaryawan.append(itemKaryawan)
                }
                
                self.daftarKaryawanCollectionView.reloadData()
            }
        }
    }
}

extension DaftarKaryawanController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listKaryawan.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
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
        let karyawanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KaryawanCell", for: indexPath) as! KaryawanCell
        
        if !isCalculateKaryawanHeight {
            self.isCalculateKaryawanHeight = true
            DispatchQueue.main.async {
                let karyawanCellLayout = self.daftarKaryawanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let karyawanCellHeight = ((UIScreen.main.bounds.width - 28) * 0.27) + karyawanCell.labelName.getHeight(width: karyawanCell.labelName.frame.width) + karyawanCell.labelJabatan.getHeight(width: karyawanCell.labelJabatan.frame.width) + karyawanCell.labelPosition.getHeight(width: karyawanCell.labelPosition.frame.width) + 8.2 + 4.1 + 4.1 + 12.9
                karyawanCellLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: karyawanCellHeight)
            }
        }
        
        karyawanCell.data = listKaryawan[indexPath.item]
        karyawanCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(karyawanContainerClick(sender:))))
        return karyawanCell
    }
}

//click event
extension DaftarKaryawanController: FilterKaryawanControllerProtocol {
    func reloadKaryawan(empName: String, unit_id: String, workarea_id: String, gender: String, order_id: String) {
        request = (emp_name: empName, unit_id: unit_id, workarea_id: workarea_id, gender: gender, order_id: order_id)
        currentPage = 0
        getEmpList()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
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
