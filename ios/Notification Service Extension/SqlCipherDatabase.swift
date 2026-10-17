//
//  SqlCipherDatabase.swift
//  Runner
//
//  Created by Christian Kußowski on 07.10.26.
//

import Foundation


final class SqlCipherDatabase {
    
    private let handle: UnsafeMutableRawPointer
    private let dbPointer: OpaquePointer
    private var isClosed = false
    
    private init(handle: UnsafeMutableRawPointer, dbPointer: OpaquePointer) {
        self.handle = handle
        self.dbPointer = dbPointer
    }

    static func open(path: String, key: String) throws -> SqlCipherDatabase {
        let libURL = Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Frameworks/sqlcipher.framework/sqlcipher")
        guard let handle = dlopen(libURL.path, RTLD_NOW) else {
            throw SqlCipherError.libraryNotLoaded(dlerror().map { String(cString: $0) } ?? "unknown dlopen error")
        }
        let openV2 = try symbol(handle, "sqlite3_open_v2", as: OpenV2Fn.self)
        var dbPointer: OpaquePointer?
        let rc = openV2(path, &dbPointer, SQLITE_OPEN_READONLY, nil)
        guard rc == SQLITE_OK, let dbPointer = dbPointer else {
            throw SqlCipherError.sqlite(code: rc, message: "Failed to open")
        }

        let database = SqlCipherDatabase(handle: handle, dbPointer: dbPointer)
        _ = try database.execute(query: "PRAGMA key = '\(key)'")
        _ = try database.execute(query: "SELECT count(*) FROM sqlite_master")

        return database
    }

    func scalar(query: String, args: [String] = []) throws -> String? {
        try execute(query: query, args: args).first?.first ?? nil
    }

    func execute(query: String, args: [String] = []) throws -> [[String?]] {
        guard !isClosed else { throw SqlCipherError.sqlite(code: Self.SQLITE_MISUSE, message: "Database is closed") }
        let prepareV2 = try Self.symbol(handle, "sqlite3_prepare_v2", as: PrepareV2Fn.self)
        let bindText = try Self.symbol(handle, "sqlite3_bind_text", as: BindTextFn.self)
        let step = try Self.symbol(handle, "sqlite3_step", as: StepFn.self)
        let columnCountFn = try Self.symbol(handle, "sqlite3_column_count", as: ColumnCountFn.self)
        let columnText = try Self.symbol(handle, "sqlite3_column_text", as: ColumnTextFn.self)
        let finalize = try Self.symbol(handle, "sqlite3_finalize", as: FinalizeFn.self)
        let errmsg = try Self.symbol(handle, "sqlite3_errmsg", as: ErrmsgFn.self)
        let fail = { (rc: Int32) in SqlCipherError.sqlite(code: rc, message: errmsg(self.dbPointer).map { String(cString: $0) } ?? "unknown error") }

        var stmt: OpaquePointer?
        let rc = prepareV2(dbPointer, query, -1, &stmt, nil)
        guard rc == Self.SQLITE_OK, let stmt = stmt else { throw fail(rc) }
        defer { _ = finalize(stmt) }

        for (index, arg) in args.enumerated() {
            let rc = bindText(stmt, Int32(index + 1), arg, -1, Self.SQLITE_TRANSIENT)
            guard rc == Self.SQLITE_OK else { throw fail(rc) }
        }

        let columnCount = columnCountFn(stmt)
        var rows: [[String?]] = []
        var stepRc = step(stmt)
        while stepRc == Self.SQLITE_ROW {
            rows.append((0..<columnCount).map { columnText(stmt, $0).map { String(cString: $0) } })
            stepRc = step(stmt)
        }
        guard stepRc == Self.SQLITE_DONE else { throw fail(stepRc) }

        return rows
    }
    
    func close() throws {
        guard !isClosed else { return }
        let closeV2 = try Self.symbol(handle, "sqlite3_close_v2", as: CloseV2Fn.self)
        let rc = closeV2(dbPointer)
        isClosed = true
        guard rc == Self.SQLITE_OK else { throw SqlCipherError.sqlite(code: rc, message: "Failed to close") }
    }
    
    deinit { try? close() }
    
    private static func symbol<T>(_ handle: UnsafeMutableRawPointer, _ name: String, as type: T.Type) throws -> T {
        guard let sym = dlsym(handle, name) else { throw SqlCipherError.symbolNotFound(name) }
        return unsafeBitCast(sym, to: type)
    }
    
    private typealias OpenV2Fn = @convention(c) (UnsafePointer<CChar>?, UnsafeMutablePointer<OpaquePointer?>?, Int32, UnsafePointer<CChar>?) -> Int32
    private typealias CloseV2Fn = @convention(c) (OpaquePointer?) -> Int32
    private static let SQLITE_OK: Int32 = 0
    private static let SQLITE_MISUSE: Int32 = 21
    private static let SQLITE_OPEN_READONLY: Int32 = 1
    private static let SQLITE_ROW: Int32 = 100
    private static let SQLITE_DONE: Int32 = 101
    private static let SQLITE_TRANSIENT: Int = -1

    enum SqlCipherError: Error { case libraryNotLoaded(String), symbolNotFound(String), sqlite(code: Int32, message: String) }

    private typealias PrepareV2Fn = @convention(c) (OpaquePointer?, UnsafePointer<CChar>?, Int32, UnsafeMutablePointer<OpaquePointer?>?, UnsafeMutablePointer<UnsafePointer<CChar>?>?) -> Int32
    private typealias BindTextFn = @convention(c) (OpaquePointer?, Int32, UnsafePointer<CChar>?, Int32, Int) -> Int32
    private typealias StepFn = @convention(c) (OpaquePointer?) -> Int32
    private typealias ColumnCountFn = @convention(c) (OpaquePointer?) -> Int32
    private typealias ColumnTextFn = @convention(c) (OpaquePointer?, Int32) -> UnsafePointer<UInt8>?
    private typealias FinalizeFn = @convention(c) (OpaquePointer?) -> Int32
    private typealias ErrmsgFn = @convention(c) (OpaquePointer?) -> UnsafePointer<CChar>?
}
