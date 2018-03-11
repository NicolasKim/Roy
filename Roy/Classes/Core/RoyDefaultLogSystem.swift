//
//  RoyDefaultLogSystem.swift
//  Pods-Roy_Example
//
//  Created by dreamtracer on 2018/3/11.
//

import Foundation
import GRDB

enum RoyLogErrorType:Int {
    case None
    case ConvertError
    case ParamValidateError
    case TaskNotFound
    case Unknown
}
extension RoyLogErrorType : DatabaseValueConvertible { }

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

protocol RoyDefaultLogSystemDelegate {
    
}

class RoyDefaultLogSystem : RoyLogProtocol {
    
    

    var delegate:RoyDefaultLogSystemDelegate?
    var saveToDB = true
    var dbQueue : DatabaseQueue?
    
    let dbPath = NSTemporaryDirectory()+"roy.db"
    let tableName = "ROY_LOG_TABLE"
    
    init(saveToDB:Bool) {
        self.saveToDB = saveToDB
        if saveToDB {
			self.createDB(atPath: dbPath)
            self.createTable(name: tableName)
        }
    }
    
    func createDB(atPath path:String) {
        do{
        	dbQueue = try DatabaseQueue(path: path)
        }
        catch{
            print("roy logsystem init db error")
        }
    }
    
    func createTable(name:String) {
        do{
            print("roy system db path:\(self.dbPath)")
            try self.dbQueue?.inDatabase({ db in
                if try !db.tableExists(name) {
                    try db.create(table: name) { t in
                        t.column("id", .integer).primaryKey()
                        t.column("type", .text).notNull().defaults(to: "regist")
                        t.column("url", .text).notNull()
                        t.column("url_rule", .text)
                        t.column("err_code", .integer).notNull().defaults(to: 0)
                        t.column("err_msg", .text)
                        t.column("date", .text).notNull()
                    }
                }
            })
        }
        catch{
            print("roy system create table error")
        }
        
    }
    
    func addRegistLog(withURL url:String,message:String?,errorType:RoyLogErrorType) {
        
        if self.saveToDB {
            do {
                try self.dbQueue?.inDatabase({ db in
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    var msg = ""
                    if let temp = message  {msg = temp}
                    let ds = df.string(from: Date())
                    try db.execute(    """
                            INSERT INTO ROY_LOG_TABLE (type, url, url_rule,err_code, err_msg, date)
                            VALUES (?, ?, ?, ?, ?, ?)
                            """, arguments: ["regist", url, "",errorType, msg, ds])
                })
            }
            catch{
                print("roy logsystem save log to db error")
            }
        }
    }
    
    func addRouteLog(withURL url:String,url_rule:String?,message:String?,errorType:RoyLogErrorType) {
        
        if self.saveToDB {
            do{
                try self.dbQueue?.inDatabase({ db in
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let ds = df.string(from: Date())
                    var ur = ""
                    var msg = ""
                    if let temp = url_rule {ur = temp}
                    if let temp = message  {msg = temp}
                    
                    try db.execute(    """
                            INSERT INTO ROY_LOG_TABLE (type, url, url_rule,err_code, err_msg, date)
                            VALUES (?, ?, ?, ?, ?, ?)
                            """, arguments: ["route", url, ur,errorType, msg, ds])
                })
            }
            catch{
                print("roy logsystem save log to db error")
            }
        }

    }
    
}

