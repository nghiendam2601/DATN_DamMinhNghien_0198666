//
//  SecondActorTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/11/24.
//

import UIKit

class SecondActorTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var deathDayTitle: UILabel!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var knowForTitle: UILabel!
    @IBOutlet weak var birthDayTitle: UILabel!
    @IBOutlet weak var placeOfBirth: UILabel!
    @IBOutlet weak var deathday: UILabel!
    @IBOutlet weak var knowFor: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var biography: UILabel!
    
    //MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(actor: ActorModel?) {
        birthDayTitle.text = LanguageDictionary.birthDay.dictionary
        placeTitle.text = LanguageDictionary.placeOfBirth.dictionary
        deathDayTitle.text = LanguageDictionary.deathDay.dictionary
        knowForTitle.text = LanguageDictionary.knownFor.dictionary
        bioTitle.text = LanguageDictionary.biography.dictionary
        
        placeOfBirth.text = actor?.placeOfBirth.isEmpty == false ? actor?.placeOfBirth : LanguageDictionary.noData.dictionary
        deathday.text = actor?.deathday.isEmpty == false ? actor?.deathday : LanguageDictionary.noData.dictionary
        knowFor.text = actor?.knownForDepartment.isEmpty == false ? actor?.knownForDepartment : LanguageDictionary.noData.dictionary
        birthday.text = actor?.birthday.isEmpty == false ? actor?.birthday : LanguageDictionary.noData.dictionary
        biography.text = actor?.biography.isEmpty == false ? actor?.biography : LanguageDictionary.noData.dictionary
    }
    
}
