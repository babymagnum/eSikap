//
//  DetailPengajuanRealisasiLembur.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import FittedSheets
import HSAttachmentPicker
import Toast_Swift
import MobileCoreServices

protocol DetailPengajuanRealisasiLemburProtocol {
    func updateData()
}

class DetailPengajuanRealisasiLembur: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelFilePendukung: NSLayoutConstraint!
    @IBOutlet weak var labelFilePendukung: CustomLabel!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var collectionTanggalLembur: UICollectionView!
    @IBOutlet weak var collectionTanggalLemburHeight: NSLayoutConstraint!
    @IBOutlet weak var viewKeteranganRealisasi: UIView!
    @IBOutlet weak var textviewKeteranganRealisasi: CustomTextView!
    @IBOutlet weak var viewFilePendukung: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    private var datetimes_start = [String]()
    private var datetimes_start_show = [String]()
    private var datetimes_end = [String]()
    private var datetimes_end_show = [String]()
    private var datetimes_start_real = [String]()
    private var datetimes_end_real = [String]()
    private var isPickTanggalMulai = false
    private var isPickWaktuMulai = false
    private var selectedIndex = 0
    //private let picker = HSAttachmentPicker()
    private var fileType = ""
    private var pickedData: Data?
    private var attachment_old = ""
    
    var overtimeId: String?
    var delegate: DetailPengajuanRealisasiLemburProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
        
        getEditOvertime()
        
        getProfile()
    }
    
    private func getProfile() {
        informationNetworking.getProfile { (error, itemProfile, isExpired) in
            DispatchQueue.main.async {
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _ = error {
                    self.getProfile()
                    return
                }
                
                guard let _itemProfile = itemProfile else { return }
                
                self.setProfileView(data: _itemProfile)
            }
        }
    }
    
    private func setProfileView(data: ItemProfile) {
        labelNama.text = ": \(data.emp_name ?? "")"
        labelUnitKerja.text = ": \(data.unit ?? "")"
        imageProfile.loadUrl(data.img ?? "")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getEditOvertime() {
        guard let _overtimeId = overtimeId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getEditDetailOvertimeRealizationById(overtimeId: _overtimeId) { (error, editDetailOvertime, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getEditOvertime()
                    }
                }
                
                guard let _data = editDetailOvertime?.data else { return }
                            
                self.labelKeterangan.text = ": \(_data.reason ?? "")"
                self.labelNumber.text = _data.number
                self.labelDate.text = "Diajukan pada \(_data.date ?? "")"
                self.datetimes_start = _data.datetimes_start
                self.datetimes_start_show = _data.datetimes_start_show
                self.datetimes_end = _data.datetimes_end
                self.datetimes_end_show = _data.datetimes_end_show
                self.datetimes_start_real = _data.datetimes_start_real
                self.datetimes_end_real = _data.datetimes_end_real
                self.attachment_old = _data.attachment_name_old ?? ""
                
                self.collectionTanggalLembur.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.collectionTanggalLemburHeight.constant = self.collectionTanggalLembur.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.scrollView.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func initEvent() {
        viewFilePendukung.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewFilePendukungClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionTanggalLembur.collectionViewLayout.invalidateLayout()
    }

    private func initView() {
        //picker.delegate = self
        constraintViewRoot.constant += UIApplication.shared.statusBarFrame.height
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        labelFilePendukung.text = ""
        scrollView.resizeScrollViewContentSize()
        self.view.layoutIfNeeded()
        
        viewFilePendukung.giveBorder(3, 1, "dedede")
        viewKeteranganRealisasi.giveBorder(3, 1, "dedede")
        buttonSubmit.giveBorder(5, 0, "fff")
        
        scrollView.alpha = 0
        imageProfile.clipsToBounds = true
        imageProfile.layer.cornerRadius = (UIScreen.main.bounds.width * 0.16) / 2
        
        collectionTanggalLembur.register(UINib(nibName: "TanggalLemburRealisasiCell", bundle: nil), forCellWithReuseIdentifier: "TanggalLemburRealisasiCell")
        collectionTanggalLembur.dataSource = self
        collectionTanggalLembur.delegate = self
        let collectionLayout = collectionTanggalLembur.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 324)
    }
}

