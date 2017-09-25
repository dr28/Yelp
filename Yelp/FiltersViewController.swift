//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filterViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
    @objc optional func filterMapViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])

}

class FiltersViewController: UIViewController, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let yelpFilters:[String] = ["", "Distance", "Sort By", "Category"]
    fileprivate var stateArray = [false, false, false, false]

    fileprivate var selectedDistanceIndex = 0
    fileprivate var selectedSortIndex: Int = 0

    fileprivate var selectedSort = 0
    fileprivate var selectedDistance = 0
    
    fileprivate var categories: [[String:String]]? = nil
    fileprivate var switchStates = [Int:Bool] ()
    fileprivate var tableStructure: [[[String: String]]]? = nil

    fileprivate var selectedDeal = false

    fileprivate var showAllCategory = false
    
    weak var delegate:FiltersViewControllerDelegate?
    
    fileprivate var filters = [String: AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.isTranslucent=false
        navigationController!.navigationBar.barTintColor = ThemeManager.currentTheme().mainColor
        navigationController!.navigationBar.tintColor = ThemeManager.currentTheme().backgroundColor

        let titleColor = ThemeManager.currentTheme().backgroundColor
        let attributes: [String: AnyObject] = [NSForegroundColorAttributeName: titleColor]
        navigationController!.navigationBar.titleTextAttributes = attributes

        categories = yelpCategories()

        tableView.dataSource = self
        tableView.delegate = self

        tableStructure = [ yelpDeal(), yelpDistances(), yelpSortBy(), yelpCategories()  ]

        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
    

    }
    
    
    @IBAction func onCancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func onSearchButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

        //var 
        filters = [String: AnyObject]()

        var selectedCategories = [String]()
        
        for(row, isSelected) in switchStates {
            
            if isSelected {
                
                selectedCategories.append((categories?[row]["code"]!)!)
            }
                    
        }
        
        if selectedCategories.count > 0 {
            filters[Constants.filterCategories] = selectedCategories as AnyObject
            
        }
        
        filters[Constants.filterDeals] = selectedDeal as AnyObject
        filters[Constants.filterSort] = selectedSort as AnyObject
        filters[Constants.filterDistance] = selectedDistance as AnyObject

        
        delegate?.filterViewController?(filterViewController: self, didUpdateFilters: filters)
        delegate?.filterMapViewController?(filterViewController: self, didUpdateFilters: filters)
    }
    
 
    fileprivate func yelpCategories() -> [[String : String]] {
        
    
        return [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"],
                      ["name" : "Bavarian", "code": "bavarian"],
                      ["name" : "Beer Garden", "code": "beergarden"],
                      ["name" : "Beer Hall", "code": "beerhall"],
                      ["name" : "Beisl", "code": "beisl"],
                      ["name" : "Belgian", "code": "belgian"],
                      ["name" : "Bistros", "code": "bistros"],
                      ["name" : "Black Sea", "code": "blacksea"],
                      ["name" : "Brasseries", "code": "brasseries"],
                      ["name" : "Brazilian", "code": "brazilian"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                      ["name" : "British", "code": "british"],
                      ["name" : "Buffets", "code": "buffets"],
                      ["name" : "Bulgarian", "code": "bulgarian"],
                      ["name" : "Burgers", "code": "burgers"],
                      ["name" : "Burmese", "code": "burmese"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Cajun/Creole", "code": "cajun"],
                      ["name" : "Cambodian", "code": "cambodian"],
                      ["name" : "Canadian", "code": "New)"],
                      ["name" : "Canteen", "code": "canteen"],
                      ["name" : "Caribbean", "code": "caribbean"],
                      ["name" : "Catalan", "code": "catalan"],
                      ["name" : "Chech", "code": "chech"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                      ["name" : "Chicken Shop", "code": "chickenshop"],
                      ["name" : "Chicken Wings", "code": "chicken_wings"],
                      ["name" : "Chilean", "code": "chilean"],
                      ["name" : "Chinese", "code": "chinese"],
                      ["name" : "Comfort Food", "code": "comfortfood"],
                      ["name" : "Corsican", "code": "corsican"],
                      ["name" : "Creperies", "code": "creperies"],
                      ["name" : "Cuban", "code": "cuban"],
                      ["name" : "Curry Sausage", "code": "currysausage"],
                      ["name" : "Cypriot", "code": "cypriot"],
                      ["name" : "Czech", "code": "czech"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                      ["name" : "Danish", "code": "danish"],
                      ["name" : "Delis", "code": "delis"],
                      ["name" : "Diners", "code": "diners"],
                      ["name" : "Dumplings", "code": "dumplings"],
                      ["name" : "Eastern European", "code": "eastern_european"],
                      ["name" : "Ethiopian", "code": "ethiopian"],
                      ["name" : "Fast Food", "code": "hotdogs"],
                      ["name" : "Filipino", "code": "filipino"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Galician", "code": "galician"],
                      ["name" : "Gastropubs", "code": "gastropubs"],
                      ["name" : "Georgian", "code": "georgian"],
                      ["name" : "German", "code": "german"],
                      ["name" : "Giblets", "code": "giblets"],
                      ["name" : "Gluten-Free", "code": "gluten_free"],
                      ["name" : "Greek", "code": "greek"],
                      ["name" : "Halal", "code": "halal"],
                      ["name" : "Hawaiian", "code": "hawaiian"],
                      ["name" : "Heuriger", "code": "heuriger"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                      ["name" : "Hot Dogs", "code": "hotdog"],
                      ["name" : "Hot Pot", "code": "hotpot"],
                      ["name" : "Hungarian", "code": "hungarian"],
                      ["name" : "Iberian", "code": "iberian"],
                      ["name" : "Indian", "code": "indpak"],
                      ["name" : "Indonesian", "code": "indonesian"],
                      ["name" : "International", "code": "international"],
                      ["name" : "Irish", "code": "irish"],
                      ["name" : "Island Pub", "code": "island_pub"],
                      ["name" : "Israeli", "code": "israeli"],
                      ["name" : "Italian", "code": "italian"],
                      ["name" : "Japanese", "code": "japanese"],
                      ["name" : "Jewish", "code": "jewish"],
                      ["name" : "Kebab", "code": "kebab"],
                      ["name" : "Korean", "code": "korean"],
                      ["name" : "Kosher", "code": "kosher"],
                      ["name" : "Kurdish", "code": "kurdish"],
                      ["name" : "Laos", "code": "laos"],
                      ["name" : "Laotian", "code": "laotian"],
                      ["name" : "Latin American", "code": "latin"],
                      ["name" : "Live/Raw Food", "code": "raw_food"],
                      ["name" : "Lyonnais", "code": "lyonnais"],
                      ["name" : "Malaysian", "code": "malaysian"],
                      ["name" : "Meatballs", "code": "meatballs"],
                      ["name" : "Mediterranean", "code": "mediterranean"],
                      ["name" : "Mexican", "code": "mexican"],
                      ["name" : "Middle Eastern", "code": "mideastern"],
                      ["name" : "Milk Bars", "code": "milkbars"],
                      ["name" : "Modern Australian", "code": "modern_australian"],
                      ["name" : "Modern European", "code": "modern_european"],
                      ["name" : "Mongolian", "code": "mongolian"],
                      ["name" : "Moroccan", "code": "moroccan"],
                      ["name" : "New Zealand", "code": "newzealand"],
                      ["name" : "Night Food", "code": "nightfood"],
                      ["name" : "Norcinerie", "code": "norcinerie"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches"],
                      ["name" : "Oriental", "code": "oriental"],
                      ["name" : "Pakistani", "code": "pakistani"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes"],
                      ["name" : "Parma", "code": "parma"],
                      ["name" : "Persian/Iranian", "code": "persian"],
                      ["name" : "Peruvian", "code": "peruvian"],
                      ["name" : "Pita", "code": "pita"],
                      ["name" : "Pizza", "code": "pizza"],
                      ["name" : "Polish", "code": "polish"],
                      ["name" : "Portuguese", "code": "portuguese"],
                      ["name" : "Potatoes", "code": "potatoes"],
                      ["name" : "Poutineries", "code": "poutineries"],
                      ["name" : "Pub Food", "code": "pubfood"],
                      ["name" : "Rice", "code": "riceshop"],
                      ["name" : "Romanian", "code": "romanian"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                      ["name" : "Rumanian", "code": "rumanian"],
                      ["name" : "Russian", "code": "russian"],
                      ["name" : "Salad", "code": "salad"],
                      ["name" : "Sandwiches", "code": "sandwiches"],
                      ["name" : "Scandinavian", "code": "scandinavian"],
                      ["name" : "Scottish", "code": "scottish"],
                      ["name" : "Seafood", "code": "seafood"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                      ["name" : "Singaporean", "code": "singaporean"],
                      ["name" : "Slovakian", "code": "slovakian"],
                      ["name" : "Soul Food", "code": "soulfood"],
                      ["name" : "Soup", "code": "soup"],
                      ["name" : "Southern", "code": "southern"],
                      ["name" : "Spanish", "code": "spanish"],
                      ["name" : "Steakhouses", "code": "steak"],
                      ["name" : "Sushi Bars", "code": "sushi"],
                      ["name" : "Swabian", "code": "swabian"],
                      ["name" : "Swedish", "code": "swedish"],
                      ["name" : "Swiss Food", "code": "swissfood"],
                      ["name" : "Tabernas", "code": "tabernas"],
                      ["name" : "Taiwanese", "code": "taiwanese"],
                      ["name" : "Tapas Bars", "code": "tapas"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                      ["name" : "Tex-Mex", "code": "tex-mex"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
    }

    fileprivate func yelpDistances() -> [[String : String]] {
        
        
        return [["name" : "Auto", "code": "1"],
                ["name" : "0.3 miles", "code": "0.3"],
                ["name" : "1 miles", "code": "1"],
                ["name" : "5 miles", "code": "5"],
                ["name" : "20 miles", "code": "20"]]
    }

    
    fileprivate func yelpSortBy() -> [[String : String]] {
        
        
        return [["name" : "Best Match", "code": "0"],
                ["name" : "Distance", "code": "1"],
                ["name" : "Highest Rated", "code": "2"]]
    }
    
    fileprivate func yelpDeal() -> [[String : String]] {
        
        
        return [["name" : "Offering a Deal", "code": "true"]]
    }

}

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value:  Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        if(indexPath.section == 3) {
            switchStates[indexPath.row] = value
            
        }
        else{
            selectedDeal = value
        }
        
    }


}


// MARK: - TableView Datasource and Delegate methods

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return yelpFilters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return yelpFilters[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stateArray[section] {
            return tableStructure![section].count
        } else {
            if section == 3
            {
                if !showAllCategory {
                    return 4
                }
                else {
                    return tableStructure![section].count
                }
            }
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        
        for view in (headerView.subviews) {
            view.removeFromSuperview()
        }
        
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 25, width: tableView.frame.size.width, height: 20))
        
        let titleFont = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        titleLabel.font = titleFont
        titleLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        titleLabel.textColor = UIColor.black
        
        headerView.layer.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor.cgColor

        headerView.addSubview(titleLabel)
        
        return headerView
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0, 3: // Switch Cells
            
            if indexPath.row != 3 || showAllCategory {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.switchReuseIdentifier, for: indexPath) as! SwitchCell
                
                
                cell.switchLabel.text = tableStructure?[indexPath.section][indexPath.row]["name"]
                cell.delegate = self
                                
                if indexPath.section == 3 {
                    cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
                }
                else
                {
                    cell.onSwitch.isOn = selectedDeal
                }
                
                cell.selectionStyle = .none
                
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.seeAllReuseIdentifier, for: indexPath)
                
                return cell
                
            }
        case 1, 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dropReuseIdentifier, for: indexPath) as! DropDownCell
            cell.dropDownLabel.text = tableStructure?[indexPath.section][indexPath.row]["name"]
            
            if (!stateArray[indexPath.section]) {
                cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
                
            }
            else{
                var selectedValueIndex = 0
                if indexPath.section == 1 {
                    selectedValueIndex = selectedDistanceIndex
                    
                }
                else {
                    selectedValueIndex = selectedSortIndex
                    
                }
                if (indexPath.row == selectedValueIndex) {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                    
                }
                else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                    
                }
            }
            
            
            return cell
            
        default :
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 || indexPath.section == 2) {
            
            let cell = tableView.cellForRow(at: indexPath)!
            
            stateArray[indexPath.section] = !stateArray[indexPath.section]
            
            if (stateArray[indexPath.section]) {
                
                tableStructure?.remove(at: indexPath.section)
                
                if indexPath.section == 1 {
                    tableStructure?.insert(yelpDistances(), at: indexPath.section)
                    
                    
                } else if indexPath.section == 2 {
                    tableStructure?.insert(yelpSortBy(), at: indexPath.section)
                
                }
            }
            else {
                if indexPath.section == 1 {
                    
                    selectedDistanceIndex = indexPath.row
                }
                else{
                    selectedSortIndex = indexPath.row
                }
                
            }
            
            let selectedfilter = tableStructure?[indexPath.section]

            let selectedRec = selectedfilter?[indexPath.row]
            
            if indexPath.section == 1 {
                
                let selDistance = Double.init(yelpDistances()[indexPath.row]["code"]!)!
                
                let milesPerMeter = 0.000621371
                
                selectedDistance = Int(selDistance / milesPerMeter)
                
            }
            else {
                selectedSort = Int.init(yelpSortBy()[indexPath.row]["code"]!)!
            }
            
            tableStructure?[indexPath.section].remove(at: indexPath.row)
            tableStructure?[indexPath.section].insert(selectedRec!, at: 0)

            cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
            
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
        
        }
        else if (indexPath.section == 3 && indexPath.row == 3 && !showAllCategory) {
            
            showAllCategory = !showAllCategory
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
            
        }
    }
}
