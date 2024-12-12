//
//  ThirdDetailTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 11/11/24.
//

import UIKit

class ThirdDetailTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var thirdDetailVIew: UIView!
    @IBOutlet weak var lblCast: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var onSelectActor: ((Int) -> Void)?
    var cast: [ActorModel]? {
        didSet {
            collectionView.reloadData()
            lblCast.text = LanguageDictionary.cast.dictionary
        }
    }
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView(collectionView, identifier: Identifier.actorCollectionViewCell)
    }
    
}

//MARK: - CollectionViewDataSource
extension ThirdDetailTableViewCell {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.actorCollectionViewCell, for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        cell.setupActorCollectionViewCell(actor: cast?[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemHeight * 125/235, height: itemHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = cast?[indexPath.row].id else { return }
        onSelectActor?(id)
    }
}