extension DetailPengajuanRealisasiLembur: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datetimes_start.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalLemburRealisasiCell", for: indexPath) as! TanggalLemburRealisasiCell
        let tanggalWaktuMulai = datetimes_start_real[indexPath.item].components(separatedBy: " ")
        let tanggalWaktuSelesai = datetimes_end_real[indexPath.item].components(separatedBy: " ")
        cell.labelMulaiPermintaan.text = "\(datetimes_start_show[indexPath.item].dropLast(3))"
        cell.labelSelesaiPermintaan.text = "\(datetimes_end_show[indexPath.item].dropLast(3))"
        cell.fieldTanggalMulai.text = function.dateStringTo(date: tanggalWaktuMulai[0], original: "yyyy-MM-dd", toFormat: "dd-MM-yyyy")
        cell.fieldWaktuMulai.text = "\(tanggalWaktuMulai[1].prefix(5))"
        cell.fieldTanggalSelesai.text = function.dateStringTo(date: tanggalWaktuSelesai[0], original: "yyyy-MM-dd", toFormat: "dd-MM-yyyy")
        cell.fieldWaktuSelesai.text = "\(tanggalWaktuSelesai[1].prefix(5))"
        cell.viewTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTanggalMulaiClick(sender:))))
        cell.viewWaktuMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewWaktuMulaiClick(sender:))))
        cell.viewTanggalSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTanggalSelesaiClick(sender:))))
        cell.viewWaktuSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewWaktuSelesaiClick(sender:))))
        return cell
    }
}

