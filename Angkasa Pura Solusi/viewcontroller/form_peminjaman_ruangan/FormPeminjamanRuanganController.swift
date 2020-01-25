//
//  FormPeminjamanRuanganController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 23/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import FittedSheets
import Toast_Swift

struct LampiranModel {
    var title: String
    var file: String
    var data: Data
}

protocol FormPeminjamanRuanganProtocol {
    func updateData()
}

class FormPeminjamanRuanganController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var viewJudul: UIView!
    @IBOutlet weak var fieldJudul: CustomTextField!
    @IBOutlet weak var viewKeterangan: UIView!
    @IBOutlet weak var textviewKeterangan: CustomTextView!
    @IBOutlet weak var viewRuang: UIView!
    @IBOutlet weak var fieldRuang: CustomDropDownField!
    @IBOutlet weak var viewMeetingInternal: UIView!
    @IBOutlet weak var imageMeetingInternal: UIImageView!
    @IBOutlet weak var viewMeetingExternal: UIView!
    @IBOutlet weak var imageMeetingExternal: UIImageView!
    @IBOutlet weak var viewTanggalMulai: UIView!
    @IBOutlet weak var viewTanggalSelesai: UIView!
    @IBOutlet weak var fieldTanggalMulai: CustomTextField!
    @IBOutlet weak var fieldTanggalSelesai: CustomTextField!
    @IBOutlet weak var viewWaktuMulai: UIView!
    @IBOutlet weak var fieldWaktuMulai: CustomTextField!
    @IBOutlet weak var viewWaktuSelesai: UIView!
    @IBOutlet weak var fieldWaktuSelesai: CustomTextField!
    @IBOutlet weak var viewPartisipan: UIView!
    @IBOutlet weak var fieldPartisipan: CustomDropDownField!
    @IBOutlet weak var collectionPartisipan: UICollectionView!
    @IBOutlet weak var collectionPartisipanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewJumlahOrang: UIView!
    @IBOutlet weak var fieldJumlahOrang: CustomTextField!
    @IBOutlet weak var viewKonsumsiYa: UIView!
    @IBOutlet weak var imageKonsumsiYa: UIImageView!
    @IBOutlet weak var viewKonsumsiTidak: UIView!
    @IBOutlet weak var imageKonsumsiTidak: UIImageView!
    @IBOutlet weak var imageTambahLampiran: UIImageView!
    @IBOutlet weak var collectionLampiran: UICollectionView!
    @IBOutlet weak var collectionLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonSimpan: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var listParticipant = [PenumpangItem]()
    private var listLampiran = [LampiranModel]()
    private var listRooms = [RoomsData]()
    private var typeMeeting = "1"
    private var selectedRooms = ""
    private var consumption = "1"
    private var isPickTanggalMulai = true
    private var isPickWaktuMulai = true
    
    var delegate: FormPeminjamanRuanganProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getRooms()
        
        initEvent()
    }
    
    private func checkInput() {
        if fieldJudul.text?.trim() == "" {
            self.view.makeToast("Judul tidak boleh kosong.")
        } else if textviewKeterangan.text.trim() == "" {
            self.view.makeToast("Keterangan tidak boleh kosong.")
        } else if selectedRooms == "" {
            self.view.makeToast("Anda belum memilih type ruangan.")
        } else if fieldTanggalMulai.text == "" {
            self.view.makeToast("Anda belum memilih tanggal mulai.")
        } else if fieldTanggalSelesai.text == "" {
            self.view.makeToast("Anda belum memilih tanggal selesai.")
        } else if fieldWaktuMulai.text == "" {
            self.view.makeToast("Anda belum memilih waktu mulai.")
        } else if fieldWaktuSelesai.text == "" {
            self.view.makeToast("Anda belum memilih waktu selesai.")
        } else if listParticipant.count == 0 {
            self.view.makeToast("Anda belum memilih partisipan.")
        } else if fieldJumlahOrang.text?.trim() == "" {
            self.view.makeToast("Anda belum menentukan jumlah orang.")
        } else if Int(fieldJumlahOrang.text?.trim() ?? "0") != listParticipant.count {
            self.view.makeToast("Isian jumlah orang tidak sama dengan partisipan yang dipilih.")
        } else {
            var body: [String: String] = [
                "title": fieldJudul.text?.trim() ?? "",
                "description": textviewKeterangan.text.trim(),
                "room_id": selectedRooms,
                "type": typeMeeting,
                "date_start": function.dateStringTo(date: fieldTanggalMulai.text ?? "", original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd"),
                "time_start": "\(fieldWaktuMulai.text ?? ""):00",
                "date_end": function.dateStringTo(date: fieldTanggalSelesai.text ?? "", original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd"),
                "time_end": "\(fieldWaktuSelesai.text ?? ""):00",
                "total_participant": fieldJumlahOrang.text?.trim() ?? "0",
                "consumption": consumption
            ]
            
            for (index, item) in listParticipant.enumerated() {
                body.updateValue(item.emp_id, forKey: "participant[\(index)]")
            }
            
            if listLampiran.count > 0 {
                for (index, item) in listLampiran.enumerated() {
                    body.updateValue(item.title, forKey: "attachment_title[\(index)]")
                }
            }

            addRequestRoom(body: body)
        }
    }
    
    private func addRequestRoom(body: [String: String]) {
        SVProgressHUD.show()
        
        informationNetworking.addRequestRooms(body: body, listFiles: listLampiran) { (error, success, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                if _error.contains("</ul>") || _error.contains("</li>") || _error.contains("</span>") {
                    let vc = DialogPengajuanCutiController()
                    vc.exception = _error
                    self.showCustomDialog(vc)
                } else {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Peminjaman Ruangan", _error, "Cancel")
                }
                return
            }
            
            guard let _ = success else { return }
            
            guard let _delegate = self.delegate else { return }
            
            _delegate.updateData()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func initEvent() {
        viewTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalMulaiClick)))
        viewTanggalSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSelesaiClick)))
        viewWaktuMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuMulaiClick)))
        viewWaktuSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuSelesaiClick)))
        viewPartisipan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPartisipanClick)))
        imageTambahLampiran.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTambahLampiranClick)))
        viewMeetingInternal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMeetingInternalClick)))
        viewMeetingExternal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMeetingExternalClick)))
        viewKonsumsiYa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKonsumsiYaClick)))
        viewKonsumsiTidak.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKonsumsiTidakClick)))
    }
    
    private func getRooms() {
        SVProgressHUD.show()
        
        informationNetworking.getRooms { (error, rooms, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getRooms()
                return
            }
            
            guard let _rooms = rooms else { return }
            
            self.listRooms = _rooms.data
            
            _rooms.data.forEach { (item) in
                self.fieldRuang.optionArray.append(item.name ?? "")
            }
            
            self.fieldRuang.didSelect { (text, index, id) in
                print("selected id \(self.listRooms[index].id ?? "0")")
                self.fieldRuang.text = text
                self.selectedRooms = self.listRooms[index].id ?? "0"
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionPartisipan.collectionViewLayout.invalidateLayout()
        collectionLampiran.collectionViewLayout.invalidateLayout()
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        
        viewJudul.giveBorder(3, 1, "dedede")
        viewKeterangan.giveBorder(3, 1, "dedede")
        viewRuang.giveBorder(3, 1, "dedede")
        viewTanggalMulai.giveBorder(3, 1, "dedede")
        viewTanggalSelesai.giveBorder(3, 1, "dedede")
        viewWaktuMulai.giveBorder(3, 1, "dedede")
        viewWaktuSelesai.giveBorder(3, 1, "dedede")
        viewPartisipan.giveBorder(3, 1, "dedede")
        viewJumlahOrang.giveBorder(3, 1, "dedede")
        buttonSimpan.giveBorder(5, 0, "dedede")
        
        collectionPartisipanHeight.constant = 0
        collectionLampiranHeight.constant = 0
        scrollView.resizeScrollViewContentSize()
        self.view.layoutIfNeeded()
        
        let collectionPartisipanLayout = collectionPartisipan.collectionViewLayout as! UICollectionViewFlowLayout
        collectionPartisipanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 45)
        
        collectionPartisipan.register(UINib(nibName: "PenumpangCell", bundle: nil), forCellWithReuseIdentifier: "PenumpangCell")
        collectionPartisipan.delegate = self
        collectionPartisipan.dataSource = self
        
        let collectionLampiranLayout = collectionLampiran.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLampiranLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 89)
        
        collectionLampiran.register(UINib(nibName: "LampiranPeminjamanRuangCell", bundle: nil), forCellWithReuseIdentifier: "LampiranPeminjamanRuangCell")
        collectionLampiran.dataSource = self
        collectionLampiran.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension FormPeminjamanRuanganController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPartisipan {
            return listParticipant.count
        } else {
            return listLampiran.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPartisipan {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PenumpangCell", for: indexPath) as! PenumpangCell
            
            cell.data = listParticipant[indexPath.item]
            cell.buttonDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonDeleteClick(sender:))))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LampiranPeminjamanRuangCell", for: indexPath) as! LampiranPeminjamanRuangCell
            cell.data = listLampiran[indexPath.item]
            cell.imageDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionImageDeleteClick(sender:))))
            return cell
        }
    }
}

