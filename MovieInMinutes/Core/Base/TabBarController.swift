

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Gọi storyboard
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        tabbar.tintColor = .systemRed
        // Lấy view controller từ storyboard bằng Storyboard ID
        let moviesVC = UIStoryboard(name: "MovieViewController", bundle: nil).instantiateViewController(withIdentifier: "NavMovieViewController")
        moviesVC.tabBarItem = UITabBarItem(title: LanguageDictionary.movies.dictionary, image: UIImage(systemName: "movieclapper"), tag: 0)
        let tvSeriesVC = UIStoryboard(name: "TVSeriesViewController", bundle: nil).instantiateViewController(withIdentifier: "NavTVSeriesViewController")
        tvSeriesVC.tabBarItem = UITabBarItem(title: LanguageDictionary.tvSeries.dictionary, image: UIImage(systemName: "tv"), tag: 1)
        let searchVC = UIStoryboard(name: "SearchViewController", bundle: nil).instantiateViewController(withIdentifier: "NavSearchViewController")
        searchVC.tabBarItem = UITabBarItem(title: LanguageDictionary.search.dictionary, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        let personalVC = UIStoryboard(name: "PersonalViewController", bundle: nil).instantiateViewController(withIdentifier: "NavPersonalViewController")
        personalVC.tabBarItem = UITabBarItem(title: LanguageDictionary.personal.dictionary, image: UIImage(systemName: "person"), tag: 3)
        // Thêm các view controllers vào TabBarController
        setViewControllers([moviesVC,tvSeriesVC,searchVC,personalVC], animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageDidChange() {
        if let items = tabbar.items {
            items[0].title = LanguageDictionary.movies.dictionary
            items[1].title = LanguageDictionary.tvSeries.dictionary
            items[2].title = LanguageDictionary.search.dictionary
            items[3].title = LanguageDictionary.personal.dictionary
        }
    }
    
}
