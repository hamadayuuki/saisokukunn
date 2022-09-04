//
//  LoadPayTask.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/27.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoadPayTask {

    let db = Firestore.firestore()
    let loadUser = LoadUser()

    private var payTasks = [PayTask]()

    // TODO: async awaitで実行したい（PayTasksがCodableを準拠できない問題があるため保留）
    func fetchBorrowPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("PayTasks").whereField("borrowerUID", isEqualTo: uid).whereField("isFinished", isEqualTo: false).order(by: "createdAt", descending: true).getDocuments { snapShots, error in
            if let error = error {
                print("FirestoreからPayTaskの取得に失敗",error)
                return
            }
            print("FirestoreからPayTaskの取得に成功")
            var payTasks = [PayTask]()

            snapShots?.documents.forEach({ snapShot in
                let data = snapShot.data()
                var payTask = PayTask(dic: data)
                payTask.lenderUID = data["lenderUID"] as? String
                payTask.isFinished = data["isFinished"] as? Bool
                payTask.lenderUserName = data["lenderUserName"] as? String
                payTask.borrowerUserName = data["borrowerUserName"] as? String
                payTasks.append(payTask)
            })
            
            completion(payTasks,nil)
        }
    }

    func fetchLenderPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("PayTasks").whereField("lenderUID", isEqualTo: uid).whereField("isFinished", isEqualTo: false).order(by: "createdAt", descending: true).getDocuments { snapShots, error in
            if let error = error {
                print("FirestoreからPayTaskの取得に失敗",error)
                return
            }
            print("FirestoreからPayTaskの取得に成功")
            var payTasks = [PayTask]()

            snapShots?.documents.forEach({ snapShot in
                let data = snapShot.data()
                var payTask = PayTask(dic: data)
                payTask.lenderUID = data["lenderUID"] as? String
                payTask.isFinished = data["isFinished"] as? Bool
                payTask.lenderUserName = data["lenderUserName"] as? String
                payTask.borrowerUserName = data["borrowerUserName"] as? String
                payTasks.append(payTask)
            })
            completion(payTasks,nil)
        }
    }

    func fetchPayTask(documentPath: String, completion: @escaping(PayTask?,Error?) -> Void) {
        db.collection("PayTasks").document(documentPath).getDocument { snapShot, error in
            if let error = error {
                print("FirestoreからPayTaskの取得に失敗しました",error)
                completion(nil,error)
            }
            guard let data = snapShot?.data() else { return }
            var payTask = PayTask(dic: data)
            payTask.borrowerUserName = data["borrowerUserName"] as? String
            completion(payTask,nil)
        }
    }

}

