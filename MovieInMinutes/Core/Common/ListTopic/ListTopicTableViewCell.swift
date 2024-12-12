//
//  MovieListTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 19/10/24.
//

import UIKit

class ListTopicTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var seeAll: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Properties
    var movieList: [MovieModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var movieListType: MovieListType? {
        didSet {
            titleLabel.text = movieListType?.title
            seeAll.setTitle(LanguageDictionary.seeAll.dictionary, for: .normal)
        }
    }
    var tvSeriesList: [TVSeriesModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var tvSeriesListType: TVSeriesListType? {
        didSet {
            titleLabel.text = tvSeriesListType?.title
            seeAll.setTitle(LanguageDictionary.seeAll.dictionary, for: .normal)
        }
    }
    
    var seasonList: [DetailSeasonModel]? {
        didSet {
            collectionView.reloadData()
            titleLabel.text = LanguageDictionary.seasons.dictionary
        }
    }
    var episodeList: [DetailEpisodeModel]? {
        didSet {
            collectionView.reloadData()
            titleLabel.text = LanguageDictionary.episodes.dictionary
        }
    }
    var onTapSeeAll: ((Any) -> Void)?
    var onTapDetail: ((Any?) -> Void)?
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView(collectionView, identifier: Identifier.baseCollectionViewCell)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: methods
    private func configureCell(_ cell: BaseCollectionViewCell, title: String?, posterPath: String?) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullImagePath = baseURL + (posterPath ?? "")
        cell.label.text = title
        ImageLoader.loadImage(for: cell.image, from: fullImagePath, cornerRadius: 10)
    }
    
}

// MARK: - Actions
extension ListTopicTableViewCell {
    
    
    @IBAction func lblSeeAllAction(_ sender: UIButton) {
        if let movieList = movieList {
            onTapSeeAll?(movieList)
        } else if let tvSeriesList = tvSeriesList {
            onTapSeeAll?(tvSeriesList)
        } else if let seasonList = seasonList {
            onTapSeeAll?(seasonList)
        } else if let episodeList = episodeList {
            onTapSeeAll?(episodeList)
        }
    }
    
}

// MARK: - CollectionView
extension ListTopicTableViewCell {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieList = movieList {
            onTapDetail?(movieList[indexPath.row])
        } else if let tvSeriesList = tvSeriesList {
            onTapDetail?(tvSeriesList[indexPath.row])
        } else if let seasonList = seasonList {
            onTapDetail?(seasonList[indexPath.row])
        } else if let episodeList = episodeList {
            onTapDetail?(episodeList[indexPath.row])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.count ?? tvSeriesList?.count ?? seasonList?.count ?? episodeList?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.baseCollectionViewCell, for: indexPath) as? BaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let movieList = movieList {
            configureCell(cell, title: movieList[indexPath.row].title, posterPath: movieList[indexPath.row].posterPath)
        } else if let tvSeriesList = tvSeriesList {
            configureCell(cell, title: tvSeriesList[indexPath.row].name, posterPath: tvSeriesList[indexPath.row].posterPath)
        } else if let seasonList = seasonList {
            configureCell(cell, title: seasonList[indexPath.row].name, posterPath: seasonList[indexPath.row].posterPath)
        } else if let episodeList = episodeList {
            configureCell(cell, title: "\(episodeList[indexPath.row].episodeNumber). \(episodeList[indexPath.row].name)", posterPath: episodeList[indexPath.row].stillPath)
        }
        return cell
    }
    
}
