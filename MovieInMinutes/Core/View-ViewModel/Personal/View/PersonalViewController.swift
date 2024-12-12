
import UIKit
import SafariServices

class PersonalViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var yourRatingsView: UIView!
    @IBOutlet weak var yourCollectionView: UIView!
    @IBOutlet weak var imgMyRatings: UIImageView!
    @IBOutlet weak var myProfile: UILabel!
    @IBOutlet weak var imgMyCollection: UIImageView!
    @IBOutlet weak var settingStack: UIStackView!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var switchSetting: UISwitch!
    @IBOutlet weak var switchLanguage: UISwitch!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var stackUser: UIStackView!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var personalStackView: UIStackView!
    @IBOutlet weak var suggestLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var btnGuest: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewLogo: UIImageView!
    
    //MARK: - Properties
    var personalViewModel = PersonalViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstUI()
        setupPersonalViewModel()
        setupSetting()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - Actions
extension PersonalViewController {
    
    @objc func languageDidChange() {
        updateLanguage()
    }
    @objc func appearanceDidChange() {
        updateAppearance()
    }
    
    @objc func handleTapYourCollection() {
        guard let vc = UIStoryboard(name: "YourCollectionViewController", bundle: nil).instantiateViewController(withIdentifier: "YourCollectionViewController") as? YourCollectionViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTapYourRatings() {
        guard let vc = UIStoryboard(name: "YourRatingsViewController", bundle: nil).instantiateViewController(withIdentifier: "YourRatingsViewController") as? YourRatingsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func switchSettingAction(_ sender: UISwitch) {
        let selectedAppearance: AppAppearance = sender.isOn ? .dark : .light
        SettingsManager.shared.currentAppearance = selectedAppearance
    }
    @IBAction func switchLanguageAction(_ sender: UISwitch) {
        let selectedLanguage: AppLanguage = sender.isOn ? .vietnamese : .english
        SettingsManager.shared.currentLanguage = selectedLanguage
        configImage()
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        personalViewModel.createRequestToken()
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        openSafari(urlString: "https://www.themoviedb.org/signup")
    }
    
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        personalViewModel.logout()
    }
    
    @IBAction func btnGuestAction(_ sender: UIButton) {
        let userGuest = UserModel(isGuest: true)
        RealmManager.shared.currentUser = userGuest
        guard let vc = UIStoryboard(name: "MovieViewController", bundle: nil).instantiateViewController(identifier: "TabbarController") as? TabBarController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configImage() {
        if SettingsManager.shared.currentLanguage == .vietnamese {
            imgMyRatings.image = UIImage(named: "myRatings2")
            imgMyCollection.image = UIImage(named: "myCollection2")
        } else {
            imgMyRatings.image = UIImage(named: "myRatings")
            imgMyCollection.image = UIImage(named: "myCollection")
        }
    }
}

//MARK: - Methods
extension PersonalViewController {
    
    func updateLanguage() {
        lblLanguage.text = SettingsManager.shared.currentLanguage.displayName
        lblSetting.text = SettingsManager.shared.currentAppearance.displayName
        myProfile.text = LanguageDictionary.myProfile.dictionary
        btnLogin.setTitle(LanguageDictionary.login.dictionary, for: .normal)
        btnLogout.setTitle(LanguageDictionary.logout.dictionary, for: .normal)
        btnSignUp.setTitle(LanguageDictionary.signUp.dictionary, for: .normal)
        btnGuest.setTitle(LanguageDictionary.guest.dictionary, for: .normal)
        
        title = LanguageDictionary.personal.dictionary
    }
    
    func updateAppearance() {
        SettingsManager.shared.setupAppearance()
        lblSetting.text = SettingsManager.shared.currentAppearance.displayName
        var newColor = UIColor.black
        switch SettingsManager.shared.currentAppearance {
        case .light:
            newColor = UIColor.black
        case .dark:
            newColor = UIColor.white
        }
//        yourRatingsView.backgroundColor = newColor.withAlphaComponent(0.8)
//        yourCollectionView.backgroundColor = newColor.withAlphaComponent(0.8)
//        yourRatingsView.layer.borderColor = newColor.cgColor
//        yourCollectionView.layer.borderColor = newColor.cgColor
        settingStack.layer.borderColor = newColor.cgColor
    }
    func setupFirstUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapYourRatings))
        yourRatingsView.addGestureRecognizer(tapGesture)
        let tapGestureCollection = UITapGestureRecognizer(target: self, action: #selector(handleTapYourCollection))
        yourCollectionView.addGestureRecognizer(tapGestureCollection)
        navigationController?.isNavigationBarHidden = true
        configImage()
        if let user = RealmManager.shared.currentUser {
            if user.isGuest {
                setupGuestView()
            } else {
                setupUser()
            }
        } else {
            setupLoginView()
        }
    }
    
