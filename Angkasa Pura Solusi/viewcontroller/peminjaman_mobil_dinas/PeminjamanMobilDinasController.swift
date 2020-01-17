//
//  PeminjamanMobilDinasController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 13/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import iOSDropDown
import Toast_Swift
import SVProgressHUD

struct PenumpangItem {
    var emp_id: String
    var emp_name: String
}

class PeminjamanMobilDinasController: BaseViewController, UICollectionViewDelegate {

    // widget
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelPegawai: CustomLabel!
    @IBOutlet weak var viewTanggalPermintaan: UIView!
    @IBOutlet weak var fieldTanggalPermintaan: CustomTextField!
    @IBOutlet weak var viewWaktuMulai: UIView!
    @IBOutlet weak var fieldWaktuMulai: CustomTextField!
    @IBOutlet weak var viewWaktuSelesai: UIView!
    @IBOutlet weak var fieldWaktuSelesai: CustomTextField!
    @IBOutlet weak var viewAreaTujuan: UIView!
    @IBOutlet weak var fieldAreaTujuan: CustomDropDownField!
    @IBOutlet weak var viewAlamat: UIView!
    @IBOutlet weak var textViewAlamat: CustomTextView!
    @IBOutlet weak var viewPropinsi: UIView!
    @IBOutlet weak var fieldPropinsi: CustomDropDownField!
    @IBOutlet weak var viewKota: UIView!
    @IBOutlet weak var fieldKota: CustomDropDownField!
    @IBOutlet weak var viewTujuan: UIView!
    @IBOutlet weak var textViewTujuan: CustomTextView!
    @IBOutlet weak var viewKategori: UIView!
    @IBOutlet weak var fieldKategori: CustomDropDownField!
    @IBOutlet weak var viewJumlahPenumpang: UIView!
    @IBOutlet weak var fieldJumlahPenumpang: CustomTextField!
    @IBOutlet weak var viewNamaPenumpang: UIView!
    @IBOutlet weak var fieldNamaPenumpang: CustomDropDownField!
    @IBOutlet weak var collectionNamaPenumpang: UICollectionView!
    @IBOutlet weak var viewUndangan: UIView!
    @IBOutlet weak var fieldUndangan: CustomTextField!
    @IBOutlet weak var buttonSimpan: CustomButton!
    @IBOutlet weak var constraintRootTop: NSLayoutConstraint!
    @IBOutlet weak var collectionPenumpangHeight: NSLayoutConstraint!
    
    // variable
    private var listPenumpang = [PenumpangItem]()
    private var isPickWaktuMulai = false
    private var selectedAreaTujuan = ""
    private var selectedCategory = ""
    private var selectedPropinsi = ""
    private var selectedKota = ""
    private var isCalculateTanggalCutiHeight = false
    private var isSelectPropinsi = false
    private var listAreaTujuan = [DestinationDataItem]()
    private var listKategori = [CategoryCarRequestDataItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initEvent()
        
        setProfileView()
        
        getDestination()
        
        getCategory()
    }
    
