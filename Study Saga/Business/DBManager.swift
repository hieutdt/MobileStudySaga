//
//  DBManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import UIKit
import SQLite


class DBManager: NSObject {
    
    let documentEntityName = "DocumentEntity"
    let documentTableName = "documents"
    let dbURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let documentDBName = "document_db.sqlite3"
    
    static let manager = DBManager()
    
    override init() {
        super.init()
    }
    
    func saveDocumentInfoToDB(_ document: DocumentModel) {
        do {
            let dbPath = "\(dbURL)/\(documentDBName)"
            let db = try Connection(dbPath)
            
            let documents = Table(documentTableName)
            let id = Expression<String>("id")
            let name = Expression<String>("name")
            let courseName = Expression<String>("course_name")
            let path = Expression<String>("path")
            
            // Create table if needed.
            try db.run(documents.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(courseName)
                t.column(path, unique: true)
            })
            
            // Update.
            try db.transaction {
                let filteredTable = documents.filter(id == document.id)
                
                // try to update
                if try db.run(filteredTable.update(
                    name <- document.name,
                    courseName <- document.courseName,
                    path <- document.path
                )) > 0 {
                    print("Update succeed!")
                } else {
                    // Update returned 0 because there was no match.
                    // Do insert
                    try! db.run(documents.insert(
                        id <- document.id,
                        name <- document.name,
                        courseName <- document.courseName,
                        path <- document.path
                    ))
                }
            }
        } catch {
            print("DB Error: \(error)")
        }
    }
    
    func queryDocumentsFromDB() -> [DocumentModel] {
        
        // create empty array
        var documentModels: [DocumentModel] = []
        
        do {
            
            let dbPath = "\(dbURL)/\(documentDBName)"
            let db = try Connection(dbPath)
            let documents = Table(documentTableName)
            let id = Expression<String>("id")
            let name = Expression<String>("name")
            let courseName = Expression<String>("course_name")
            let path = Expression<String>("path")
            
            for document in try db.prepare(documents) {
                var documentModel = DocumentModel()
                documentModel.id = document[id]
                documentModel.name = document[name]
                documentModel.path = document[path]
                documentModel.courseName = document[courseName]
                
                documentModels.append(documentModel)
            }
            
        } catch {
            print("DB Error: \(error)")
        }
        
        return documentModels
    }
    
    func removeDocumentFromDB(_ document: DocumentModel) {
        do {
            let dbPath = "\(dbURL)/\(documentDBName)"
            let db = try Connection(dbPath)
            let documents = Table(documentTableName)
            let id = Expression<String>("id")
            
            let removeDocuments = documents.filter(id == document.id)
            try db.run(removeDocuments.delete())
            
        } catch {
            print("DB Error: \(error)")
        }
    }
}

