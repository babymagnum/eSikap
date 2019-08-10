//
//  PengajuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import iOSDropDown

class PengajuanCutiController: BaseViewController, UICollectionViewDelegate {

    //outlet root
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelUnit: UIButton!
    @IBOutlet weak var fieldJenisCuti: DropDown!
    @IBOutlet weak var viewJenisCuti: UIView!
    @IBOutlet weak var viewAlasan: UIView!
    @IBOutlet weak var fieldAlasan: UITextField!
    @IBOutlet weak var viewDelegasi: UIView!
    @IBOutlet weak var fieldDelegasi: UITextField!
    @IBOutlet weak var viewAtasan: UIView!
    @IBOutlet weak var fieldAtasan: UITextField!
    @IBOutlet weak var buttonSimpan: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    @IBOutlet weak var labelSisaJatahCuti: UILabel!
    @IBOutlet weak var labelKadaluarsaTop: UILabel!
    @IBOutlet weak var viewSisaJatahCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSisaJatahCuti: UIView!
    
    //outlet view cuti tahunan
    @IBOutlet weak var viewCutiTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCutiTahunanTanggal: UIView!
    @IBOutlet weak var viewCutiTahunan: UIView!
    @IBOutlet weak var jatahCutiCollectionView: UICollectionView!
    @IBOutlet weak var tanggalCutiCollectionView: UICollectionView!
    @IBOutlet weak var tanggalCutiCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var jatahCutiCollectionHeight: NSLayoutConstraint!
    
    //outlet view cuti akademik
    @IBOutlet weak var viewCutiAkademik: UIView!
    @IBOutlet weak var viewCutiAkademikHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTanggalCutiAkademik: UIView!
    
    //outlet view cuti sakit
    @IBOutlet weak var viewCutiSakit: UIView!
    @IBOutlet weak var viewCutiSakitHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRentangTanggalAwal: UIView!
    @IBOutlet weak var viewRentangTanggalAkhir: UIView!
    @IBOutlet weak var viewLampirkanFile: UIView!
    
    //outlet view cuti sementara
    @IBOutlet weak var viewCutiSementara: UIView!
    @IBOutlet weak var viewCutiSementaraHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTanggalCutiSementara: UIView!
    @IBOutlet weak var viewWaktuAwalCutiSementara: UIView!
    @IBOutlet weak var viewWaktuAkhirCutiSementara: UIView!
    
    var defaultViewCutiTahunanHeight: CGFloat = 0
    
    var listJatahCuti = [JatahCuti]()
    var listTanggalCuti = [TanggalCuti]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defaultViewCutiTahunanHeight = viewCutiTahunanHeight.constant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initView()
        
        initCollectionView()
        