    private func getCategory() {
        informationNetworking.getCategoryCarRequest { (error, categoryCar, isExpired) in
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                print("error get category \(_error)")
                return
            }
            
            guard let _category = categoryCar else { return }
            
            self.listKategori = _category.data
            
            _category.data.forEach { (item) in
                self.fieldKategori.optionArray.append(item.name)
            }
        }
    }
    
    private func getDestination() {
        informationNetworking.getDestination { (error, destination, isExpired) in
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                print("error get destination \(_error)")
                return
            }
            
            guard let _destination = destination else { return }
            
            self.listAreaTujuan = _destination.data
            
            _destination.data.forEach { (item) in
                self.fieldAreaTujuan.optionArray.append(item.name)
            }
        }
    }
    
    private func openDateTimePicker(_ picker: PickerTypeEnum) {
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = false
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    private func setProfileView() {
        labelPegawai.text = preference.getString(key: staticLet.EMP_NAME)
    }
    
    private func initEvent() {
        viewNamaPenumpang.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewNamaPenumpangClick)))
        
        viewWaktuMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuMulaiClick)))
        
        viewWaktuSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuSelesaiClick)))
        
        viewTanggalPermintaan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalPermintaanClick)))
        
        fieldAreaTujuan.didSelect { (text, index, id) in
            self.selectedAreaTujuan = self.listAreaTujuan[index].id
        }
        
        fieldKategori.didSelect { (text, index, id) in
            self.selectedCategory = self.listKategori[index].id
        }
        
        viewPropinsi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPropinsiClick)))
        
        viewKota.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKotaClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionNamaPenumpang.collectionViewLayout.invalidateLayout()
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        checkTopMargin(viewRootTopMargin: constraintRootTop)
        
        viewTanggalPermintaan.giveBorder(3, 1, "dedede")
        viewWaktuMulai.giveBorder(3, 1, "dedede")
        viewWaktuSelesai.giveBorder(3, 1, "dedede")
        viewAreaTujuan.giveBorder(3, 1, "dedede")
        viewAlamat.giveBorder(3, 1, "dedede")
        viewPropinsi.giveBorder(3, 1, "dedede")
        viewKota.giveBorder(3, 1, "dedede")
        viewTujuan.giveBorder(3, 1, "dedede")
        viewKategori.giveBorder(3, 1, "dedede")
        viewJumlahPenumpang.giveBorder(3, 1, "dedede")
        viewNamaPenumpang.giveBorder(3, 1, "dedede")
        viewUndangan.giveBorder(3, 1, "dedede")
        buttonSimpan.giveBorder(5, 0, "dedede")
        
        collectionNamaPenumpang.register(UINib(nibName: "PenumpangCell", bundle: nil), forCellWithReuseIdentifier: "PenumpangCell")
        collectionNamaPenumpang.delegate = self
        collectionNamaPenumpang.dataSource = self
        collectionPenumpangHeight.constant = 0
    }

}

// gesture recognizer
extension PeminjamanMobilDinasController: SearchDelegasiOrAtasanProtocol, BottomSheetDatePickerProtocol, PropinsiKotaProtocol {
    func propinsiKotaPicked(propinsiCity: PropinsiCityDataItem) {
        if isSelectPropinsi {
            fieldPropinsi.text = propinsiCity.name
            selectedPropinsi = propinsiCity.id
        } else {
            fieldKota.text = propinsiCity.name
            selectedKota = propinsiCity.id
        }
    }
    
    func pickDate(formatedDate: String) {
        fieldTanggalPermintaan.text = formatedDate
        print("\(fieldTanggalPermintaan.text ?? "")")
    }
    
    func pickTime(pickedTime: String) {
        if isPickWaktuMulai {
            fieldWaktuMulai.text = pickedTime
        } else {
            fieldWaktuSelesai.text = pickedTime
        }
    }
    
    private func allowAddRequest() -> Bool {
        if fieldTanggalPermintaan.trim() == "" {
            self.view.makeToast("Tanggal permintaan harus diisi.")
            return false
        } else if fieldWaktuMulai.trim() == "" {
            self.view.makeToast("Waktu mulai harus diisi.")
            return false
        } else if fieldWaktuSelesai.trim() == "" {
            self.view.makeToast("Waktu selesai harus diisi.")
            return false
        } else if selectedAreaTujuan == "" {
            self.view.makeToast("Area tujuan harus diisi.")
            return false
        } else if textViewAlamat.text.trim() == "" {
            self.view.makeToast("Alamat harus diisi.")
            return false
        } else if selectedPropinsi == "" {
            self.view.makeToast("Propinsi harus diisi.")
            return false
        } else if selectedKota == "" {
            self.view.makeToast("Kota harus diisi.")
            return false
        } else if textViewTujuan.text.trim() == "" {
            self.view.makeToast("Tujuan harus diisi.")
            return false
        } else if selectedCategory == "" {
            self.view.makeToast("Kategori harus diisi.")
            return false
        } else if fieldJumlahPenumpang.trim() == "" {
            self.view.makeToast("Jumlah penumpang harus diisi.")
            return false
        } else if listPenumpang.count == 0 {
            self.view.makeToast("Nama penumpang harus diisi.")
            return false
        } else if listPenumpang.count != Int(fieldJumlahPenumpang.text ?? "0") ?? 0 {
            self.view.makeToast("Jumlah penumpang tidak sesuai dengan penumpang yang di pilih.")
            return false
        } else if fieldUndangan.trim() == "" {
            self.view.makeToast("Undangan harus diisi.")
            return false
        } else {
            return true
        }
    }
    
