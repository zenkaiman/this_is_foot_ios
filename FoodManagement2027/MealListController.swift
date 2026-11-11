//
//  MealListController.swift
//  FoodManagement2027
//
//  Created by User on 04.11.2026.
//

import UIKit

class MealListController: UIViewController {
    // MARK: - Properties
    // Datasource cho table view
    private var mealList = [Meal]()
    private let reuseCell = "myTableView"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Them du lieu mau cho datasource
        if let meal1 = Meal(nameMeal: "Ca Ran", image: UIImage(named: "default"), rating: 3) {
            mealList.append(meal1)
        }
        
        // 2. Dang ky myCell (xib) cho doi tuong table view
        let cellNib = UINib(nibName: "myCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: reuseCell)
        
        // 3. Thuc hien uy quyen cho doi tuong table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // 4. Thiet lap chieu cao cho moi dong
        tableView.rowHeight = 90
        
        // Them button edit bang code cho navigation bar
        // Lay navigationItem trong navigationbar
        if let navigationItem = navigationBar?.topItem {
            // Dua editButtonItem vao navigationItem ben trai
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    // Dinh nghia lai ham setEditing (phai nam trong class, khong duoc de trong extension)
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Chuyen chuc nang cho tableView
        tableView.setEditing(editing, animated: animated)
    }
    
    // Xu ly truoc khi chuyen man hinh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Xu ly callBack tu man hinh B
        if let detailController = segue.destination as? MealDetailController {
            detailController.getBackData = { (meal:Meal) in
                // Cap nhat vao TableView
                // 3.1 Tim vi tri de chen mon an moi trong TableView
                let newIndexPath = IndexPath(row: self.mealList.count, section: 0)
                // 3.2 Dua mon an moi vao mealList
                self.mealList.append(meal)
                // 3.3 Cap nhat len tableView
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}

// MARK: - Cac ham uy quyen cua Table View (UITableViewDelegate, UITableViewDataSource)
extension MealListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? myCell {
            // Lay du lieu can do vao tableview tu datasource
            let meal = mealList[indexPath.row]
            cell.mealImage.image = meal.image
            cell.mealName.text = meal.nameMeal
            cell.mealRating.rating = meal.rating
            
            return cell
        } else {
            // Tra ve cell rong neu khong ep kieu duoc
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Xoa du lieu trong datasource
            mealList.remove(at: indexPath.row)
            // Xoa phan tu trong tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Xu ly chuyen man hinh khi edit mon an
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Ban vua chon mon an thu: \(indexPath.row)")
        // Bo chon moi khi select row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 1. Lay meal tai vi tri chon
        let meal = mealList[indexPath.row]
        
        // Tao man hinh Detail tu storyboard (Storyboard ID: MealDetailController)
        if let detailController = storyboard?.instantiateViewController(withIdentifier: "MealDetailController") as? MealDetailController {
            // 2. Truyen meal sang man hinh Detail
            // (Buoc 4 - cap nhat meal len giao dien - nam trong viewDidLoad cua MealDetailController)
            detailController.meal = meal
            
            // Xu ly callBack tu man hinh Detail
            // (Buoc 5 - truyen lai meal da duoc sua ve - nam trong ham save cua MealDetailController)
            detailController.getBackData = { (newMeal:Meal) in
                // 6. Cap nhat meal moi cho man hinh list
                // 6.1 Thay meal cu bang meal da duoc sua trong mealList
                self.mealList[indexPath.row] = newMeal
                // 6.2 Cap nhat lai dong do len tableView
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            // 3. Chuyen man hinh sang Detail
            detailController.modalPresentationStyle = .fullScreen
            present(detailController, animated: true)
        }
    }
    
    // MARK: Quay ve tu man hinh DetailController
    @IBAction func unWindFromDetailController(segue: UIStoryboardSegue) {
        //print("Quay ve tu DetailController")
        // 3. Cap nhat mon an tu man hinh meal detail ve
        // Lay toan bo man hinh mealdetail va lay gia tri meal vua tao
        if let mealDetailController = segue.source as? MealDetailController, let meal = mealDetailController.meal {
            // Cap nhat vao TableView
            // 3.1 Tim vi tri de chen mon an moi trong TableView
            let newIndexPath = IndexPath(row: mealList.count, section: 0)
            // 3.2 Dua mon an moi vao mealList
            mealList.append(meal)
            // 3.3 Cap nhat len tableView
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
}
