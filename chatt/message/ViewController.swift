//
//  ViewController.swift
//  chatt
//
//  Created by SoftSuave on 21/04/22.
//

import UIKit
import Alamofire

struct chat: Codable{
    var name:String?
    var message:String?
}
struct Custom:Codable{
    let data:[chat]
}
struct chat1: Codable{
    var id:Int?
    var chatGroupId:Int?
    var message:String
    var senderUserId:Int
    var senderFullName:String
    }


struct Custom1:Codable{
    let data1:[chat1]
}
struct chat2: Codable{
    var chatGroupId:Int
    var sourceId:Int
    var sourceType:String
    var name:String
    var createdDate:String
    var updatedDate:String
    var unseenMessageCount:Int
    
}
struct Custom2:Codable{
    let data2:[chat2]
}
class ViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var chattext: UITextField!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Variables
    var data:[chat] = []
    var image = ["p1","p2","p3","p4","p5"]
    var result:[chat2] = []
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableview.separatorStyle = .none
        chattext.delegate = self
        tableview.keyboardDismissMode = .onDrag
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            self.view.frame.origin.y -= keyboardSize.height
            self.tableview.frame.origin.y -= keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y = 0
        self.tableview.frame.origin.y = 0
    }
    
    //MARK:- IBActions
    @IBAction func sendbutton(_ sender: Any) {
        if ((chattext.text?.trimmingCharacters(in: .whitespaces)) != "")  {
            let message = chattext.text
            chattext.text?.removeAll()
            data.append(chat(name: "Peter K", message: message));
            tableview.reloadData()
            scrollToBottom()
            sendRequest()
            getRequest()
        }
    }
    
    //MARK:- Private function
    private func scrollToBottom() {
        if data.count>2 {
            let Row = IndexPath(row: data.count-1,
                                section: 0)
            self.tableview.scrollToRow(at: Row,
                                       at: .bottom,
                                       animated: true)
        }
    }

    func sendRequest() {
        let url: URLConvertible = "https://qa-api.quberapp.com/chat-service/api/v1.0/chat/message"
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
         
        let request = AF.request(url,method: .post,
                                 parameters:["chatGroupId": 1,"senderUserId": 6348,"message": chattext.text as Any],
                                 encoding: JSONEncoding.default,
                                 headers: headers)
        request.responseJSON{(response) in
            switch response.result{
            case.success:
                //self.result = response.value!.data1
                print("sucess")
                print(response)
            case .failure:
                print("failure")
            }
        }
        
    }

    func getRequest() {
        let request = AF.request("https://qa-api.quberapp.com/chat-service/api/v1.0/chat/{jarId}/{sourceType}/{userId}",method:.get)
        request.responseDecodable(of: Custom2.self){(response) in
            switch response.result{
            case.success:
                self.result = response.value!.data2
                print(self.result)
            case .failure:
                print("failure")
        }
}
    }
}
//MARK:- TableView Delegate and Datasource methods
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath)as? MessageTableViewCell
        cell?.textlbl.text  = data[indexPath.row].message
        let name = (data[indexPath.row].name)
        var sender:[Character] = []
        sender.append((name?.first)!)
        sender.append((name?.last)!)
        cell?.namelbl.text = String(sender)
        cell?.selectionStyle = .none
        cell?.personimg.image = UIImage(named:  image[0])
        return cell!
    }
}

