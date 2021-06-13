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
    let documentDBPath = "db/sqlite/document_db.sqlite3"
    let documentTableName = "documents"
    
    static let manager = DBManager()
    
    override init() {
        super.init()
    }
    
    func saveDocumentInfoToDB(_ document: DocumentModel) {
        do {
            let db = try Connection(documentDBPath)
            
            let documents = Table(documentTableName)
            let id = Expression<String>("id")
            let name = Expression<String>("name")
            let path = Expression<String>("path")
            
            // Create table if needed.
            try db.run(documents.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(path, unique: true)
            })
            
            // Update.
            try db.transaction {
                let filteredTable = documents.filter(id == document.id)
                
                // try to update
                if try db.run(filteredTable.update(
                    name <- document.name,
                    path <- document.path
                )) > 0 {
                    print("Update succeed!")
                } else {
                    // Update returned 0 because there was no match.
                    // Do insert
                    try! db.run(documents.insert(
                        id <- document.id,
                        name <- document.name,
                        path <- document.path
                    ))
                }
            }
        } catch {
            print("DB Error: \(error)")
        }
    }
}

