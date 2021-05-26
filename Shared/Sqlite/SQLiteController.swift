//
//  SQLiteController.swift
//  Sand
//
//  Created by 许滨麟 on 2021/5/24.
//

import Foundation

struct SQLiteController {
    static let shared = SQLiteController()

    let db: SQLiteDatabase

    private init() {
        do {
            let path = Bundle.main.path(forResource: "ecdict", ofType: "sqlite")!
            db = try SQLiteDatabase.open(path: path)
            print("Successfully opened connection to database.")
            try db.createTable(table: Stardict.self)
        } catch let SQLiteError.OpenDatabase(message) {
            fatalError("Unable to open database. \(message) ")
        } catch let SQLiteError.Step(message) {
            fatalError("Unable to create table. \(message) ")
        } catch {
            fatalError("Unresolved error \(error) ")
        }
    }
}
