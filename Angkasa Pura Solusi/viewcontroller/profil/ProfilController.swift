//
//  ProfilController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

enum WhichKaryawan {
    case myProfile
    case otherProfile
}

class ProfilController: BaseViewController {

    @IBOutlet weak var viewActionBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelJabatan: UILabel!
    @IBOutlet weak var labelDivisi: UILabel!
    @IBOutlet weak var labelLokasiKerja: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTelepon: UILabel!
    @IBOutlet weak var viewUbahKataSandi: UIView!
    @IBOutlet weak var viewKeluar: UIView!
    @IBOutlet weak var viewAction: UIView!
    @IBOutlet weak var viewInformation: UIView!
    @IBOutlet weak var buttonBackWidth: NSLayoutConstraint!
    @IBOutlet weak var labelTitleMarginStart: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewTopHeight: NSLayoutConstraint!
    
    var open: WhichKaryawan?
    var empId: String?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        initView()
        
        clickEvent()
        
        if open == .myProfile {
            buttonBackWidth.constant = 0
            labelTitleMarginStart.constant = 14
            labelTitle.text = "Profil"
            getProfile()
        } else {
            viewAction.isHidden = true
            labelTitleMarginStart.constant = -12
            labelTitle.text = "Detail Karyawan"
            getKaryawanProfil()
        }
        
        checkVersion()
    }
    
    private func checkVersion() {
        if #available(iOS 11, *) {
            //do nothing
        } else {
            viewActionBottomMargin.constant += 49 // 49 is height of ui tabbar
            scrollView.resizeScrollViewContentSize()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func clickEvent() {
        viewUbahKataSandi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUbahKataSandiClick)))
        
        viewKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKeluarClick)))
    }
    
    private func initView() {
        self.scrollView.alpha = 0
        viewTopHeight.constant = 0
        
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        scrollView.addSubview(refreshControl)
        
        self.viewInformation.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 1, 3)
        self.viewAction.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 1, 3)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.imageAccount.layer.cornerRadius = self.imageAccount.frame.width / 2
                self.viewTopHeight.constant = self.labelNama.getHeight(width: self.labelNama.frame.width) + self.labelJabatan.getHeight(width: self.labelJabatan.frame.width) + self.labelDivisi.getHeight(width: self.labelDivisi.frame.width) + self.imageAccount.frame.height + 60
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setView(_ item: ItemProfile) {
        imageAccount.loadUrl(item.img!)
        labelNama.text = item.emp_name
        labelJabatan.text = item.position
        labelDivisi.text = item.unit
        labelLokasiKerja.text = item.workarea
        labelEmail.text = item.email
        labelTelepon.text = item.phone
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.alpha = 1
        }
    }
    
    private func setKaryawanView(_ item: ItemDetailKaryawan) {
        imageAccount.loadUrl(item.img!)
        labelNama.text = item.emp_name
        labelJabatan.text = item.position
        labelDivisi.text = item.unit
        labelLokasiKerja.text = item.workarea
        labelEmail.text = item.email
        labelTelepon.text = item.phone
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.alpha = 1
        }
    }
    
    private func getKaryawanProfil() {
        SVProgressHUD.show()
        informationNetworking.getProfileByEmpId(empId: empId ?? "") { (error, itemDetailKaryawan, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Karyawan", error, "Reload", "Cancel", completionHandler: {
                        self.getKaryawanProfil()
                    })
                }
                
                guard let item = itemDetailKaryawan else { return }
                
                self.setKaryawanView(item)
            }
        }
    }
    
    private func getProfile() {
        SVProgressHUD.show()
        informationNetworking.getProfile { (error, itemProfile, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Profil", error, "Reload", "Cancel", completionHandler: {
                        if self.open == .myProfile { self.getProfile() }
                        else { self.getKaryawanProfil() }
                    })
                    return
                }
                
                guard let item = itemProfile else { return }
                
                self.setView(item)
            }
        }
    }

}

extension ProfilController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        if open == .myProfile {
            getProfile()
        } else {
            getKaryawanProfil()
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewKeluarClick() {
        function.showUnderstandDialog(self, "Keluar dari ESS APS", "Yakin ingin keluar?", "KELUAR", "BATAL") {
            
            SVProgressHUD.show()
            
            self.authNetworking.logout(completion: { (error, logout, isExpired) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let _ = isExpired {
                        self.forceLogout(self.navigationController!)
                        return
                    }
                    
                    if let error = error {
                        self.function.showUnderstandDialog(self, "Gagal Logout", error, "Mengerti")
                        return
                    }
                    
                    self.resetData()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            
        }
    }
    
    @objc func viewUbahKataSandiClick() {
        navigationController?.pushViewController(ChangePasswordController(), animated: true)
    }
}
