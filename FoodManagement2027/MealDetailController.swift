//
//  ViewController.swift
//  FoodManagement2027
//
//  Created by  User on 28.10.2026.
//

import UIKit

//B1. Xac dinh Protocal chua ham uy quyen cho TextField => UITextFieldDelegate
class MealDetailController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var Imager: UIImageView!
    @IBOutlet weak var edtMealName: UITextField!
    @IBOutlet weak var mealRating: UIRating!
    //bien dung de truyen tham so meal giua man hinh a va b
    var meal:Meal?
    
    // Dinh nghia callBack quay ve man hinh A
    var getBackData:((Meal)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //B3. Thuc hien ham uy quyen cho doi tuong TextField
        edtMealName.delegate = self
        
        // (Buoc 4 khi sua mon an) Cap nhat meal len giao dien neu man hinh list co truyen meal sang
        if let meal = meal {
            edtMealName.text = meal.nameMeal
            mealRating.rating = meal.rating
            //Mon an khong co anh thi giu nguyen anh mac dinh
            if let image = meal.image {
                Imager.image = image
            }
        }
    }

    //MARK: Dinh nghia cac ham uy quyen cho doi tuong TextField
    //B2. Dinh nghia ham uy quyen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("Called")
        edtMealName.resignFirstResponder()
        return true
    }
    
    
    //Ham lay du lieu ra khoi textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("ten mon an la: \(textField.text!)")
    }
    
    //MARK: Ham Xu Li Chon Anh Tu Thu Vien Anh
    
    @IBAction func imagePicker(_ sender: UITapGestureRecognizer) {
        //print("called")
        //An ban phim neu co
        edtMealName.resignFirstResponder()
        //Tao doi tuong UIImagePickerController
        let imagePicker = UIImagePickerController()
        //Cau hinh cho doi tuong imagePicker
        imagePicker.sourceType = .photoLibrary
        
        //thuc hien thao tac uy quyen cho doi tuong imagePicker
        imagePicker.delegate = self
        
        //cau hinh cho imagepicker hien thi full screen
        imagePicker.modalPresentationStyle = .fullScreen
        
        // Chuyen dieu khien sang man hinh imagePicker
        present(imagePicker, animated: true)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //Ham duoc goi truoc khi chuyen man hinh => chuan bi du lieu can truyen di
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Chi tao mon an khi quay ve man hinh danh sach (nhan Save), bo qua cac segue khac (vd: Go To Map)
        guard segue.destination is MealListController else {
            return
        }
        
        // 1.tao mon an tu thong tin nguoi dung nhap vao
        let name = edtMealName.text ?? ""
        let meal = Meal(nameMeal: name, image: Imager.image, rating: mealRating.rating)
        //2. dua  doi tuong vua tao vao bien thanh phan de truyen di
        self.meal = meal
    }
    
    // Tao moi (hoac sua) mon an va quay ve A
    @IBAction func save(_ sender: UIBarButtonItem) {
        // 1. Tao mon an tu thong tin nguoi dung nhap vao
        let name = edtMealName.text ?? ""
        if let meal = Meal(nameMeal: name, image: Imager.image, rating: mealRating.rating) {
            // Goi callBack de truyen du lieu nguoc ve A
            // (Buoc 5 khi sua mon an) Truyen lai meal da duoc sua ve man hinh list
            getBackData?(meal)
        }
        
        // An man hinh hien tai
        dismiss(animated: true)
    }
}
//MARK: mo rong cho cac hm uy quyen cua UIImagePickerController
extension MealDetailController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //an man hinh hien tai => quay ve man hinh truoc
        dismiss(animated: true)
    }
    // ham xu ly anh lay ve tu inmagepicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // xy ly anh chon duoc
        if  let selectedImage = info[.originalImage], let image = selectedImage as? UIImage{
            Imager.image = image
        }
        
        // anh man hinh hien tai => quay ve man hinh trc do
        dismiss(animated: true)
    }
}
