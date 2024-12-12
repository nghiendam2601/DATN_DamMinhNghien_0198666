//
//  ThirdDetailTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 11/11/24.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBoutlets
    @IBOutlet var lblActorRole: UILabel!
    @IBOutlet var lblActorName: UILabel!
    @IBOutlet var imgActor: UIImageView!
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Setup methods
    func setupActorCollectionViewCell(actor: ActorModel?) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullImagePath = baseURL + (actor?.profilePath ?? "")
        ImageLoader.loadImage(for: imgActor, from: fullImagePath, cornerRadius: 10)
        lblActorName.text = actor?.name ?? ""
        lblActorRole.text = actor?.character ?? ""
    }
    
    func configureSearchCell(type: String, model: Any) {
        if type == LanguageDictionary.movies.dictionary {
            guard let movie = model as? MovieModel else { return }
            ImageLoader.loadImage(for: imgActor, from: ScriptConstants.imageUrlW500 + movie.posterPath, cornerRadius: 10)
            lblActorName.text = movie.title
            lblActorRole.text = type
        } else if type == LanguageDictionary.tvSeries.dictionary {
            guard let tvSeries = model as? TVSeriesModel else { return }
            ImageLoader.loadImage(for: imgActor, from: ScriptConstants.imageUrlW500 + tvSeries.posterPath, cornerRadius: 10)
            lblActorName.text = tvSeries.name
            lblActorRole.text = type
        } else {
            guard let person = model as? ActorModel else { return }
            ImageLoader.loadImage(for: imgActor, from: ScriptConstants.imageUrlW500 + person.profilePath, cornerRadius: 10)
            lblActorName.text = person.name
            lblActorRole.text = type
        }
    }
    
}
