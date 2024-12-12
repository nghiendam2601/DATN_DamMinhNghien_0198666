

import UIKit
import Kingfisher
import NVActivityIndicatorView

// MARK: - ViewController
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .red
    }
    
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // If no actions are provided, add a default "OK" action
            if let actions = actions, !actions.isEmpty {
                actions.forEach { alertController.addAction($0) }
            } else {
                let defaultAction = UIAlertAction(title: LanguageDictionary.ok.dictionary, style: .default, handler: nil)
                alertController.addAction(defaultAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTwoOptions(
        title: String?,
        message: String?,
        firstOptionTitle: String = LanguageDictionary.ok.dictionary,
        secondOptionTitle: String = LanguageDictionary.cancel.dictionary,
        firstOptionHandler: (() -> Void)?
    ) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Tùy chọn đầu tiên
            let firstAction = UIAlertAction(title: firstOptionTitle, style: .default) { _ in
                firstOptionHandler?()
            }
            // Tùy chọn thứ hai (Cancel)
            let secondAction = UIAlertAction(title: secondOptionTitle, style: .cancel, handler: nil)
            
            alertController.addAction(secondAction)
            alertController.addAction(firstAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func registerTableView(_ tableView: UITableView, identifier: String) {
        tableView.register(UINib(nibName: "\(identifier)", bundle: nil), forCellReuseIdentifier: "\(identifier)")
    }
    
    func registerCollectionView(_ collectionView: UICollectionView, identifier: String) {
        collectionView.register(UINib(nibName: "\(identifier)", bundle: nil), forCellWithReuseIdentifier: "\(identifier)")
    }
    
}

// MARK: - TableView
extension BaseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension BaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - CollectionView
extension BaseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

extension BaseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
}

extension BaseViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.bounds.width - 16)/3)
        return CGSize(width: itemWidth, height: itemWidth * 235/125)
    }
}

// MARK: - Setup methods
func setupSeeAllViewController(listType: Category?,movieList:[MovieModel]?, tvSeriesList:[TVSeriesModel]?, movieListType: MovieListType?, tvSeriesListType: TVSeriesListType?, seasonList: [DetailSeasonModel]?) -> UIViewController {
    guard let vc = UIStoryboard(name: "SeeAllViewController", bundle: nil).instantiateViewController(withIdentifier: "SeeAllViewController") as? SeeAllViewController else {
        return UIViewController()
    }
    if let listType = listType {
        if listType == .TVSeries {
            vc.tvSeriesList = tvSeriesList
            vc.listType = listType
            vc.tvSeriesListType = tvSeriesListType
        } else {
            vc.movieList = movieList
            vc.listType = listType
            vc.movieListType = movieListType
        }
    } else {
        vc.seasonList = seasonList
    }
    return vc
}


func setUpSecondDetailTableViewCell( tableView: UITableView, movie: MovieModel?,tvSeries: TVSeriesModel?, listType: Category) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.secondDetailTableViewCell) as? SecondDetailTableViewCell else {
        return UITableViewCell()
    }
    if listType == .TVSeries {
        cell.overViewLabel.text = tvSeries?.overview
    } else {
        cell.overViewLabel.text = movie?.overview
        
    }
    return cell
}