//extension DetailPengajuanRealisasiLembur: HSAttachmentPickerDelegate {
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
//        DispatchQueue.main.async {
//            self.present(controller, animated: true, completion: completion)
//        }
//    }
//
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) { }
//
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data, filename: String, image: UIImage?) {
//
//        if filename.contains(".") {
//            fileType = filename.components(separatedBy: ".")[1]
//        }
//
//        if let image = image {
//            pickedData = image.pngData()
//            labelFilePendukung.text = filename
//            return
//        }
//
//        pickedData = data
//        labelFilePendukung.text = filename
//
//        if filename.contains(regex: "(jpg|png|jpeg)") {
//            pickedData = UIImage(data: data)?.pngData()
//        }
//
//        UIView.animate(withDuration: 0.2) {
//            self.scrollView.resizeScrollViewContentSize()
//            self.view.layoutIfNeeded()
//        }
//    }
//}

extension DetailPengajuanRealisasiLembur: BottomSheetDatePickerProtocol, UIDocumentPickerDelegate {
    
    private func addOvertimeRealization() {
        guard let _overtimeId = overtimeId else { return }
        
        var body: [String: String] = [
            "reason": textviewKeteranganRealisasi.text.trim(),
            "overtime_id": _overtimeId,
            "attachment_old": attachment_old
        ]
        
        for (index, item) in datetimes_start_show.enumerated() {
            body.updateValue(item, forKey: "datetimes_start[\(index)]")
        }
        
        for (index, item) in datetimes_end_show.enumerated() {
            body.updateValue(item, forKey: "datetimes_end[\(index)]")
        }
        
        for (index, item) in datetimes_start_real.enumerated() {
            body.updateValue(item, forKey: "datetimes_start_real[\(index)]")
        }
        
        for (index, item) in datetimes_end_real.enumerated() {
            body.updateValue(item, forKey: "datetimes_end_real[\(index)]")
        }
        
        SVProgressHUD.show(withStatus: "Harap tunggu...")
        
        informationNetworking.addOvertimeRealization(body: body, imageData: pickedData, fileName: labelFilePendukung.text ?? "", fileType: fileType) { (error, success, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    if _error.contains(regex: "(</ul>|</li>|</span>)") {
                        let vc = DialogPengajuanCutiController()
                        vc.exception = error
                        self.showCustomDialog(vc)
                        return
                    }
                }
                
                self.view.makeToast("Berhasil melakukan pengajuan realisasi lembur.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let _delegate = self.delegate else { return }
                    
                    _delegate.updateData()
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func pickDate(formatedDate: String) {
        if isPickTanggalMulai {
            let tanggalWaktuMulai = datetimes_start_real[selectedIndex].components(separatedBy: " ")
            let originalTanggal = function.dateStringTo(date: formatedDate, original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
            datetimes_start_real[selectedIndex] = "\(originalTanggal) \(tanggalWaktuMulai[1])"
            collectionTanggalLembur.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        } else {
            let tanggalWaktuSelesai = datetimes_end_real[selectedIndex].components(separatedBy: " ")
            let originalTanggal = function.dateStringTo(date: formatedDate, original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
            datetimes_end_real[selectedIndex] = "\(originalTanggal) \(tanggalWaktuSelesai[1])"
            collectionTanggalLembur.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        }
    }
    
    func pickTime(pickedTime: String) {
        if isPickWaktuMulai {
            let tanggalWaktuMulai = datetimes_start_real[selectedIndex].components(separatedBy: " ")
            datetimes_start_real[selectedIndex] = "\(tanggalWaktuMulai[0]) \(pickedTime):00"
            collectionTanggalLembur.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        } else {
            let tanggalWaktuSelesai = datetimes_end_real[selectedIndex].components(separatedBy: " ")
            datetimes_end_real[selectedIndex] = "\(tanggalWaktuSelesai[0]) \(pickedTime):00"
            collectionTanggalLembur.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        }
    }
    
    private func openDateTimePicker(_ picker: PickerTypeEnum) {
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = false
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    @objc func collectionViewTanggalMulaiClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionTanggalLembur.indexPathForItem(at: sender.location(in: collectionTanggalLembur)) else { return }
        
        isPickTanggalMulai = true
        selectedIndex = indexpath.item
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func collectionViewTanggalSelesaiClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionTanggalLembur.indexPathForItem(at: sender.location(in: collectionTanggalLembur)) else { return }
        
        isPickTanggalMulai = false
        selectedIndex = indexpath.item
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func collectionViewWaktuMulaiClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionTanggalLembur.indexPathForItem(at: sender.location(in: collectionTanggalLembur)) else { return }
        
        isPickWaktuMulai = true
        selectedIndex = indexpath.item
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func collectionViewWaktuSelesaiClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionTanggalLembur.indexPathForItem(at: sender.location(in: collectionTanggalLembur)) else { return }
        
        isPickWaktuMulai = false
        selectedIndex = indexpath.item
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        
        do {
            let data = try? Data(contentsOf: myURL) // Getting file data here
            guard let _data = data else { return }
            pickedData = _data
            let filename = "\(myURL)".components(separatedBy: "/").last
            labelFilePendukung.text = "\(filename ?? "")"
            let fileType = "\(filename ?? " . ")".components(separatedBy: ".")[1]
            if fileType.lowercased().contains(regex: "(jpg|png|jpeg)") {
                let image = UIImage.init(data: _data)
                guard let _image = image else { return }
                pickedData = _image.jpegData(compressionQuality: 0.1) ?? Data()
            }
        } catch {
            // something
        }
    }
    
    @objc func viewFilePendukungClick() {
        //self.picker.showAttachmentMenu()
        let allowedFiles = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
        let importMenu = UIDocumentPickerViewController(documentTypes: allowedFiles, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func buttonSubmitClick(_ sender: Any) {
        addOvertimeRealization()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
