//
//  ViewController.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/07/25.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchText: UISearchBar!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // サーチバー初期設定
        searchText.delegate = self
        searchText.placeholder = "カテゴリーを入力してください"
        
        // Categoryクラスに関して、realmに初期値として追加するデータを用意
        // id = 4以降はMakeCategoryViewControllerで新規作成する予定
//        let categoryData1 = Category()
//        categoryData1.id = 1
//        categoryData1.categoryName = "勉強"
//        // データを追加
//        try! realm.write() {
//            realm.add(categoryData1, update: true)
//        }
//        let categoryData2 = Category()
//        categoryData2.id = 2
//        categoryData2.categoryName = "遊び"
//        // データを追加
//        try! realm.write() {
//            realm.add(categoryData2, update: true)
//        }
//        let categoryData3 = Category()
//        categoryData3.id = 3
//        categoryData3.categoryName = "買い物"
//        // データを追加
//        try! realm.write() {
//            realm.add(categoryData3, update: true)
//        }
        
    }
    
    //  検索結果を絞り込み表示(検索文字列が何もない場合の解消含む)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        // サーチバーが空欄の場合
        if searchBar.text!.isEmpty {
            taskArray = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        } else {
            //関連オブジェクトから検索
            // 検索結果をtaskArray(DB内のタスクが格納されるリスト)に入れる
            taskArray = realm.objects(Task.self).filter("category = %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            print(taskArray)
        }
        // TableView を更新する
        tableView.reloadData()
        searchBar.showsCancelButton = true
    }

    // キャンセルボタンがタップされた時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
// パターン２(検索文字列が何もない場合の解消)
//    // サーチバー 検索ボタンをクリック時
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // キーボードを閉じる
//        view.endEditing(true)
//
//        // サーチバーが空欄の場合
//        if searchText.text!.isEmpty {
//
//            let searchedCategory = realm.objects(Task.self)
//            taskArray = searchedCategory
//            tableView.reloadData()
//
//        } else {
//            //関連オブジェクトから検索
//            let searchedCategory = realm.objects(Task.self).filter("category = %@", searchText.text!)
//            print(searchedCategory)
//
//            // 検索結果をtaskArray(DB内のタスクが格納されるリスト)に入れる
//            // TableView を更新する
//            taskArray = searchedCategory
//            tableView.reloadData()
//        }
//
//    }
//
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する  
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 遷移させる
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        } // --- ここまで変更 ---
    }

    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
}

