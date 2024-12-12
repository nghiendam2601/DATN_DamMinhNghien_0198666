//
//  RatingsTVSeriesViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 24/11/24.
//

import UIKit

class RatingsTVSeriesViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var ratingsTVSeriesViewModel = RatingsTVSeriesViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func languageDidChange() {
        ratingsTVSeriesViewModel.fetchRatedListTVSeries()
    }
    //MARK: setupFirstLoad
    func setupFirstLoad() {
        tableView.register(UINib(nibName: "YourItemTableViewCell", bundle: nil), forCellReuseIdentifier: "YourItemTableViewCell")
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.ratingsTVSeriesViewModel.fetchRatedListTVSeries()
        }
        ratingsTVSeriesViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        ratingsTVSeriesViewModel.onFetchRatedListTVSeries = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        ratingsTVSeriesViewModel.fetchRatedListTVSeries()
    }
    
}

//MARK: - TableView
extension RatingsTVSeriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingsTVSeriesViewModel.listTVSeries?.count ?? 0 // Trả về 0 nếu danh sách là nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Kiểm tra nếu listTVSeries có giá trị tại indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourItemTableViewCell", for: indexPath) as? YourItemTableViewCell,
              let tvSeries = ratingsTVSeriesViewModel.listTVSeries?[indexPath.row] else {
            return UITableViewCell() // Trả về cell trống nếu dữ liệu không có
        }
        cell.configureCellTVSeries(tvSeries: tvSeries)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tvSeries = ratingsTVSeriesViewModel.listTVSeries?[indexPath.row] {
            guard let vc = UIStoryboard(name: Identifier.detailTVSeriesViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailTVSeriesViewController) as? DetailTVSeriesViewController else { return }
            vc.tvSeriesID = tvSeries.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

