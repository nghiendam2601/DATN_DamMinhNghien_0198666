//
//  FifthTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 26/11/24.
//

import UIKit

class FifthDetailTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lblWatchReviewMovie: UILabel!
    @IBOutlet weak var btnWatchNow: UIButton!
    
    // MARK: - Properties
    var onSelectWatchNow: (() -> Void)?
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        btnWatchNow.layer.cornerRadius = btnWatchNow.bounds.height / 2
    }
    
    func configureCell() {
        lblWatchReviewMovie.text = LanguageDictionary.watchReview.dictionary
        btnWatchNow.setTitle(LanguageDictionary.watchNow.dictionary, for: .normal)
    }

    // MARK: Actions
    @IBAction func btnWatchNowAction(_ sender: UIButton) {
        onSelectWatchNow?()
    }
}
