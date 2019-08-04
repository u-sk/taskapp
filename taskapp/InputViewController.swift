//
//  InputViewController.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/07/25.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var contentsTextView: UITextView!

    @IBOutlet weak var datePicker: UIDatePicker!
 
//    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let realm = try! Realm()
    // taskを定義
    var task: Task!
    
    // DB内のタスクが格納されるリスト。
    // 以降内容をアップデートするとリスト内は自動的に更新される。
//    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "id" , ascending: false)
    
    // pickerViewデータリスト
    var dataList = ["勉強", "遊び", "買い物"]

     // pickerViewで選択した要素の入れ物
     var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // pickerViewDelegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 選択された項目を初期表示
        if task.category == "勉強" {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        } else if task.category ==  "遊び" {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        } else if task.category ==  "買い物" {  
            pickerView.selectRow(2, inComponent: 0, animated: false)
        }
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        // カテゴリーを追加
//        categoryTextField.text = task.category
        
        
    }
 
    // 遷移元に戻る際にタスクの内容をデータベースに保存する
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            // カテゴリーを追加
            self.task.category = self.selectedCategory
            self.realm.add(self.task, update: true)

            // Realmデータベースファイルまでのパスを表示
             print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        setNotification(task: task)   // 追加
        
        super.viewWillDisappear(animated)
    }
 
    // PickerViewに関して
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 処理
        print(" \(dataList[row]) が選択された。")
//        categoryTextField.text = dataList[row]
        selectedCategory = dataList[row]
        
    }
    
    // タスクのローカル通知を登録する --- ここから ---
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    } // --- ここまで追加 ---
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
