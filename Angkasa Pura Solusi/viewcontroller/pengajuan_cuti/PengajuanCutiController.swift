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
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
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
    
    @IBOutlet weak var labelPegawai: CustomLabel!
    @IBOutlet weak var labelPegawaiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelNamaHeight: NSLayoutConstraint!
    @IBOutlet weak var labelUnitKerjaHeight: NSLayoutConstraint!
    @IBOutlet weak var labelJenisCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelJatahCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTanggalCutiTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTanggalTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTanggalAkademikHeight: NSLayoutConstraint!
    @IBOutlet weak var labelRentangTanggalSakitHeight: NSLayoutConstraint!
    @IBOutlet weak var labelLampirkanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTanggalSementaraHeight: NSLayoutConstraint!
    @IBOutlet weak var labelWaktuSementaraHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAlasanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelDelegasiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAtasanHeight: NSLayoutConstraint!
    
    var defaultViewCutiTahunanHeight: CGFloat = 0
    
    var listJatahCuti = [JatahCuti]()
    var listTanggalCuti = [TanggalCuti]()
    var isCalculateTanggalCutiHeight = false
    var isCalculateJatahCutiHeight = false
    var isSetJatahCutiHeight = false
    var isSetTanggalCutiHeight = false
    
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
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        labelUnit.layer.cornerRadius = 5
        
        viewJenisCuti.giveBorder(3, 1, "dedede")
        viewAlasan.giveBorder(3, 1, "dedede")
        viewDelegasi.giveBorder(3, 1, "dedede")
        viewAtasan.giveBorder(3, 1, "dedede")
        
        buttonSimpan.layer.cornerRadius = 5
        buttonSubmit.layer.cornerRadius = 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setHeightLabel()
        }
        
        viewRootHeight.constant -= viewCutiTahunanHeight.constant + viewCutiAkademikHeight.constant + viewCutiSakitHeight.constant + viewCutiSementaraHeight.constant
        
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
    
    private func setHeightLabel() {
        let height = labelPegawai.getHeight(width: labelPegawai.frame.width) + function.getGlobalHeight()
        labelNamaHeight.constant = height
        labelPegawaiHeight.constant = height
        labelUnitKerjaHeight.constant = height
        labelJenisCutiHeight.constant = height
        labelJatahCutiHeight.constant = height
        labelTanggalCutiTahunanHeight.constant = height
        labelTanggalTahunanHeight.constant = height
        labelTanggalAkademikHeight.constant = height
        labelRentangTanggalSakitHeight.constant = height
        labelLampirkanHeight.constant = height
        labelTanggalSementaraHeight.constant = height
        labelWaktuSementaraHeight.constant = height
        labelAlasanHeight.constant = height
        labelDelegasiHeight.constant = height
        labelAtasanHeight.constant = height
    }
    
    private func hideViewSisaJatahCuti() {
        if !viewSisaJatahCuti.isHidden {
            UIView.animate(withDuration: 0.2) {
                let sisaJatahCutiHeight = self.labelSisaJatahCuti.getHeight(width: self.labelSisaJatahCuti.frame.width) + self.labelKadaluarsaTop.getHeight(width: self.labelKadaluarsaTop.frame.width) + 8.9 + 12.8 + 4
                self.viewRootHeight.constant -= sisaJatahCutiHeight
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
            let sisaJatahCutiHeight = self.labelSisaJatahCuti.getHeight(width: self.labelSisaJatahCuti.frame.width) + self.labelKadaluarsaTop.getHeight(width: self.labelKadaluarsaTop.frame.width) + 8.9 + 12.8 + 4
            self.viewRootHeight.constant += self.defaultViewCutiTahunanHeight + sisaJatahCutiHeight
            self.viewCutiTahunanHeight.constant = self.defaultViewCutiTahunanHeight
            self.viewCutiTahunan.isHidden = false
            self.viewSisaJatahCutiHeight.constant = sisaJatahCutiHeight
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
    @IBAction func buttonRiwayatCutiClick(_ sender: Any) {
        navigationController?.pushViewController(RiwayatCutiController(), animated: true)
    }
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
            let jatahCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JatahCutiCell", for: indexPath) as! JatahCutiCell
            
            if !isCalculateJatahCutiHeight {
                self.isCalculateJatahCutiHeight = true
                DispatchQueue.main.async {
                    let jatahCutiHeight = jatahCutiCell.labelKadaluarsa.getHeight(width: jatahCutiCell.labelKadaluarsa.frame.width) + jatahCutiCell.labelSisaCuti.getHeight(width: jatahCutiCell.labelSisaCuti.frame.width) + jatahCutiCell.labelPeriode.getHeight(width: jatahCutiCell.labelPeriode.frame.width) + 9.8 + 6.2 + 6.2 + 12.5
                    let jatahCutiLayout = self.jatahCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    jatahCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: jatahCutiHeight)
                }
            }
            
            if indexPath.item == listJatahCuti.count - 1{
                if !self.isSetJatahCutiHeight {
                    self.isSetJatahCutiHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.jatahCutiCollectionHeight.constant = self.jatahCutiCollectionView.contentSize.height
                        self.defaultViewCutiTahunanHeight += 54.5 + self.jatahCutiCollectionHeight.constant
                    }
                }
            }
            
            jatahCutiCell.data = listJatahCuti[indexPath.item]
            return jatahCutiCell
        } else {
            let tanggalCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalCutiCell", for: indexPath) as! TanggalCutiCell
            
            if !isCalculateTanggalCutiHeight {
                self.isCalculateTanggalCutiHeight = true
                DispatchQueue.main.async {
                    let tanggalCutiHeight = ((UIScreen.main.bounds.width - 28) * 0.09) + 6.7
                    let tanggalCutiLayout = self.tanggalCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    tanggalCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: tanggalCutiHeight)
                }
            }
            
            if indexPath.item == listTanggalCuti.count - 1 {
                if !self.isSetTanggalCutiHeight {
                    self.isSetTanggalCutiHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.tanggalCutiCollectionHeight.constant = self.tanggalCutiCollectionView.contentSize.height
                        self.defaultViewCutiTahunanHeight += 54.5 + self.tanggalCutiCollectionHeight.constant
                    }
                }
            }
            
            tanggalCutiCell.data = listTanggalCuti[indexPath.item].tanggal
            return tanggalCutiCell
        }
    }
}
