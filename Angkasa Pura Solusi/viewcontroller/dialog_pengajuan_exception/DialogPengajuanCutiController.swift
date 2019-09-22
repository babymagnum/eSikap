//
//  DialogPengajuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DialogPengajuanCutiController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var buttonOke: CustomButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionExceptionHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionException: UICollectionView!
    
    var listException = [String]()
    
    var exception: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initCollection()
    }
    
    private func initView() {
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
        buttonOke.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionException.collectionViewLayout.invalidateLayout()
    }

    private func initCollection() {
        collectionException.register(UINib(nibName: "ExceptionCell", bundle: nil), forCellWithReuseIdentifier: "ExceptionCell")
        
        collectionException.delegate = self
        collectionException.dataSource = self
        
        guard let exception = exception else { return }
        
        let cleanException = exception.replacingOccurrences(of: "<li>", with: "").replacingOccurrences(of: "<ul>", with: "").replacingOccurrences(of: "</ul>", with: "").replacingOccurrences(of: "<span>", with: "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "&#8226;", with: "")
        listException = cleanException.components(separatedBy: exception.contains("span") ? "</span>" : "</li>")
        
        self.collectionException.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionExceptionHeight.constant = self.collectionException.contentSize.height
                self.viewContainerHeight.constant =  self.collectionExceptionHeight.constant + ((UIScreen.main.bounds.width - 42) * 0.21) + 159
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension DialogPengajuanCutiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = listException[indexPath.item]
        
        return CGSize(width: collectionException.frame.width, height: item.getHeight(withConstrainedWidth: collectionException.frame.width, font_size: 14))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listException.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExceptionCell", for: indexPath) as! ExceptionCell
        cell.data = listException[indexPath.item]
        return cell
    }
    
}
