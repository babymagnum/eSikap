//
//  DaftarPeminjamanRuanganCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

protocol DaftarPeminjamanRuanganProtocol {
    func agendaClick(data: SchedulesRoomDataAgenda)
    func updateLayout()
}

class DaftarPeminjamanRuanganCell: UICollectionViewCell, UICollectionViewDelegate {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var collectionDaftarPeminjamanRuangan: UICollectionView!
    @IBOutlet weak var collectionDaftarPeminjamanRuanganHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDot: UIView!
    
    private var listAgenda = [SchedulesRoomDataAgenda]()
    
    var delegate: DaftarPeminjamanRuanganProtocol?
    var data: SchedulesRoomData? {
        didSet {
            if let _data = data {
                labelDate.text = _data.date_show
                labelDay.text = "\(_data.day?.prefix(3) ?? "")"
                listAgenda = _data.agenda
                collectionDaftarPeminjamanRuangan.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.collectionDaftarPeminjamanRuanganHeight.constant = self.collectionDaftarPeminjamanRuangan.contentSize.height
                    self.layoutIfNeeded()
                    
                    guard let _delegate = self.delegate else { return }
                    _delegate.updateLayout()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewDot.giveBorder(2.5, 0, "fff")
        initCollection()
    }
    
    private func initCollection() {
        collectionDaftarPeminjamanRuangan.register(UINib(nibName: "ItemPeminjamanRuanganCell", bundle: nil), forCellWithReuseIdentifier: "ItemPeminjamanRuanganCell")
        collectionDaftarPeminjamanRuangan.delegate = self
        collectionDaftarPeminjamanRuangan.dataSource = self
    }

}

extension DaftarPeminjamanRuanganCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textHeight = listAgenda[indexPath.item].title_agenda?.trim().getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 45 - PublicFunction().getGlobalHeight(), font_size: 12) ?? 0
        return CGSize(width: UIScreen.main.bounds.width - 45 - PublicFunction().getGlobalHeight() - 32, height: textHeight + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAgenda.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPeminjamanRuanganCell", for: indexPath) as! ItemPeminjamanRuanganCell
        cell.data = listAgenda[indexPath.item]
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}

extension DaftarPeminjamanRuanganCell {
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionDaftarPeminjamanRuangan.indexPathForItem(at: sender.location(in: collectionDaftarPeminjamanRuangan)) else { return }
        
        guard let _delegate = delegate else { return }
        
        _delegate.agendaClick(data: listAgenda[indexpath.item])
    }
}
