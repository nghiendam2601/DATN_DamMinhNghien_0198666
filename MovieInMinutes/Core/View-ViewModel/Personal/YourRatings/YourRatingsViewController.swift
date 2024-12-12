//
//  YourRatingsViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 23/11/24.
//

import Tabman
import Pageboy

class YourRatingsViewController: TabmanViewController {
    
    //MARK: - Properties
    private var viewControllers: [UIViewController] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .red
        title = LanguageDictionary.myRating.dictionary
        setupPageView()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func languageDidChange() {
        title = LanguageDictionary.myRating.dictionary
    }
    //MARK: - SetupPageView
    func setupPageView() {
        guard let MoviesVC = UIStoryboard(name: "RatingsMoviesViewController", bundle: nil).instantiateViewController(identifier: "RatingsMoviesViewController") as? RatingsMovieViewController else { return }
        
        guard let TVSeriesVC = UIStoryboard(name: "RatingsTVSeriesViewController", bundle: nil).instantiateViewController(identifier: "RatingsTVSeriesViewController") as? RatingsTVSeriesViewController else { return }
        viewControllers = [MoviesVC, TVSeriesVC]
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 0
        bar.layout.alignment = .centerDistributed
        bar.buttons.customize { button in
            button.tintColor = .labelApp
            button.selectedTintColor = .labelApp
            button.backgroundColor = .background
        }
        bar.indicator.tintColor = .red
        addBar(bar, dataSource: self, at: .top)
    }
    
}

// MARK: - PageboyViewControllerDataSource
extension YourRatingsViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
    
}

// MARK: - Tabman Bar DataSource
extension YourRatingsViewController: TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let titles = [LanguageDictionary.movies.dictionary,LanguageDictionary.tvSeries.dictionary]
        let barItem = TMBarItem(title: titles[index])
        return barItem
    }
    
}
