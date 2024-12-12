

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var image: UIImageView!
    @IBOutlet var label: UILabel!
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = image.bounds.height / 6
    }
    
    func setup(movie: MovieModel?, tvSeries: TVSeriesModel?, listType: Category?, indexPath: IndexPath, seasonList: DetailSeasonModel?) {
        let baseURL = ScriptConstants.imageUrlW500
        var fullImagePath = ""
        if listType == .Movie {
            fullImagePath = baseURL + (movie?.posterPath ?? "")
            label.text = movie?.title
        } else if listType == .TVSeries {
            fullImagePath = baseURL + (tvSeries?.posterPath ?? "")
            label.text = tvSeries?.name
        } else {
            fullImagePath = baseURL + (seasonList?.posterPath ?? "")
            label.text = seasonList?.name
        }
        ImageLoader.loadImage(for: image, from: fullImagePath, cornerRadius: 10)
    }
    
    
}
