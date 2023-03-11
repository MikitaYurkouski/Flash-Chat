//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Никита Юрковский on 6.03.23.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.delegate = self
        
        tableView.dataSource = self
        
        // Заголовок на экране
        title = K.appName
        
        // Скрываем кнопку BACK на панели навигации
        navigationItem.hidesBackButton = true
        
        // подключаем MessageCell
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    func loadMessages() {
       // messages = []  -  Переносим в тело кода
        
        // Добавили order(by: K.FStore.dateField) для сортировки по дате
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (quertySnapshot, error) in
            
            self.messages = []   //-- Тепереь сообщение которое мы написали будет отображаться на экране и не подтягивать ранее написанные сообшения, а только новое сообщение, но в порядке который идет от файрбэс
            
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                if let snapshotDocuments = quertySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            // Обновляем предствление в таблице. Загружаем наши сообщения
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                // Прокрутка сообщений. Не надо будет тянуть(ручная прокрутка) экран чтобы увидеть новое сообшение
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                // Сортировка сообщений в чате по времени
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            // Возвращение на корневой ВЬЮ, когда человек нажимает на выход из учетной записи
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}


// Расширение для заполнения таблицы
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        // количество ячеек в таблице
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as!
                MessageCell
                cell.label.text = message.body // messages[indexPath.row].body -изменили, тк надо настроить на чтобы мои и другие сообщения отобрадалить по-разному
        
        // Cообщение от текущего пользователя
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        // Сообщение от другого отправителя
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
}

// Расширение ??????
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}