extension FormPeminjamanRuanganController: BottomSheetDatePickerProtocol, SearchDelegasiOrAtasanProtocol, DialogTambahLampiranProtocol {
    
    func tambahClick(title: String, file: String, data: Data) {
        if listLampiran.contains(where: {($0.file == file)}){
            self.view.makeToast("Anda sudah memilih file \(file)")
            return
        }
        
        listLampiran.append(LampiranModel(title: title, file: file, data: data))
        collectionLampiran.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionLampiranHeight.constant = self.collectionLampiran.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func namePicked(itemEmp: ItemEmp, type: String) {
        if listParticipant.contains(where: {($0.emp_id == itemEmp.emp_id)}){
            self.view.makeToast("Anda sudah memilih \(itemEmp.emp_name ?? "")")
            return
        }
        
        listParticipant.append(PenumpangItem(emp_id: itemEmp.emp_id ?? "", emp_name: itemEmp.emp_name ?? ""))
        collectionPartisipan.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionPartisipanHeight.constant = self.collectionPartisipan.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func pickDate(formatedDate: String) {
        if isPickTanggalMulai {
            fieldTanggalMulai.text = formatedDate
        } else {
            fieldTanggalSelesai.text = formatedDate
        }
    }
    
    func pickTime(pickedTime: String) {
        if isPickWaktuMulai {
            fieldWaktuMulai.text = pickedTime
        } else {
            fieldWaktuSelesai.text = pickedTime
        }
    }
    
    private func openDateTimePicker(_ picker: PickerTypeEnum) {
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = false
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    @objc func collectionImageDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionLampiran.indexPathForItem(at: sender.location(in: collectionLampiran)) else { return }
        
        listLampiran.remove(at: indexpath.item)
        collectionLampiran.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionLampiranHeight.constant = self.collectionLampiran.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func buttonDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPartisipan.indexPathForItem(at: sender.location(in: collectionPartisipan)) else { return }
        
        listParticipant.remove(at: indexpath.item)
        collectionPartisipan.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionPartisipanHeight.constant = self.collectionPartisipan.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func viewTanggalMulaiClick() {
        isPickTanggalMulai = true
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func viewMeetingInternalClick() {
        typeMeeting = "1"
        imageMeetingInternal.image = UIImage(named: "radio_on_light")
        imageMeetingExternal.image = UIImage(named: "radio_off_light")
    }
    
    @objc func viewMeetingExternalClick() {
        typeMeeting = "2"
        imageMeetingExternal.image = UIImage(named: "radio_on_light")
        imageMeetingInternal.image = UIImage(named: "radio_off_light")
    }
    
    @objc func viewKonsumsiYaClick() {
        consumption = "1"
        imageKonsumsiYa.image = UIImage(named: "radio_on_light")
        imageKonsumsiTidak.image = UIImage(named: "radio_off_light")
    }
    
    @objc func viewKonsumsiTidakClick() {
        consumption = "0"
        imageKonsumsiTidak.image = UIImage(named: "radio_on_light")
        imageKonsumsiYa.image = UIImage(named: "radio_off_light")
    }
    
    @objc func viewTanggalSelesaiClick() {
        isPickTanggalMulai = false
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func viewWaktuMulaiClick() {
        isPickWaktuMulai = true
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewWaktuSelesaiClick() {
        isPickWaktuMulai = false
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewPartisipanClick() {
        let vc = SearchDelegasiOrAtasanController()
        vc.type = "Penumpang"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imageTambahLampiranClick() {
        let vc = DialogTambahLampiran()
        vc.delegate = self
        self.showCustomDialog(vc)
    }
    
    @IBAction func buttonSimpanClick(_ sender: Any) { checkInput() }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        self.navigationController?.pushViewController(HistoryPeminjamanRuangan(), animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
