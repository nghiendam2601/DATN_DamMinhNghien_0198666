

import UIKit


class FirstDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var addListStack: UIStackView!
    @IBOutlet weak var btnAddList: UIButton!
    @IBOutlet weak var lblYourRate: UILabel!
    @IBOutlet weak var lblRateThis: UILabel!
    @IBOutlet weak var totalRated: UILabel!
    @IBOutlet weak var myRate: UILabel!
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var voteAvg: UILabel!
    @IBOutlet var backdropPath: UIImageView!
    @IBOutlet weak var lblWatchList: UILabel!
    @IBOutlet var posterPath: UIImageView!
    
    // MARK: - Properties
    var onAddListSelected: (() -> Void)?
    var onRatingSelected: ((Bool) -> Void)?
    var movieID: Int? {
        didSet {
            isRated = false
        }
    }
    var tvSeriesID: Int? {
        didSet {
            isRated = false
        }
    }
    var isRated: Bool = false {
        didSet {
            if !isRated {
                if let yourRate = AppConstant.moviesRated[movieID ?? 0],
                   yourRate != 0,
                   movieID != nil {
                    btnRating.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    lblRateThis.text = "\(yourRate)"
                    lblYourRate.text = LanguageDictionary.myRating.dictionary
                    lblYourRate.isHidden = false
                    isRated = true
                } else if let yourRate = AppConstant.tvRated[tvSeriesID ?? 0],
                          yourRate != 0,
                          tvSeriesID != nil {
                    btnRating.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    lblRateThis.text = "\(yourRate)"
                    lblYourRate.text = LanguageDictionary.myRating.dictionary
                    lblYourRate.isHidden = false
                    isRated = true
                } else {
                    btnRating.setImage(UIImage(systemName: "star"), for: .normal)
                    lblRateThis.text = LanguageDictionary.ratingThis.dictionary
                    lblYourRate.isHidden = true
                    isRated = false
                }
            } else {
                btnRating.setImage(UIImage(systemName: "star"), for: .normal)
                lblRateThis.text = LanguageDictionary.ratingThis.dictionary
                lblYourRate.isHidden = true
                isRated = false
            }
        }
    }
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(setupUI), name: .appearanceChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .appearanceChanged, object: nil)
    }
    
}

// MARK: - Setup methods
extension FirstDetailTableViewCell {
    
    func configureCell() {
        lblWatchList.text = LanguageDictionary.addToList.dictionary
    }
    
    @objc func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if let sublayers = weakSelf.backdropPath.layer.sublayers, sublayers.count > 0 {
                if sublayers.first is CAGradientLayer {
                    sublayers.first?.removeFromSuperlayer()
                }
            }
            let color = SettingsManager.shared.currentAppearance == .dark ? UIColor.black : UIColor.white
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.clear.cgColor,
                color.cgColor
            ]
            gradientLayer.locations = [0.3, 1.0]
            gradientLayer.frame = weakSelf.backdropPath.bounds
            weakSelf.backdropPath.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func setupCell(movie: MovieModel) {
        let posterURL = ScriptConstants.imageUrlW500 + (movie.posterPath)
        let backdropURL = ScriptConstants.imageUrlW1280 + (movie.backdropPath)
        movieID = movie.id
        ImageLoader.loadImage(for: posterPath, from: posterURL, cornerRadius: 10)
        ImageLoader.loadImage(for: backdropPath, from: backdropURL, cornerRadius: 0)
        voteAvg.text = String(format: "%.1f", movie.voteAverage)
        titleLabel.text = movie.title
        releaseDateLabel.text = String.formattedDateString(from: movie.releaseDate)
        totalRated.text = "\(movie.voteCount)"
    }
    
    func setupCellTVSeries(tvSeries: TVSeriesModel) {
        let posterURL = ScriptConstants.imageUrlW500 + (tvSeries.posterPath)
        let backdropURL = ScriptConstants.imageUrlW1280 + (tvSeries.backdropPath)
        tvSeriesID = tvSeries.id
        ImageLoader.loadImage(for: posterPath, from: posterURL, cornerRadius: 10)
        ImageLoader.loadImage(for: backdropPath, from: backdropURL, cornerRadius: 0)
        voteAvg.text = String(format: "%.1f", tvSeries.voteAverage)
        titleLabel.text = tvSeries.name
        releaseDateLabel.text = String.formattedDateString(from: tvSeries.firstAirDate)
        totalRated.text = "\(tvSeries.voteCount)"
    }
    
}

// MARK: - Actions
extension FirstDetailTableViewCell {
    
    @IBAction func btnRatingAction(_ sender: UIButton) {
        onRatingSelected?(isRated)
    }
    
    @IBAction func btnAddListAction(_ sender: UIButton) {
        onAddListSelected?()
    }
    
}
