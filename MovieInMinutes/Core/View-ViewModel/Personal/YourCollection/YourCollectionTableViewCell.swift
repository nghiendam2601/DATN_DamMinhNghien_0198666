//
//  YourCollectionTableViewCell.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import UIKit
import SwipeCellKit

class YourCollectionTableViewCell: SwipeTableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var baseStackView: UIStackView!
    
    //MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
}