        dropdownListener()
    }
    
    private func initCollectionView() {
        jatahCutiCollectionView.register(UINib(nibName: "JatahCutiCell", bundle: nil), forCellWithReuseIdentifier: "JatahCutiCell")
        tanggalCutiCollectionView.register(UINib(nibName: "TanggalCutiCell", bundle: nil), forCellWithReuseIdentifier: "TanggalCutiCell")
        
        // init jatah cuti
        let jatahCutiCell = jatahCutiCollectionView.dequeueReusableCell(withReuseIdentifier: "JatahCutiCell", for: IndexPath(item: 0, section: 0)) as! JatahCutiCell
        let jatahCutiLayout = jatahCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        jatahCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: jatahCutiCell.viewContainer.frame.height)
        
        // init tanggal cuti
        let tanggalCutiCell = tanggalCutiCollectionView.dequeueReusableCell(withReuseIdentifier: "TanggalCutiCell", for: IndexPath(item: 0, section: 0)) as! TanggalCutiCell
        let tanggalCutiLayout = tanggalCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        tanggalCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: tanggalCutiCell.viewContainer.frame.height)
        
        // set delegate
        tanggalCutiCollectionView.delegate = self
        jatahCutiCollectionView.delegate = self
        
        // set datasource
        tanggalCutiCollectionView.dataSource = self
        jatahCutiCollectionView.dataSource = self
        
        // populate dummy data
        listTanggalCuti.append(TanggalCuti(tanggal: "03-06-2019"))
        listTanggalCuti.append(TanggalCuti(tanggal: "10-06-2019"))
        
        listJatahCuti.append(JatahCuti(periode: ": 21/07/2018 - 21/07/2019", sisaCuti: ": 15 Hari", kadaluarsa: ": 10 Desember 2019"))
        listJatahCuti.append(JatahCuti(periode: ": 21/07/2018 - 21/07/2019", sisaCuti: ": 7 Hari", kadaluarsa: ": 10 Desember 2019"))
        listJatahCuti.append(JatahCuti(periode: ": 21/07/2018 - 21/07/2019", sisaCuti: ": 20 Hari", kadaluarsa: ": 10 Desember 2019"))
        
        tanggalCutiCollectionView.reloadData()
        jatahCutiCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.jatahCutiCollectionHeight.constant = self.jatahCutiCollectionView.contentSize.height
            self.tanggalCutiCollectionHeight.constant = self.tanggalCutiCollectionView.contentSize.height
            
            self.defaultViewCutiTahunanHeight = 109 + self.jatahCutiCollectionHeight.constant + self.tanggalCutiCollectionHeight.constant + 11 // 109 adalah nilai dasar dari total height - jatah dan tanggal collectionview + 11 for margin
        }
    }
    
    private func dropdownListener() {
        fieldJenisCuti.optionArray = ["-- Pilh --", "Cuti Sakit", "Cuti Tahunan", "Cuti Akademik", "Izin Meninggalkan Pekerjaan Sementara"]
        
        fieldJenisCuti.didSelect { (text, index, id) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if text == "Cuti Tahunan" {
                    self.showViewCutiTahunan()
                    self.hideViewCutiAkademik()
                    self.hideViewCutiSakit()
                    self.hideViewCutiSementara()
                } else if text == "Cuti Akademik" {
                    self.showViewCutiAkademik()
                    self.hideViewCutiTahunan()
                    self.hideViewCutiSakit()
                    self.hideViewCutiSementara()
                    self.hideViewSisaJatahCuti()
                } else if text == "Cuti Sakit" {
                    self.showViewCutiSakit()
                    self.hideViewCutiTahunan()
                    self.hideViewCutiAkademik()
                    self.hideViewCutiSementara()
                    self.hideViewSisaJatahCuti()
                } else if text == "Izin Meninggalkan Pekerjaan Sementara" {
                    self.showViewCutiSementara()
                    self.hideViewCutiTahunan()
                    self.hideViewCutiAkademik()
                    self.hideViewCutiSakit()
                    self.hideViewSisaJatahCuti()
                }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        
        labelUnit.layer.cornerRadius = 5
        
        viewJenisCuti.giveBorder(3, 1, "dedede")
        viewAlasan.giveBorder(3, 1, "dedede")
        viewDelegasi.giveBorder(3, 1, "dedede")
        viewAtasan.giveBorder(3, 1, "dedede")
        
        buttonSimpan.layer.cornerRadius = 5
        buttonSubmit.layer.cornerRadius = 5
        
        //outlet cuti tahunan
        viewCutiTahunanTanggal.giveBorder(3, 1, "dedede")
        viewCutiTahunanHeight.constant = 0
        viewCutiTahunan.isHidden = true
        
        //outlet cuti akademik
        viewTanggalCutiAkademik.giveBorder(3, 1, "dedede")
        viewCutiAkademikHeight.constant = 0
        viewCutiAkademik.isHidden = true
        
        //outlet cuti sakit
        viewRentangTanggalAwal.giveBorder(3, 1, "dedede")
        viewRentangTanggalAkhir.giveBorder(3, 1, "dedede")
        viewLampirkanFile.giveBorder(3, 1, "dedede")
        viewCutiSakitHeight.constant = 0
        viewCutiSakit.isHidden = true
        
        //outlet cuti sementara
        viewTanggalCutiSementara.giveBorder(3, 1, "dedede")
        viewWaktuAwalCutiSementara.giveBorder(3, 1, "dedede")
        viewWaktuAkhirCutiSementara.giveBorder(3, 1, "dedede")
        viewCutiSementaraHeight.constant = 0
        viewCutiSementara.isHidden = true
    }
    
    private func hideViewSisaJatahCuti() {
        if !viewSisaJatahCuti.isHidden {
            UIView.animate(withDuration: 0.2) {
                self.viewRootHeight.constant -= 48
                self.viewSisaJatahCutiHeight.constant = 0
                self.viewSisaJatahCuti.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
}

//function for view cuti sementara
extension PengajuanCutiController {
    private func showViewCutiSementara() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant += 176
            self.viewCutiSementaraHeight.constant = 176
            self.viewCutiSementara.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideViewCutiSementara() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant -= 176
            self.viewCutiSementaraHeight.constant = 0
            self.viewCutiSementara.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
}

//function for view cuti tahunan
extension PengajuanCutiController {
    private func showViewCutiTahunan() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewRootHeight.constant += self.defaultViewCutiTahunanHeight
            self.viewCutiTahunanHeight.constant = self.defaultViewCutiTahunanHeight
            self.viewCutiTahunan.isHidden = false
            self.viewSisaJatahCutiHeight.constant = 48
            self.viewSisaJatahCuti.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    private func getViewCutiTahunanHeight() {
        
    }
    
    private func hideViewCutiTahunan() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewRootHeight.constant -= self.defaultViewCutiTahunanHeight
            self.viewCutiTahunanHeight.constant = 0
            self.viewCutiTahunan.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
}

//function for view cuti sakit
extension PengajuanCutiController {
    private func showViewCutiSakit() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant += 208
            self.viewCutiSakitHeight.constant = 208
            self.viewCutiSakit.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideViewCutiSakit() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant -= 208
            self.viewCutiSakitHeight.constant = 0
            self.viewCutiSakit.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
}

//function for view cuti akademik
extension PengajuanCutiController {
    private func showViewCutiAkademik() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant += 66
            self.viewCutiAkademikHeight.constant = 66
            self.viewCutiAkademik.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideViewCutiAkademik() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant -= 66
            self.viewCutiAkademikHeight.constant = 0
            self.viewCutiAkademik.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
}

//click event
extension PengajuanCutiController {
    @IBAction func buttonCloseViewSisaJatahCutiClick(_ sender: Any) {
        hideViewSisaJatahCuti()
    }
    @IBAction func buttonSubmitClick(_ sender: Any) {
    }
    @IBAction func buttonSimpanClick(_ sender: Any) {
    }
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//collectionview
extension PengajuanCutiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == jatahCutiCollectionView {
            return listJatahCuti.count
        } else {
            return listTanggalCuti.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == jatahCutiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JatahCutiCell", for: indexPath) as! JatahCutiCell
            cell.data = listJatahCuti[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalCutiCell", for: indexPath) as! TanggalCutiCell
            cell.data = listTanggalCuti[indexPath.item].tanggal
            return cell
        }
    }
}
