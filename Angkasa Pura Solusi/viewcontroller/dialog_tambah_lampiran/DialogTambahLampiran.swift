//
//  DialogTambahLampiran.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 24/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift
import MobileCoreServices

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
        let allowedFiles = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
        let importMenu = UIDocumentPickerViewController(documentTypes: allowedFiles, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

extension DialogTambahLampiran: UIDocumentPickerDelegate {
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
            labelUnggahFile.text = "\(filename ?? "")"
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
    
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
//        DispatchQueue.main.async {
//            self.present(controller, animated: true, completion: completion)
//        }
//    }
//
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) {
//        self.view.makeToast(errorMessage)
//    }
//
//    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data, filename: String, image: UIImage?) {
//
//        if let _image = image {
//            guard let imageData = _image.pngData() else {
//                self.view.makeToast("Gambar yang anda pilih tidak sesuai ketentuan.")
//                return
//            }
//            pickedData = imageData
//            labelUnggahFile.text = filename
//            return
//        }
//
//        pickedData = data
//        labelUnggahFile.text = filename
//
//        if filename.contains(regex: "(jpg|png|jpeg)") {
//            guard let imageData = UIImage(data: data)?.pngData() else {
//                self.view.makeToast("Gambar yang anda pilih tidak sesuai ketentuan.")
//                return
//            }
//
//            pickedData = imageData
//        }
//    }
}
