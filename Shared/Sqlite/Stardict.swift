//
//  Stardict.swift
//  Sand
//
//  Created by 许滨麟 on 2021/5/24.
//

import Foundation
import SQLite3

struct Stardict:Codable{
    let id: Int32
    let word: String
    let sw: String
    let phonetic: String?
    let definition: String?
    let translation: String?
    let pos: String?
    let collins: Int32?
    let oxford: Int32?
    let tag: String?
    let bnc: Int32?
    let frq: Int32?
    let exchange: String?
    let detail: String?
    let audio: String?
}

extension Stardict: SQLTable {
    static var tableName:String { "stardict" }
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS "stardict" (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
            "word" VARCHAR(64) COLLATE NOCASE NOT NULL UNIQUE,
            "sw" VARCHAR(64) COLLATE NOCASE NOT NULL,
            "phonetic" VARCHAR(64),
            "definition" TEXT,
            "translation" TEXT,
            "pos" VARCHAR(16),
            "collins" INTEGER DEFAULT(0),
            "oxford" INTEGER DEFAULT(0),
            "tag" VARCHAR(64),
            "bnc" INTEGER DEFAULT(NULL),
            "frq" INTEGER DEFAULT(NULL),
            "exchange" TEXT,
            "detail" TEXT,
            "audio" TEXT
        );
        CREATE UNIQUE INDEX IF NOT EXISTS "stardict_1" ON stardict (id);
        CREATE UNIQUE INDEX IF NOT EXISTS "stardict_2" ON stardict (word);
        CREATE INDEX IF NOT EXISTS "stardict_3" ON stardict (sw, word collate nocase);
        CREATE INDEX IF NOT EXISTS "sd_1" ON stardict (word collate nocase);
        """
    }

    init(_ op: OpaquePointer) {
        id = sqlite3_column_int(op, 0)
        word = String(cString: sqlite3_column_text(op, 1)!)
        sw = String(cString: sqlite3_column_text(op, 2)!)
        phonetic = sqlite3_column_type(op, 3) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 3)!)
        definition = sqlite3_column_type(op, 4) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 4)!)
        translation = sqlite3_column_type(op, 5) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 5)!)
        pos = sqlite3_column_type(op, 6) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 6)!)
        collins = sqlite3_column_type(op, 7) == SQLITE_NULL ? nil : sqlite3_column_int(op, 7)
        oxford = sqlite3_column_type(op, 8) == SQLITE_NULL ? nil : sqlite3_column_int(op, 8)
        tag = sqlite3_column_type(op, 9) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 9)!)
        bnc = sqlite3_column_type(op, 10) == SQLITE_NULL ? nil : sqlite3_column_int(op, 10)
        frq = sqlite3_column_type(op, 11) == SQLITE_NULL ? nil : sqlite3_column_int(op, 11)
        exchange = sqlite3_column_type(op, 12) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 12)!)
        detail = sqlite3_column_type(op, 13) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 13)!)
        audio = sqlite3_column_type(op, 14) == SQLITE_NULL ? nil : String(cString: sqlite3_column_text(op, 14)!)
    }

    static func query(word: String) -> Stardict? {
        let sql = "where word = '\(word)'"
        return findOne(by: sql)
    }

    static func query(id: Int32) -> Stardict? {
        let sql = "where id = \(id)"
        return findOne(by: sql)
    }

    static func match(word: String, limit: Int = 10, strip: Bool = false) -> [Stardict] {
        if strip {
            let sql = "where sw >= '\(word)' order by sw collate nocase limit \(limit)"
            return findAll(by: sql)
        } else {
            let sql = "where word >= '\(word)' order by word, word collate nocase limit \(limit)"
            return findAll(by: sql)
        }
    }
}
