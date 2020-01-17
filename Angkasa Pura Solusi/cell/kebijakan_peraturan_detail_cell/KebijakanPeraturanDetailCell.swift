//
//  KebijakanPeraturanDetailCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

protocol KebijakanPeraturanDetailProtocol {
    func subItemClick(data: PolicyDataFilesItem)
    func updateLayout()
    func expandClick(index: Int, isExpanded: Bool)
}

class KebijakanPeraturanDetailCell: UICollectionViewCell, UICollectionViewDelegate {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var buttonExpand: UIButton!
    @IBOutlet weak var collectionItem: UICollectionView!
    @IBOutlet weak var collectionItemHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDividerHeight: NSLayoutConstraint!
    
    private var listFiles = [PolicyDataFilesItem]()
    
    var delegate: KebijakanPeraturanDetailProtocol?
    var position: Int?
    var data: PolicyDataListItem? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.name
                labelDate.text = _data.date
                
                listFiles = _data.files
                collectionItem.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRoot.giveBorder(4, 0, "ffffff")
        
        viewDividerHeight.constant = 0
        collectionItemHeight.constant = 0
        
        collectionItem.register(UINib(nibName: "KebijakanPeraturanFileCell", bundle: nil), forCellWithReuseIdentifier: "KebijakanPeraturanFileCell")
        let collectionLayout = collectionItem.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 20)
        collectionItem.delegate = self
        collectionItem.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
        
        collectionItem.collectionViewLayout.invalidateLayout()
    }
}

extension KebijakanPeraturanDetailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KebijakanPeraturanFileCell", for: indexPath) as! KebijakanPeraturanFileCell
        cell.data = listFiles[indexPath.item]
        cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewRootClick(sender:))))
        return cell
    }
}

extension KebijakanPeraturanDetailCell {
    @objc func collectionViewRootClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionItem.indexPathForItem(at: sender.location(in: collectionItem)) else { return }
        
        guard let _delegate = delegate else { return }
        
        _delegate.subItemClick(data: listFiles[indexpath.item])
    }
    
    @IBAction func buttonExpandClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        guard let _position = position else { return }
        guard let _data = data else { return }
        
        if _data.isExpanded {
            UIView.animate(withDuration: 0.4) {
                self.viewDividerHeight.constant = 0
                self.collectionItemHeight.constant = 0
                self.buttonExpand.setImage(UIImage(named: "group_634"), for: .normal)
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.viewDividerHeight.constant = 1
                self.collectionItemHeight.constant = self.collectionItem.contentSize.height
                self.buttonExpand.setImage(UIImage(named: "group_633"), for: .normal)
            }
        }
        
        _delegate.updateLayout()
        _delegate.expandClick(index: _position, isExpanded: !_data.isExpanded)
    }
}
