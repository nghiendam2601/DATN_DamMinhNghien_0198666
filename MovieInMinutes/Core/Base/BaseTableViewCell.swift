//
//  BaseTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 20/10/24.
//

import UIKit

// MARK: - Cell
class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCollectionView(_ collectionView: UICollectionView, identifier: String) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "\(identifier)", bundle: nil), forCellWithReuseIdentifier: "\(identifier)")
    }
    
}

// MARK: - CollectionView
extension BaseTableViewCell: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

extension BaseTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select")
    }
    
}

extension BaseTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemHeight * 125/235, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
}

