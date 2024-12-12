
import UIKit
import IQKeyboardToolbarManager

class SearchViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var searchTimer: Timer?
    var searchViewModel = SearchViewModel()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageDictionary.suggestSearch.dictionary
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK: - Setup methods
extension SearchViewController {
    
    func setupFirstLoad() {
        title = LanguageDictionary.search.dictionary
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        collectionView.register(UINib(nibName: Identifier.actorCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifier.actorCollectionViewCell)
        setupSearchViewModel()
    }
    
    func setupUI() {
        textField.placeholder = LanguageDictionary.searchHere.dictionary
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = textField.bounds.height / 2
        let leftImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftImageView.tintColor = .red
        leftImageView.contentMode = .center
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImageView.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        leftView.addSubview(leftImageView)
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupSearchViewModel() {
        searchViewModel.onSearchCompleted = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if weakSelf.searchViewModel.searchResultArray?.isEmpty == true {
                    weakSelf.messageLabel.text = LanguageDictionary.noData.dictionary
                    weakSelf.messageLabel.isHidden = false
                } else {
                    weakSelf.messageLabel.isHidden = true
                }
                weakSelf.collectionView.reloadData()
            }
        }
        searchViewModel.onSearchFailed = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func btnSearchAction(_ sender: UIButton) {
    }
    
    @objc func languageDidChange() {
        title = LanguageDictionary.search.dictionary
        messageLabel.text = LanguageDictionary.suggestSearch.dictionary
        textField.placeholder = LanguageDictionary.searchHere.dictionary
        guard let query = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if !query.isEmpty {
            searchViewModel.searchMulti(query: query)
        }
    }
    
}

//MARK: - CollectionView
extension SearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchViewModel.searchResultArray?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.actorCollectionViewCell, for: indexPath) as? ActorCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureSearchCell(type: searchViewModel.searchResultArray?[indexPath.row].1 ?? "", model: searchViewModel.searchResultArray?[indexPath.row].0 as Any)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let actor = searchViewModel.searchResultArray?[indexPath.row].0 as? ActorModel {
            let vc = UIStoryboard(name: "ActorDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ActorDetailViewController") as! ActorDetailViewController
            vc.id = actor.id
            navigationController?.pushViewController(vc, animated: true)
        } else if let movie = searchViewModel.searchResultArray?[indexPath.row].0 as? MovieModel {
            let vc = UIStoryboard(name: "DetailMovieViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
            vc.movieID = movie.id
            navigationController?.pushViewController(vc, animated: true)
        } else if let tvSeries = searchViewModel.searchResultArray?[indexPath.row].0 as? TVSeriesModel {
            let vc = UIStoryboard(name: "DetailTVSeriesViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailTVSeriesViewController") as! DetailTVSeriesViewController
            vc.tvSeriesID = tvSeries.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.bounds.width - 16)/3)
        print(itemWidth)
        print(collectionView.bounds.width)
        return CGSize(width: itemWidth, height: itemWidth * 235/125)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Hủy bỏ timer hiện tại (nếu có)
        searchTimer?.invalidate()
        // Tạo một timer mới
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let query = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let weakSelf = self else { return }
            
            if !query.isEmpty {
                weakSelf.searchViewModel.searchMulti(query: query)
            } else {
                weakSelf.searchViewModel.searchResultArray = nil
                weakSelf.messageLabel.isHidden = false
                weakSelf.messageLabel.text = LanguageDictionary.suggestSearch.dictionary
                weakSelf.collectionView.reloadData()
            }
        }
    }
    
}
