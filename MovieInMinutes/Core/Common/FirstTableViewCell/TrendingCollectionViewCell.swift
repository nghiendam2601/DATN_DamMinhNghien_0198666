//
//  TrendingCollectionViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 19/11/24.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    //MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = img.bounds.height / 7
        img.layer.borderColor = UIColor.red.cgColor
        img.layer.borderWidth = 1
    }

}
