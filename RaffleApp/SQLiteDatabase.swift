//
//  SQLiteDatabase.swift
//  Tutorial5
//
//  Created by Lindsay Wells (updated 2020).
//
//  You are welcome to use this class in your assignments, but you will need to modify it in order for
//  it to do anything!
//
//  Add your code to the end of this class for handling individual tables
//
//  Known issues: doesn't handle versioning and changing of table structure.
//

import Foundation
import SQLite3

class SQLiteDatabase
{
    /* This variable is of type OpaquePointer, which is effectively the same as a C pointer (recall the SQLite API is a C-library). The variable is declared as an optional, since it is possible that a database connection is not made successfully, and will be nil until such time as we create the connection.*/
    private var db: OpaquePointer?
    
    /* Change this value whenever you make a change to table structure.
        When a version change is detected, the updateDatabase() function is called,
        which in turn calls the createTables() function.
     
        WARNING: DOING THIS WILL WIPE YOUR DATA, unless you modify how updateDatabase() works.
     */
    private let DATABASE_VERSION = 7
    
    
    
    // Constructor, Initializes a new connection to the database
    /* This code checks for the existence of a file within the application’s document directory with the name <dbName>.sqlite. If the file doesn’t exist, it attempts to create it for us. Since our application has the ability to write into this directory, this should happen the first time that we run the application without fail (it can still possibly fail if the device is out of storage space).
     The remainder of the function checks to see if we are able to open a successful connection to this database file using the sqlite3_open() function. With all of the SQLite functions we will be using, we can check for success by checking for a return value of SQLITE_OK.
     */
    init(databaseName dbName:String)
    {
        //get a file handle somewhere on this device
        //(if it doesn't exist, this should create the file for us)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(dbName).sqlite")
        
        //try and open the file path as a database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(fileURL.path)")
            self.dbName = dbName
            checkForUpgrade();
        }
        else
        {
            print("Unable to open database at \(fileURL.path)")
            printCurrentSQLErrorMessage(db)
        }
        
    }
    
    deinit
    {
        /* We should clean up our memory usage whenever the object is deinitialized, */
        sqlite3_close(db)
    }
    private func printCurrentSQLErrorMessage(_ db: OpaquePointer?)
    {
        let errorMessage = String.init(cString: sqlite3_errmsg(db))
        print("Error:\(errorMessage)")
    }
    
    private func createTables()
    {
        createRaffleTable()
        createCustomerTable()
        createTicketTable()
    }
    private func dropTables()
    {
        dropTable(tableName:"raffle")
        dropTable(tableName:"customer")
        dropTable(tableName:"ticket")
    }
    
    /* --------------------------------*/
    /* ----- VERSIONING FUNCTIONS -----*/
    /* --------------------------------*/
    private var dbName:String = ""
    func checkForUpgrade()
    {
        // get the current version number
        let defaults = UserDefaults.standard
        let lastSavedVersion = defaults.integer(forKey: "DATABASE_VERSION_\(dbName)")
        
        // detect a version change
        if (DATABASE_VERSION > lastSavedVersion)
        {
            onUpdateDatabase(previousVersion:lastSavedVersion, newVersion: DATABASE_VERSION);
            
            // set the stored version number
            defaults.set(DATABASE_VERSION, forKey: "DATABASE_VERSION_\(dbName)")
        }
    }
    
    func onUpdateDatabase(previousVersion : Int, newVersion : Int)
    {
        print("Detected Database Version Change (was:\(previousVersion), now:\(newVersion))")
        
        //handle the change (simple version)
        dropTables()
        createTables()
    }
    
    
    
    /* --------------------------------*/
    /* ------- HELPER FUNCTIONS -------*/
    /* --------------------------------*/
    
    /* Pass this function a CREATE sql string, and a table name, and it will create a table
        You should call this function from createTables()
     */
    private func createTableWithQuery(_ createTableQuery:String, tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        //prepare the statement
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK
        {
            //execute the statement
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("\(tableName) table created.")
            }
            else
            {
                print("\(tableName) table could not be created.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("CREATE TABLE statement for \(tableName) could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clean up
        sqlite3_finalize(createTableStatement)
        
    }
    /* Pass this function a table name.
        You should call this function from dropTables()
     */
    private func dropTable(tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        
        //prepare the statement
        let query = "DROP TABLE IF EXISTS \(tableName)"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil)     == SQLITE_OK
        {
            //run the query
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) table deleted.")
            }
        }
        else
        {
            print("\(tableName) table could not be deleted.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clear up
        sqlite3_finalize(statement)
    }
    
    //helper function for handling INSERT statements
    //provide it with a binding function for replacing the ?'s for setting values
    private func insertWithQuery(_ insertStatementQuery : String, bindingFunction:(_ insertStatement: OpaquePointer?)->())
    {
        /*
         Similar to the CREATE statement, the INSERT statement needs the following SQLite functions to be called (note the addition of the binding function calls):
         1.    sqlite3_prepare_v2()
         2.    sqlite3_bind_***()
         3.    sqlite3_step()
         4.    sqlite3_finalize()
         */
        // First, we prepare the statement, and check that this was successful. The result will be a C-
        // pointer to the statement:
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementQuery, -1, &insertStatement, nil) == SQLITE_OK
        {
            //handle bindings
            bindingFunction(insertStatement)
            
            /* Using the pointer to the statement, we can call the sqlite3_step() function. Again, we only
             step once. We check that this was successful */
            //execute the statement
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
            }
            else
            {
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("INSERT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
    
        //clean up
        sqlite3_finalize(insertStatement)
    }
    
    //helper function to run Select statements
    //provide it with a function to do *something* with each returned row
    //(optionally) Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func selectWithQuery(
        _ selectStatementQuery : String,
        eachRow: (_ rowHandle: OpaquePointer?)->(),
        bindingFunction: ((_ rowHandle: OpaquePointer?)->())? = nil)
    {
        //prepare the statement
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementQuery, -1, &selectStatement, nil) == SQLITE_OK
        {
            //do bindings, only if we have a bindingFunction set
            //hint, to do selectMovieBy(id:) you will need to set a bindingFunction (if you don't hardcode the id)
            bindingFunction?(selectStatement)
            
            //iterate over the result
            while sqlite3_step(selectStatement) == SQLITE_ROW
            {
                eachRow(selectStatement);
            }
            
        }
        else
        {
            print("SELECT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(selectStatement)
    }
    
    //helper function to run update statements.
    //Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func updateWithQuery(
        _ updateStatementQuery : String,
        bindingFunction: ((_ rowHandle: OpaquePointer?)->()))
    {
        //prepare the statement
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementQuery, -1, &updateStatement, nil) == SQLITE_OK
        {
            //do bindings
            bindingFunction(updateStatement)
            
            //execute
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
            }
            else
            {
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("UPDATE statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(updateStatement)
    }
    
    /* --------------------------------*/
    /* --- ADD YOUR TABLES ETC HERE ---*/
    /* --------------------------------*/
    
    func createRaffleTable() {
        let createRaffleTableQuery = """
            CREATE TABLE raffle (
                raffle_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                raffle_name CHAR(255) NOT NULL,
                draw_date CHAR(255) NOT NULL,
                price REAL NOT NULL,
                prize INTEGER NOT NULL,
                pool INTEGER NOT NULL,
                max INTEGER NOT NULL,
                recuring INTEGER DEFAULT 0,
                frequency CHAR(255) DEFAULT '',
                archived INTEGER DEFAULT 0,
                image CHAR(255) DEFAULT ''
            );
            """
        createTableWithQuery(createRaffleTableQuery, tableName: "raffle")
    }
    
    func createCustomerTable() {
        let createCustomerTableQuery = """
            CREATE TABLE customer (
                customer_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                customer_name CHAR(255) NOT NULL,
                email CHAR(255) NOT NULL,
                phone INTEGER NOT NULL,
                postcode INTEGER NOT NULL
            );
            """
        createTableWithQuery(createCustomerTableQuery, tableName: "customer")
    }
    
    func createTicketTable() {
        let createTicketTableQuery = """
            CREATE TABLE ticket (
                ticket_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                raffle_id INTEGER NOT NULL,
                customer_id INTEGER NOT NULL,
                number INTEGER NOT NULL,
                archived INTEGER DEFAULT 0,
                FOREIGN KEY (raffle_id) REFERENCES raffle (raffle_id),
                FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
            );
            """
        createTableWithQuery(createTicketTableQuery, tableName: "ticket")
    }

    func insert(raffle:Raffle){
        let insertStatementQuery = "INSERT INTO raffle (raffle_name, draw_date, price, prize, pool, max, recuring, frequency, recuring, image) VALUES (?,?,?,?,?,?,?,?,?,?);"
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:raffle.raffle_name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:raffle.draw_date).utf8String, -1, nil) // must take date as 'YYYY-MM-DD HH:MM:SS.SSS'
            sqlite3_bind_double(insertStatement, 3, raffle.price)
            sqlite3_bind_int(insertStatement, 4, raffle.prize)
            sqlite3_bind_int(insertStatement, 5, raffle.pool)
            sqlite3_bind_int(insertStatement, 6, raffle.max)
            sqlite3_bind_int(insertStatement, 7, raffle.recuring ? 0 : 1) //Typecase bool to int
            sqlite3_bind_text(insertStatement, 8, NSString(string:raffle.frequency).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 9, raffle.archived ? 0 : 1) //Typecase bool to int
            sqlite3_bind_text(insertStatement, 10, NSString(string:raffle.image).utf8String, -1, nil)
        })
    }
    
    func insert(customer:Customer){
        let insertStatementQuery = "INSERT INTO customer (customer_name, email, phone, postcode) VALUES (?,?,?,?);"
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:customer.customer_name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:customer.email).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, customer.phone)
            sqlite3_bind_int(insertStatement, 4, customer.postcode)
        })
    }
    
    func insert(ticket:Ticket){
        let insertStatementQuery = "INSERT INTO ticket (raffle_id, customer_id, number, archived) VALUES (?,?,?,?);"
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_int(insertStatement, 1, ticket.raffle_id)
            sqlite3_bind_int(insertStatement, 2, ticket.customer_id)
            sqlite3_bind_int(insertStatement, 3, ticket.number)
            sqlite3_bind_int(insertStatement, 4, ticket.archived ? 0 : 1) //Typecase bool to int
        })
    }
    
    func selectAllRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, draw_date, price, prize, pool, max, recuring, frequency, recuring, image FROM raffle;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                draw_date: String(cString:sqlite3_column_text(row, 2)),
                price: sqlite3_column_double(row, 3),
                prize: sqlite3_column_int(row, 4),
                pool: sqlite3_column_int(row, 5),
                max: sqlite3_column_int(row, 6),
                recuring: Bool(truncating: sqlite3_column_int(row, 7) as NSNumber),
                frequency: String(cString:sqlite3_column_text(row, 8)),
                archived: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                image: String(cString:sqlite3_column_text(row, 10))
            )
            result += [raffle]
        })
        return result
    }
    
    func selectAllActiveRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, draw_date, price, prize, pool, max, recuring, frequency, recuring, image FROM raffle WHERE archived = 0;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                draw_date: String(cString:sqlite3_column_text(row, 2)),
                price: sqlite3_column_double(row, 3),
                prize: sqlite3_column_int(row, 4),
                pool: sqlite3_column_int(row, 5),
                max: sqlite3_column_int(row, 6),
                recuring: Bool(truncating: sqlite3_column_int(row, 7) as NSNumber),
                frequency: String(cString:sqlite3_column_text(row, 8)),
                archived: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                image: String(cString:sqlite3_column_text(row, 10))
            )
            result += [raffle]
        })
        return result
    }
    
    func selectAllCustomers() -> [Customer]
    {
        var result = [Customer]()
        let selectStatementQuery = "SELECT customer_id, customer_name, email, phone, postcode FROM customer;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let customer = Customer(
                customer_id: sqlite3_column_int(row, 0),
                customer_name: String(cString:sqlite3_column_text(row, 1)),
                email: String(cString:sqlite3_column_text(row, 2)),
                phone: sqlite3_column_int(row, 3),
                postcode: sqlite3_column_int(row, 4)
            )
            result += [customer]
        })
        return result
    }
    
    func selectAllTickets() -> [Ticket]
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, archived FROM ticket;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let ticket = Ticket(
                ticket_id: sqlite3_column_int(row, 0),
                raffle_id: sqlite3_column_int(row, 1),
                customer_id: sqlite3_column_int(row, 2),
                number: sqlite3_column_int(row, 3),
                archived: Bool(truncating: sqlite3_column_int(row, 4) as NSNumber)
            )
            result += [ticket]
        })
        return result
    }
    
    func selectTicketsByRaffle(raffle_id:Int32) -> [Ticket] //Can change to pass Raffle as parameter instead
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, archived FROM ticket where raffle_id = ?;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                archived: Bool(truncating: sqlite3_column_int(row, 4) as NSNumber)
                            )
                            result += [ticket]
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                        }
        )
        return result
    }
    
    func selectTicketsByRaffleAndCustomer(raffle_id:Int32, customer_id:Int32) -> [Ticket]
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, archived FROM ticket where raffle_id = ? and customer_id = ?;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                archived: Bool(truncating: sqlite3_column_int(row, 4) as NSNumber)
                            )
                            result += [ticket]
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                            sqlite3_bind_int(insertStatement, 2, customer_id)
                        }
        )
        return result
    }
    
    func selectTicketCountByRaffle(raffle_id:Int32) -> Int32
    {
        var result:Int32 = 0
        let selectStatementQuery = "SELECT count(*) FROM ticket where raffle_id = ?;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            result += sqlite3_column_int(row, 0)
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                        }
        )
        return result
    }
    
    
    
/*    func selectMovieBy(id:Int32) -> Movie?
    {
        var result : Movie?
        let selectStatementQuery = "SELECT id, name, year, director FROM Movie WHERE id = ?;"
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let movie = Movie(
                ID: sqlite3_column_int(row, 0),
                name: String(cString:sqlite3_column_text(row, 1)),
                year: sqlite3_column_int(row, 2),
                director: String(cString:sqlite3_column_text(row, 3))
            )
            
            result = movie
                
        }, bindingFunction: { (selectStatement) in
            sqlite3_bind_int(selectStatement, 1, id)
        })

        return result
    }
    */
    
    
    
    
}
