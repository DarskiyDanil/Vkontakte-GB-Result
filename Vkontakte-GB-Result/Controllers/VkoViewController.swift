//
//  ViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 03.04.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit

class VkoViewController: UIViewController {
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginVK: UITextField!
    @IBOutlet weak var passwordVK: UITextField!
    @IBOutlet weak var enterButtForm: UIScrollView! {
        didSet {
            enterButtForm.layer.cornerRadius = enterButtForm.frame.size.height/2
        }
    }
    @IBAction func enterBut(_ sender: Any) {
        if loginVK.text == "" && passwordVK.text == ""{
            
            performSegue(withIdentifier: "VkoSegue", sender: nil)
            
        } else {
            print("данные введены неверно")
            
            // Создаем контроллер
            let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
            // Создаем кнопку для UIAlertController
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            // Добавляем кнопку на UIAlertController
            alert.addAction(action)
            // Показываем UIAlertController
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе -- когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //   //     прячем панель вверху
        //        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //  //      прячем верхнюю панель
        //        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}

// МЕТОД делающий переход при определённых условиях
//override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//    // Проверяем данные
//    let checkResult = checkUserData()
//
//    // Если данные неверны, покажем ошибку
//    if !checkResult {
//        showLoginError()
//    }
//
//    // Вернем результат
//    return checkResult
//}
//
//func checkUserData() -> Bool {
//    guard let login = loginInput.text, let password = passwordInput.text else { return false }
//
//    if login == "admin" && password == "123456" {
//        return true
//    } else {
//        return false
//    }
//}
//
//func showLoginError() {
//    // Создаем контроллер
//    let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
//    // Создаем кнопку для UIAlertController
//    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//    // Добавляем кнопку на UIAlertController
//    alter.addAction(action)
//    // Показываем UIAlertController
//    present(alter, animated: true, completion: nil)
//}