    func setupUser() {
        loginView.isHidden = true
        personalStackView.isHidden = false
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        guard let user = RealmManager.shared.currentUser else { return }
        userID.text = "\(user.id)"
        userName.text = user.username
        btnLogout.layer.cornerRadius = btnLogout.frame.height/2
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = UIColor.red.cgColor
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullURL = baseURL + user.tmdbAvatarPath
        ImageLoader.loadImage(for: avatarImage, from: fullURL)
    }
    
    func setupGuestView() {
        commonSetup()
        btnGuest.isHidden = true
        suggestLabel.text = NSLocalizedString("loginSuggest", comment: "")
    }
    
    func setupLoginView() {
        commonSetup()
        suggestLabel.isHidden = true
    }
    
    func commonSetup() {
        btnGuest.layer.cornerRadius = btnGuest.frame.height/2
        btnGuest.layer.borderWidth = 1
        btnGuest.layer.borderColor = UIColor(named: "LabelApp")?.cgColor
        btnLogin.layer.cornerRadius = btnLogin.frame.height/2
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.red.cgColor
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor.red.cgColor
        btnSignUp.layer.cornerRadius = btnSignUp.frame.height/2
        viewLogo.layer.cornerRadius = viewLogo.bounds.height / 5.5
        viewLogo.clipsToBounds = true
    }
    
    func setupPersonalViewModel() {
        personalViewModel.onCreateRequestTokenSuccessed = { [weak self] token in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.openSafari(urlString: "https://www.themoviedb.org/authenticate/\(token)?redirect_to=MovieInMinutes://")
                AppConstant.isFromSafari = true
            }
        }
        
        personalViewModel.onLoginSuccessed = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.setRootToLogin()
            }
        }
        
        personalViewModel.onFailed = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.failedCreateRequestToken.dictionary, message: message)
            }
        }
    }
    
    func openSafari(urlString: String) {
        let authURL = URL(string: urlString)!
        UIApplication.shared.open(authURL, options: [:]) { _ in }
    }
    
    func setRootToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("No active window found")
            return
        }
        
        // Hiển thị loading indicator
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Tạo màn hình đăng nhập
            let loginViewController = UIStoryboard(name: "PersonalViewController", bundle: nil)
                .instantiateViewController(withIdentifier: "NavPersonalViewController")
            // Cập nhật rootViewController
            window.rootViewController = loginViewController
            window.makeKeyAndVisible()
            // Ẩn loading indicator
            LoadingManager.shared.hideLoadingIndicator()
            AppConstant.isLoading = false
        }
    }
    
    func setupSetting() {
        imgMyRatings.layer.cornerRadius = imgMyRatings.bounds.height / 7
        imgMyRatings.layer.borderWidth = 1
        imgMyCollection.layer.cornerRadius = imgMyCollection.bounds.height / 7
        imgMyCollection.layer.borderWidth = 1
        yourRatingsView.layer.cornerRadius = yourRatingsView.bounds.height / 7
        yourRatingsView.layer.borderWidth = 1
        yourCollectionView.layer.cornerRadius = yourCollectionView.bounds.height / 7
        yourCollectionView.layer.borderWidth = 1
        settingStack.layer.cornerRadius = settingStack.bounds.height / 7
        settingStack.layer.borderWidth = 1
        switchSetting.isOn = (SettingsManager.shared.currentAppearance == .dark)
        switchLanguage.isOn = (SettingsManager.shared.currentLanguage == .vietnamese)
        updateLanguage()
        updateAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (appearanceDidChange), name: .appearanceChanged, object: nil)
    }
    
}

