//
//  YourRatingsTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 24/11/24.
//

import UIKit
import SwipeCellKit

class YourItemTableViewCell: SwipeTableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblYourRate: UILabel!
    @IBOutlet weak var lblYourRating: UILabel!
    @IBOutlet weak var btnYourRating: UIButton!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var yourRatingStack: UIStackView!
    
    //MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.layer.cornerRadius = stackView.bounds.height / 7
        stackView.clipsToBounds = true
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray.cgColor
    }
 
    //MARK: - Functions
    func configureCell(movie: MovieModel) {
        let posterURL = ScriptConstants.imageUrlW500 + (movie.posterPath)
        ImageLoader.loadImage(for: img, from: posterURL, cornerRadius: 0)
        lblRating.text = String(format: "%.1f", movie.voteAverage)
        lblTitle.text = movie.title
        lblReleaseDate.text = String.formattedDateString(from: movie.releaseDate)
        lblTotalRating.text = "\(movie.voteCount)"
        lblYourRating.text = "\(movie.rating)"
        lblYourRate.text = LanguageDictionary.myRating.dictionary
    }
    
    func configureCellTVSeries(tvSeries: TVSeriesModel) {
        let posterURL = ScriptConstants.imageUrlW500 + (tvSeries.posterPath)
        ImageLoader.loadImage(for: img, from: posterURL, cornerRadius: 0)
        lblRating.text = String(format: "%.1f", tvSeries.voteAverage)
        lblTitle.text = tvSeries.name
        lblReleaseDate.text = String.formattedDateString(from: tvSeries.firstAirDate)
        lblTotalRating.text = "\(tvSeries.voteCount)"
        lblYourRating.text = "\(tvSeries.rating)"
        lblYourRate.text = LanguageDictionary.myRating.dictionary
    }
    
}
