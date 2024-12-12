//
//  InformationDetailTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 26/11/24.
//

import UIKit

class InformationDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var budgetTitle: UILabel!
    @IBOutlet weak var revenueTitle: UILabel!
    @IBOutlet weak var genreStack: UIStackView!
    @IBOutlet weak var adultTitle: UILabel!
    @IBOutlet weak var runTimeTitle: UILabel!
    @IBOutlet weak var genresTitle: UILabel!
    @IBOutlet weak var moneyStack: UIStackView!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var adult: UILabel!
    @IBOutlet weak var originalLanguage: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

// MARK: - Setup methods
extension InformationDetailTableViewCell {
    
    func setupData(movie: MovieModel) {
        moneyStack.isHidden = false
        revenue.text = movie.revenue > 0 ? "\(movie.revenue.toCurrencyString())" : LanguageDictionary.noData.dictionary
        budget.text = movie.budget > 0 ? "\(movie.budget.toCurrencyString())" : LanguageDictionary.noData.dictionary
        
        adult.text = movie.isAdult ?
        (SettingsManager.shared.currentLanguage == .english ? "Yes" : "Có") :
        (SettingsManager.shared.currentLanguage == .english ? "No" : "Không")
        
        originalLanguage.text = !movie.originalTitle.isEmpty ? movie.originalTitle : LanguageDictionary.noData.dictionary
        runTime.text = movie.runtime > 0 ? movie.runtime.toRuntimeString() : LanguageDictionary.noData.dictionary
        status.text = !movie.status.isEmpty ? movie.status.capitalized : LanguageDictionary.noData.dictionary
        genres.text = !movie.genres.toGenresString().isEmpty ? movie.genres.toGenresString() : LanguageDictionary.noData.dictionary
        
        informationTitle.text = LanguageDictionary.information.dictionary
        genresTitle.text = LanguageDictionary.genres.dictionary
        statusTitle.text = LanguageDictionary.status.dictionary
        runTimeTitle.text = LanguageDictionary.runtime.dictionary
        originalTitle.text = LanguageDictionary.originalName.dictionary
        adultTitle.text = LanguageDictionary.adult.dictionary
        budgetTitle.text = LanguageDictionary.budget.dictionary
        revenueTitle.text = LanguageDictionary.revenue.dictionary
    }
    
    func setupDataTVSeries(tvSeries: TVSeriesModel) {
        informationTitle.text = LanguageDictionary.information.dictionary
        genresTitle.text = LanguageDictionary.genres.dictionary
        statusTitle.text = LanguageDictionary.status.dictionary
        originalTitle.text = LanguageDictionary.originalName.dictionary
        runTimeTitle.text = LanguageDictionary.numberOfSeasons.dictionary
        adultTitle.text = LanguageDictionary.type.dictionary
        
        moneyStack.isHidden = true
        adult.text = !tvSeries.type.isEmpty ? tvSeries.type : LanguageDictionary.noData.dictionary
        originalLanguage.text = !tvSeries.originalTitle.isEmpty ? tvSeries.originalTitle : LanguageDictionary.noData.dictionary
        runTime.text = tvSeries.seasons.count > 0 ? "\(tvSeries.seasons.count)" : LanguageDictionary.noData.dictionary
        status.text = !tvSeries.status.isEmpty ? tvSeries.status.capitalized : LanguageDictionary.noData.dictionary
        genres.text = !tvSeries.genres.toGenresString().isEmpty ? tvSeries.genres.toGenresString() : LanguageDictionary.noData.dictionary
    }
    
    func setupDataSeason(season: DetailSeasonModel) {
        informationTitle.text = LanguageDictionary.information.dictionary
        statusTitle.text = LanguageDictionary.airDate.dictionary
        runTimeTitle.text = LanguageDictionary.voteAverage.dictionary
        originalTitle.text = LanguageDictionary.season.dictionary
        adultTitle.text = LanguageDictionary.numberOfEpisodes.dictionary
        
        moneyStack.isHidden = true
        genreStack.isHidden = true
        
        // Air date
        status.text = !(season.airDate.isEmpty ?? true) ? String.formattedDateString(from: season.airDate) : LanguageDictionary.noData.dictionary
        
        // Vote average with or without star
        if season.voteAverage > 0 {
            let voteAverageText = String(format: "%.1f", season.voteAverage)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor.systemYellow)
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
            let attributedString = NSMutableAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(string: " \(voteAverageText)")
            attributedString.append(textString)
            runTime.attributedText = attributedString
        } else {
            runTime.text = LanguageDictionary.noData.dictionary
        }
        
        // Season number
        originalLanguage.text = season.seasonNumber > 0 ? "\(season.seasonNumber)" : LanguageDictionary.noData.dictionary
        
        // Episodes count
        adult.text = season.episodes.count > 0 ? "\(season.episodes.count)" : LanguageDictionary.noData.dictionary
    }
    
    func setupEpisode(episode: DetailEpisodeModel) {
        informationTitle.text = LanguageDictionary.information.dictionary
        statusTitle.text = LanguageDictionary.airDate.dictionary
        runTimeTitle.text = LanguageDictionary.runtime.dictionary
        originalTitle.text = LanguageDictionary.voteAverage.dictionary
        adultTitle.text = LanguageDictionary.voteCount.dictionary
        moneyStack.isHidden = true
        genreStack.isHidden = true
        // Air date
        status.text = !(episode.airDate.isEmpty) ? String.formattedDateString(from: episode.airDate) : LanguageDictionary.noData.dictionary
        // Runtime
        runTime.text = episode.runtime > 0 ? episode.runtime.toRuntimeString() : LanguageDictionary.noData.dictionary
        
        // Vote average with or without star
        if episode.voteAverage > 0 {
            let voteAverageText = String(format: "%.1f", episode.voteAverage)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor.systemYellow)
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
            let attributedString = NSMutableAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(string: " \(voteAverageText)")
            attributedString.append(textString)
            originalLanguage.attributedText = attributedString
        } else {
            originalLanguage.text = LanguageDictionary.noData.dictionary
        }
        
        // Vote count
        adult.text = episode.voteCount > 0 ? "\(episode.voteCount)" : LanguageDictionary.noData.dictionary
    }
    
}
