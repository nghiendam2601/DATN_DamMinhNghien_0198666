//
//  CreateList.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import UIKit

class CreateList: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblCreateList: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtListName: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: - Properties
    var onCreate: ((String, String) -> Void)?
    
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
        if let view = Bundle.main.loadNibNamed("CreateList", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "LabelApp")?.cgColor
            view.layer.cornerRadius = view.bounds.height / 7
            view.clipsToBounds = true
        }
        createButton.layer.cornerRadius = createButton.bounds.height / 2
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.red.cgColor
        createButton.titleLabel?.text = LanguageDictionary.createList.dictionary
        txtDescription.placeholder = LanguageDictionary.inputListDescription.dictionary
        txtListName.placeholder = LanguageDictionary.inputListName.dictionary
        lblDes.text = LanguageDictionary.listDescription.dictionary
        lblName.text = LanguageDictionary.listName.dictionary
        lblCreateList.text = LanguageDictionary.createList.dictionary
    }
    
    // MARK: Actions
    @IBAction func createButtonAction(_ sender: UIButton) {
        if let textFieldDes = txtDescription.text,
           let textFieldName = txtListName.text {
            onCreate?(textFieldName,textFieldDes)
        }
    }
    
}


