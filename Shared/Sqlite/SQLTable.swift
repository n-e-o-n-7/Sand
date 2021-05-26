//
//  SQLTable.swift
//  Sand
//
//  Created by 许滨麟 on 2021/5/24.
//

import Foundation
import SQLite3

protocol SQLTable {
    static var tableName: String { get }
    static var createStatement: String { get }
    init(_ queryStatement: OpaquePointer)
}

extension SQLTable {
    static func findOne(by sql: String) -> Self? {
        let db = SQLiteController.shared.db
        let sql = "select * from \(Self.tableName) \(sql)"
        guard let queryStatement = try? db.prepareStatement(sql: sql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
        return Self(queryStatement)
    }

    static func findAll(by sql: String) -> [Self] {
        let db = SQLiteController.shared.db
        let sql = "select * from \(Self.tableName) \(sql)"
        guard let queryStatement = try? db.prepareStatement(sql: sql) else {
            return []
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        var result: [Self] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            result.append(Self(queryStatement))
        }
        return result
    }
}
