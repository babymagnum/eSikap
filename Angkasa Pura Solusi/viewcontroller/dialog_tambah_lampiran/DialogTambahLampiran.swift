//
//  DialogTambahLampiran.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 24/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift
import HSAttachmentPicker

protocol DialogTambahLampiranProtocol {
    func tambahClick(title: String, file: String, data: Data)
}

class DialogTambahLampiran: UIViewController {

    @IBOutlet weak var imageUnggahFile: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewJudul: UIView!
    @IBOutlet weak var fieldJudul: CustomTextField!
    @IBOutlet weak var viewUnggahFile: UIView!
    @IBOutlet weak var labelUnggahFile: UILabel!
    @IBOutlet weak var buttonTambah: CustomButton!
    
    var delegate: DialogTambahLampiranProtocol?
    
    private let picker = HSAttachmentPicker()
    private var pickedData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        viewUnggahFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUnggahFileClick)))
    }

    private func initView() {
        fieldJudul.textColor = UIColor(hexString: "bababa")
        picker.delegate = self
        viewContainer.layer.cornerRadius = 5
        buttonTambah.giveBorder(5, 0, "fff")
        viewJudul.giveBorder(3, 1, "dedede")
        viewUnggahFile.giveBorder(3, 1, "dedede")
        imageUnggahFile.image = UIImage(named: "plus-circular")?.tinted(with: UIColor(hexString: "bababa"))
    }
    
}

extension DialogTambahLampiran {
    @IBAction func buttonCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTambahClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        if fieldJudul.trim() == "" {
            self.view.makeToast("Anda belum mengisi judul file.")
        } else if labelUnggahFile.text == "Unggah File" {
            self.view.makeToast("Anda belum memilih file.")
        } else {
            _delegate.tambahClick(title: fieldJudul.trim(), file: labelUnggahFile.text ?? "", data: pickedData)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func viewUnggahFileClick() {
        picker.showAttachmentMenu()
    }
}

extension DialogTambahLampiran: HSAttachmentPickerDelegate {
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: completion)
        }
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data, filename: String, image: UIImage?) {
        
        if let _image = image {
            guard let imageData = _image.pngData() else {
                self.view.makeToast("Gambar yang anda pilih tidak sesuai ketentuan.")
                return
            }
            pickedData = imageData
            labelUnggahFile.text = filename
            return
        }
        
        pickedData = data
        labelUnggahFile.text = filename

        if filename.contains(regex: "(jpg|png|jpeg)") {
            guard let imageData = UIImage(data: data)?.pngData() else {
                self.view.makeToast("Gambar yang anda pilih tidak sesuai ketentuan.")
                return
            }
                        
            pickedData = imageData
        }
    }
}
