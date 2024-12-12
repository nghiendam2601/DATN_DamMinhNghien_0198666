//
//  ReviewViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 26/11/24.
//

import UIKit

class ReviewViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tablevView: UITableView!
    
    // MARK: - Properties
    var movie: MovieModel?
    var tvSeries: TVSeriesModel?
    var reviewViewModel = ReviewViewModel() 
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstReview()
        setupReviewViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageDidChange() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Setup methods
extension ReviewViewController {
    
    func setupReviewViewModel() {
        reviewViewModel.onFetchFailed = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
            }
        }
        reviewViewModel.onFetchSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tablevView.reloadData()
            }
        }
    }
    
    func setupFirstReview() {
        registerTableView(tablevView, identifier: "ReviewTableViewCell")
        if let movie = movie {
            guard let year = DateFormatter.yearString(from: movie.releaseDate) else { return }
            reviewViewModel.fetchYouTubeVideo(keyword: "\(LanguageDictionary.reviewMovie.dictionary) \(movie.originalTitle) \(year)")
            print("\(LanguageDictionary.reviewMovie.dictionary) \(movie.title) \(year)")
        } else if let tvSeries = tvSeries {
            guard let year = DateFormatter.yearString(from: tvSeries.firstAirDate) else { return }
            reviewViewModel.fetchYouTubeVideo(keyword: "Review \(tvSeries.originalTitle) \(year)")
            print("Review \(tvSeries.originalTitle) \(year)")
        }
    }
    
}

// MARK: - TableView
extension ReviewViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewViewModel.video?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.setupData(video: reviewViewModel.video?[indexPath.row])
        return cell
    }
    
}