    private func addRequest() {
        if !allowAddRequest() {
            return
        }
        
        var body: [String: String] = [
            "request_date": function.dateStringTo(date: fieldTanggalPermintaan.text ?? "", original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd"),
            "time_start": "\(fieldWaktuMulai.text ?? ""):00",
            "time_end": "\(fieldWaktuSelesai.text ?? ""):00",
            "destination_area": "\(selectedAreaTujuan)",
            "address": textViewAlamat.text,
            "state": selectedPropinsi,
            "city": selectedKota,
            "purpose": textViewTujuan.text,
            "category": "\(selectedCategory)",
            "invitation": fieldUndangan.text ?? "",
            "passenger_qty": fieldJumlahPenumpang.text ?? ""
        ]
        
        for index in 0...listPenumpang.count - 1 {
            body.updateValue(listPenumpang[index].emp_id, forKey: "passenger[\(index)]")
        }
        
        print("car request body \(body)")
        
        SVProgressHUD.show()
        
        informationNetworking.addRequestCar(body: body) { (error, success, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Melakukan Peminjaman", _error, "Ulangi") {
                    self.addRequest()
                }
                return
            }
            
            self.function.showUnderstandDialog(self, "Sukses Melakukan Peminjaman", "", "Lanjut") {
                // go to history
            }
        }
    }
    
    func namePicked(itemEmp: ItemEmp, type: String) {
        if listPenumpang.contains(where: {($0.emp_id == itemEmp.emp_id)}){
            self.view.makeToast("Anda sudah memilih \(itemEmp.emp_name ?? "")")
            return
        }
        
        listPenumpang.append(PenumpangItem(emp_id: itemEmp.emp_id ?? "", emp_name: itemEmp.emp_name ?? ""))
        collectionNamaPenumpang.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionPenumpangHeight.constant = self.collectionNamaPenumpang.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSimpanClick(_ sender: Any) { addRequest() }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        self.navigationController?.pushViewController(HistoryPeminjamanMobilDinas(), animated: true)
    }
    
    @objc func viewKotaClick() {
        if selectedPropinsi == "" {
            self.view.makeToast("Pilih propinsi terlebih dahulu.")
            return
        }
        
        isSelectPropinsi = false
        goToPropinsiKota(titleString: "Kota / Kabupaten")
    }
    
    @objc func viewPropinsiClick() {
        isSelectPropinsi = true
        goToPropinsiKota(titleString: "Propinsi / Negara Bagian")
    }
    
    private func goToPropinsiKota(titleString: String) {
        let vc = PropinsiKotaController()
        vc.delegate = self
        vc.isSearchPropinsi = isSelectPropinsi
        vc.titleString = titleString
        vc.propinsiId = selectedPropinsi
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewWaktuMulaiClick() {
        isPickWaktuMulai = true
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewWaktuSelesaiClick() {
        isPickWaktuMulai = false
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewTanggalPermintaanClick() { openDateTimePicker(PickerTypeEnum.date) }
    
    @objc func buttonDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionNamaPenumpang.indexPathForItem(at: sender.location(in: collectionNamaPenumpang)) else { return }
        
        listPenumpang.remove(at: indexpath.item)
        collectionNamaPenumpang.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionPenumpangHeight.constant = self.collectionNamaPenumpang.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func viewNamaPenumpangClick() {
        let vc = SearchDelegasiOrAtasanController()
        vc.type = "Penumpang"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PeminjamanMobilDinasController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPenumpang.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PenumpangCell", for: indexPath) as! PenumpangCell
        
        if !isCalculateTanggalCutiHeight {
            self.isCalculateTanggalCutiHeight = true
            DispatchQueue.main.async {
                let tanggalCutiLayout = self.collectionNamaPenumpang.collectionViewLayout as! UICollectionViewFlowLayout
                tanggalCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 45)
            }
        }
        
        cell.data = listPenumpang[indexPath.item]
        cell.buttonDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonDeleteClick(sender:))))
        return cell
        
    }
}
