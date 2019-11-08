//
//  OnboardingController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class OnboardingController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var indicator1: UIView!
    @IBOutlet weak var indicator2: UIView!
    @IBOutlet weak var indicator3: UIView!
    @IBOutlet weak var indicator4: UIView!
    @IBOutlet weak var buttonLanjutkan: UIButton!
    @IBOutlet weak var buttonLewati: UIButton!
    @IBOutlet weak var onboardingCollection: UICollectionView!
    @IBOutlet weak var viewIndicatorHeight: NSLayoutConstraint!
    
    // properties
    private var listOnboarding = [Onboarding]()
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initCollection()
        
        populateCollection()
    }
    
    private func initView() {
        indicator1.layer.cornerRadius = indicator1.frame.height / 2
        indicator2.layer.cornerRadius = indicator1.frame.height / 2
        indicator3.layer.cornerRadius = indicator1.frame.height / 2
        indicator4.layer.cornerRadius = indicator1.frame.height / 2
        buttonLewati.layer.cornerRadius = buttonLewati.frame.height / 2
        buttonLanjutkan.layer.cornerRadius = buttonLanjutkan.frame.height / 2
        
        // register click event
        buttonLewati.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonLewatiClick(sender:))))
        
        buttonLanjutkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonLanjutkanClick(sender:))))
    }
    
    private func populateCollection() {
        listOnboarding.append(Onboarding(title: "Kenali Lebih Dekat Rekan Kerja Anda", image: UIImage(named: "onboarding1"), description: "Berikan selamat di hari ulang tahunya, ucapkan selamat datang kepada karyawan baru"))
        
        listOnboarding.append(Onboarding(title: "Ajukan Ijin dan Cuti Anda Tanpa Repot", image: UIImage(named: "onboarding2"), description: "Ajukan ijin dan cuti anda tanpa repot menulis form, dengan eSIKAP Mobile pengajuan bisa dilakukan dengan mudah"))
        
        listOnboarding.append(Onboarding(title: "Pesan Ruang Untuk Rapat Dimanapun dan Kapanpun", image: UIImage(named: "onboarding3"), description: "Pesan Ruangan untuk kebutuhan Rapat dengan mudah melalui eSIKAP Mobile"))
        
        listOnboarding.append(Onboarding(title: "Monitor Performa Anda Melalui Data Presensi", image: UIImage(named: "onboarding4"), description: "Seberapa rajinkah anda, berapa presentase kehadiran anda di kantor, semua termonitor di dalam eSIKAP Mobile"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.onboardingCollection.reloadData()
        }
    }
    
    private func initCollection() {
        onboardingCollection.register(UINib(nibName: "OnboardingCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCell")
        
        onboardingCollection.delegate = self
        onboardingCollection.dataSource = self
        onboardingCollection.isPagingEnabled = true
        onboardingCollection.showsHorizontalScrollIndicator = false
    }
    
    func highlightIndicator(_ page: Int) {
        switch page {
        case 0:
            focusIndicator(indicator1)
            unfocusIndicator(indicator2)
            unfocusIndicator(indicator3)
            unfocusIndicator(indicator4)
        case 1:
            unfocusIndicator(indicator1)
            focusIndicator(indicator2)
            unfocusIndicator(indicator3)
            unfocusIndicator(indicator4)
        case 2:
            unfocusIndicator(indicator1)
            unfocusIndicator(indicator2)
            focusIndicator(indicator3)
            unfocusIndicator(indicator4)
        case 3:
            unfocusIndicator(indicator1)
            unfocusIndicator(indicator2)
            unfocusIndicator(indicator3)
            focusIndicator(indicator4)
        default:
            unfocusIndicator(indicator1)
            unfocusIndicator(indicator2)
            unfocusIndicator(indicator3)
            focusIndicator(indicator4)
        }
    }
    
    func focusIndicator(_ view: UIView) {
        UIView.animate(withDuration: 0.2) {
            view.backgroundColor = UIColor.init(rgb: 0x42A5F5).withAlphaComponent(1)
        }
    }
    
    func unfocusIndicator(_ view: UIView) {
        UIView.animate(withDuration: 0.2) {
            view.backgroundColor = UIColor.init(rgb: 0x42A5F5).withAlphaComponent(0.5)
        }
    }
    
    func changeButtonDynamically(_ page: Int) {
        if page == 3 {
            UIView.animate(withDuration: 0.2) {
                self.buttonLanjutkan.setTitle("Memulai", for: .normal)
                self.buttonLanjutkan.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.buttonLanjutkan.setTitle("Lanjutkan", for: .normal)
                self.buttonLanjutkan.layoutIfNeeded()
            }
        }
    }
}

// handle click event
extension OnboardingController {
    @objc func buttonLewatiClick(sender: UITapGestureRecognizer) {
        preference.saveBool(value: true, key: staticLet.IS_FIRST_TIME_OPEN)
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    @objc func buttonLanjutkanClick(sender: UITapGestureRecognizer) {
        switch currentPage {
        case 3:
            preference.saveBool(value: true, key: staticLet.IS_FIRST_TIME_OPEN)
            self.navigationController?.pushViewController(LoginController(), animated: true)
        default:
            currentPage += 1
            highlightIndicator(currentPage)
            onboardingCollection.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
            self.changeButtonDynamically(currentPage)
        }
    }
}

extension OnboardingController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if listOnboarding.count > 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: self.onboardingCollection.frame.height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.currentPage = currentPage
        highlightIndicator(self.currentPage)
        changeButtonDynamically(self.currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOnboarding.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.onboarding = listOnboarding[indexPath.item]
        return cell
    }
    
    
}
