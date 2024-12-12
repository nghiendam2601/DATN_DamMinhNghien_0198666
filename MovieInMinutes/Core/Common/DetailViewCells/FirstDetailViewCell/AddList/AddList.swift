//
//  AddList.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import UIKit


class AddList: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var collection: MyCollectionModel?
    var onSelectAdd: ((Int) -> Void)?
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComponents()
    }
    
    // MARK: Setup methods
    fileprivate func initComponents() {
        if let view = Bundle.main.loadNibNamed("AddList", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "LabelApp")?.cgColor
            view.layer.cornerRadius = view.bounds.height / 7
            view.clipsToBounds = true
        }
        tableView.dataSource = self
        tableView.register(UINib(nibName: "YourCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "YourCollectionTableViewCell")
        if collection != nil {
            tableView.reloadData()
        }
    }
    
}

// MARK: - TableView
extension AddList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collection?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourCollectionTableViewCell") as? YourCollectionTableViewCell else { return UITableViewCell() }
        cell.label.text = collection?.results[indexPath.row].name
        cell.labelQuantity.text = "\(collection?.results[indexPath.row].itemCount ?? 0) \(LanguageDictionary.itemMovie.dictionary)"
        cell.lblDes.text = collection?.results[indexPath.row].description
        return cell
    }
    
}

extension AddList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectAdd?(indexPath.row)
    }
    
}
