

import UIKit

class SeeAllViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var movieList: [MovieModel]?
    var movieListType: MovieListType?
    var tvSeriesList: [TVSeriesModel]?
    var tvSeriesListType: TVSeriesListType?
    var listType: Category?
    var seasonList: [DetailSeasonModel]?
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setup methods
    func setup() {
        if movieList != nil {
            title = "\(movieListType?.title ?? "")"
            collectionView.reloadData()
        } else if tvSeriesList != nil {
            title = "\(tvSeriesListType?.title ?? "")"
            collectionView.reloadData()
        } else if seasonList != nil {
            title = "Seasons"
            collectionView.reloadData()
        }
        registerCollectionView(collectionView, identifier: Identifier.baseCollectionViewCell)
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    // MARK: Actions
    @objc func languageDidChange() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - CollectionView
extension SeeAllViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listType == .Movie {
            return movieList?.count ?? 0
        } else if listType == .TVSeries {
            return tvSeriesList?.count ?? 0
        } else {
            return seasonList?.count ?? 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.baseCollectionViewCell, for: indexPath) as? BaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(movie: movieList?[indexPath.row], tvSeries: tvSeriesList?[indexPath.row], listType: listType, indexPath: indexPath, seasonList: seasonList?[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = movieList?[indexPath.row] {
            guard let vc = UIStoryboard(name: Identifier.detailMovieViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailMovieViewController) as? DetailMovieViewController else { return }
            vc.movieID = movie.id
            navigationController?.pushViewController(vc, animated: true)
        } else if let tvSeries = tvSeriesList?[indexPath.row] {
            guard let vc = UIStoryboard(name: Identifier.detailTVSeriesViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailTVSeriesViewController) as? DetailTVSeriesViewController else { return }
            vc.tvSeriesID = tvSeries.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
