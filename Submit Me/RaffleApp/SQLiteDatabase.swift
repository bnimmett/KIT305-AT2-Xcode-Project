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
    private let DATABASE_VERSION = 20
    
    
    
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
    
    //Function for creating initial raffles and customers for testing
    func insertPlaceholders()
    {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"my_database")
        
        dropTables()
        createTables()

        database.insert(raffle:Raffle(
            raffle_name:"Tuesday night raffle",
            raffle_description:"Run every Tuesday night at the best pub in the world.",
            draw_date:"2020-05-12 00:00:00.000",
            start_date:"2020-05-06 00:00:00.000",
            price:1.5,
            prize:5000,
            max:5,
            current:6,
            margin:false,
            archived:false)
        )
        
        database.insert(raffle:Raffle(
            raffle_name:"Wacky Wednesday",
            raffle_description:"Run every Wednesday night at the best pub in the world.",
            draw_date:"2020-09-13 00:00:00.000",
            start_date:"2020-05-06 00:00:00.000",
            price:3,
            prize:10000,
            max:3,
            current:6,
            margin:true,
            archived:false)
        )
        
        database.insert(raffle:Raffle(
            raffle_name:"First Friday Frenzy",
            raffle_description:"Run the first Friday of every Month at the best pub in the world.",
            draw_date:"2020-09-15 00:00:00.000",
            start_date:"2020-05-06 00:00:00.000",
            price:0.5,
            prize:2500,
            max:10,
            current:6,
            margin:false,
            archived:false)
        )
        
        database.insert(customer:Customer(
            customer_id: -1,
            customer_name:"Brandon Nimmett",
            email:"bnimmett@utas.fake.au",
            phone:123456789,
            postcode:7000,
            archived: false
           )
        )

        database.insert(customer:Customer(
            customer_id: -1,
            customer_name:"Smithy Smithson",
            email:"Ssmmiitthhyy@utas.fake.au",
            phone:987654321,
            postcode:7250,
            archived: false
           )
        )
        
        database.insert(customer:Customer(
            customer_id: -1,
            customer_name:"Billy Bob",
            email:"bb8@utas.fake.au",
            phone:96664440,
            postcode:7270,
            archived: false
           )
        )
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
    
    func truncateTable(tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        
        //prepare the statement
        let query = "DELETE FROM \(tableName)"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil)     == SQLITE_OK
        {
            //run the query
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) table truncated.")
            }
        }
        else
        {
            print("\(tableName) table could not be truncated.")
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
                print("Successfully updated row.")
            }
            else
            {
                print("Could not update row.")
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
                raffle_description CHAR(255) NOT NULL,
                draw_date CHAR(255) NOT NULL,
                start_date CHAR(255) NOT NULL,
                price REAL NOT NULL,
                prize INTEGER NOT NULL,
                max INTEGER NOT NULL,
                current INTEGER DEFAULT 0,
                margin INTEGER DEFAULT 0,
                archived INTEGER DEFAULT 0
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
                postcode INTEGER NOT NULL,
                archived INTEGER DEFAULT 0
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
                sold TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                win INTEGER DEFAULT 0,
                FOREIGN KEY (raffle_id) REFERENCES raffle (raffle_id),
                FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
            );
            """
        createTableWithQuery(createTicketTableQuery, tableName: "ticket")
    }

    func insert(raffle:Raffle){
        let insertStatementQuery = "INSERT INTO raffle (raffle_name, raffle_description, draw_date, start_date, price, prize, max, margin) VALUES (?,?,?,?,?,?,?,?);"
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_text(insertStatement, 1, NSString(string:raffle.raffle_name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string:raffle.raffle_description).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string:raffle.draw_date).utf8String, -1, nil) // must take date as 'YYYY-MM-DD HH:MM:SS.SSS'
            sqlite3_bind_text(insertStatement, 4, NSString(string:raffle.start_date).utf8String, -1, nil) // must take date as 'YYYY-MM-DD HH:MM:SS.SSS'
            sqlite3_bind_double(insertStatement, 5, raffle.price)
            sqlite3_bind_int(insertStatement, 6, raffle.prize)
            sqlite3_bind_int(insertStatement, 7, raffle.max)
            sqlite3_bind_int(insertStatement, 8, raffle.margin ? 1 : 0) //Typecast bool to int
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
        let insertStatementQuery = "INSERT INTO ticket (raffle_id, customer_id, number) VALUES (?,?,?);"
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_int(insertStatement, 1, ticket.raffle_id)
            sqlite3_bind_int(insertStatement, 2, ticket.customer_id)
            sqlite3_bind_int(insertStatement, 3, ticket.number)
        })
    }
    
    func update(raffle:Raffle){
        let updateStatementQuery = "UPDATE raffle SET raffle_name=?, raffle_description=?, draw_date=?, start_date=?, price=?, prize=?, max=?, current=?, margin=?,  archived=? WHERE raffle_id=?;"
        updateWithQuery(updateStatementQuery, bindingFunction: { (updateStatement) in
            sqlite3_bind_text(updateStatement, 1, NSString(string:raffle.raffle_name).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, NSString(string:raffle.raffle_description).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, NSString(string:raffle.draw_date).utf8String, -1, nil) // must take date as 'YYYY-MM-DD HH:MM:SS.SSS'
            sqlite3_bind_text(updateStatement, 4, NSString(string:raffle.start_date).utf8String, -1, nil) // must take date as 'YYYY-MM-DD HH:MM:SS.SSS'
            sqlite3_bind_double(updateStatement, 5, raffle.price)
            sqlite3_bind_int(updateStatement, 6, raffle.prize)
            sqlite3_bind_int(updateStatement, 7, raffle.max)
            sqlite3_bind_int(updateStatement, 8, raffle.current)
            sqlite3_bind_int(updateStatement, 9, raffle.margin ? 1 : 0) //Typecast bool to int
            sqlite3_bind_int(updateStatement, 10, raffle.archived ? 1 : 0) //Typecast bool to int
            sqlite3_bind_int(updateStatement, 11, raffle.raffle_id)
        })
    }
    
    func update(customer:Customer){
        let updateStatementQuery = "UPDATE customer SET customer_name=?, email=?, phone=?, postcode=?, archived=? where customer_id=?;"
        updateWithQuery(updateStatementQuery, bindingFunction: { (updateStatement) in
            sqlite3_bind_text(updateStatement, 1, NSString(string:customer.customer_name).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, NSString(string:customer.email).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, customer.phone)
            sqlite3_bind_int(updateStatement, 4, customer.postcode)
            sqlite3_bind_int(updateStatement, 5, customer.archived ? 1 : 0) //Typecast bool to int
            sqlite3_bind_int(updateStatement, 6, customer.customer_id)
        })
    }
    
    func update(ticket:Ticket){
        let updateStatementQuery = "UPDATE ticket SET raffle_id=?, customer_id=?, number=?, win=? where ticket_id=?;"
        updateWithQuery(updateStatementQuery, bindingFunction: { (updateStatement) in
            sqlite3_bind_int(updateStatement, 1, ticket.raffle_id)
            sqlite3_bind_int(updateStatement, 2, ticket.customer_id)
            sqlite3_bind_int(updateStatement, 3, ticket.number)
            sqlite3_bind_int(updateStatement, 4, ticket.win)
            sqlite3_bind_int(updateStatement, 5, ticket.ticket_id)
        })
    }
    
    
    func selectAllRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, raffle_description, draw_date, start_date, price, prize, max, current, margin, archived,  FROM raffle;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                raffle_description: String(cString:sqlite3_column_text(row, 2)),
                draw_date: String(cString:sqlite3_column_text(row, 3)),
                start_date: String(cString:sqlite3_column_text(row, 4)),
                price: sqlite3_column_double(row, 5),
                prize: sqlite3_column_int(row, 6),
                max: sqlite3_column_int(row, 7),
                current: sqlite3_column_int(row, 8),
                margin: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                archived: Bool(truncating: sqlite3_column_int(row, 10) as NSNumber)
            )
            result += [raffle]
        })
        return result
    }
    
    func selectAllActiveRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, raffle_description, draw_date, start_date, price, prize, max, current, margin, archived FROM raffle WHERE DATE(draw_date) > DATE('now') and archived = 0;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                raffle_description: String(cString:sqlite3_column_text(row, 2)),
                draw_date: String(cString:sqlite3_column_text(row, 3)),
                start_date: String(cString:sqlite3_column_text(row, 4)),
                price: sqlite3_column_double(row, 5),
                prize: sqlite3_column_int(row, 6),
                max: sqlite3_column_int(row, 7),
                current: sqlite3_column_int(row, 8),
                margin: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                archived: Bool(truncating: sqlite3_column_int(row, 10) as NSNumber)
            )
            result += [raffle]
        })
        return result
    }
    
    func selectAllInactiveRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, raffle_description, draw_date, start_date, price, prize, max, current, margin, archived FROM raffle WHERE DATE(draw_date) < DATE('now') or archived = 1;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                raffle_description: String(cString:sqlite3_column_text(row, 2)),
                draw_date: String(cString:sqlite3_column_text(row, 3)),
                start_date: String(cString:sqlite3_column_text(row, 4)),
                price: sqlite3_column_double(row, 5),
                prize: sqlite3_column_int(row, 6),
                max: sqlite3_column_int(row, 7),
                current: sqlite3_column_int(row, 8),
                margin: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                archived: Bool(truncating: sqlite3_column_int(row, 10) as NSNumber)
            )
            result += [raffle]
        })
        return result
    }
    
    func selectAllNonArchivedRaffles() -> [Raffle]
    {
        var result = [Raffle]()
        let selectStatementQuery = "SELECT raffle_id, raffle_name, raffle_description, draw_date, start_date, price, prize, max, current, margin, archived FROM raffle WHERE archived = 0;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                raffle_description: String(cString:sqlite3_column_text(row, 2)),
                draw_date: String(cString:sqlite3_column_text(row, 3)),
                start_date: String(cString:sqlite3_column_text(row, 4)),
                price: sqlite3_column_double(row, 5),
                prize: sqlite3_column_int(row, 6),
                max: sqlite3_column_int(row, 7),
                current: sqlite3_column_int(row, 8),
                margin: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                archived: Bool(truncating: sqlite3_column_int(row, 10) as NSNumber)
            )
            result += [raffle]
        })
        return result
    }
    
    func selectRaffleByID(raffle_id:Int32) -> Raffle
    {
        var result:Raffle = Raffle(raffle_id: 0, raffle_name: "", raffle_description: "", draw_date: "", start_date: "", price: 0, prize: 0, max: 0, current: 0, margin: false, archived: false)
        let selectStatementQuery = "SELECT raffle_id, raffle_name, raffle_description, draw_date, start_date, price, prize, max, current, margin, archived FROM raffle WHERE raffle_id = ?;"

        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let raffle = Raffle(
                raffle_id: sqlite3_column_int(row, 0),
                raffle_name: String(cString:sqlite3_column_text(row, 1)),
                raffle_description: String(cString:sqlite3_column_text(row, 2)),
                draw_date: String(cString:sqlite3_column_text(row, 3)),
                start_date: String(cString:sqlite3_column_text(row, 4)),
                price: sqlite3_column_double(row, 5),
                prize: sqlite3_column_int(row, 6),
                max: sqlite3_column_int(row, 7),
                current: sqlite3_column_int(row, 8),
                margin: Bool(truncating: sqlite3_column_int(row, 9) as NSNumber),
                archived: Bool(truncating: sqlite3_column_int(row, 11) as NSNumber)
                )
                result = raffle
            },
            bindingFunction: { (insertStatement) in
                sqlite3_bind_int(insertStatement, 1, raffle_id)
            }
        )
        return result
   }
    
    func selectAllCustomers() -> [Customer]
    {
        var result = [Customer]()
        let selectStatementQuery = "SELECT customer_id, customer_name, email, phone, postcode, archived FROM customer;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let customer = Customer(
                customer_id: sqlite3_column_int(row, 0),
                customer_name: String(cString:sqlite3_column_text(row, 1)),
                email: String(cString:sqlite3_column_text(row, 2)),
                phone: sqlite3_column_int(row, 3),
                postcode: sqlite3_column_int(row, 4),
                archived: Bool(truncating: sqlite3_column_int(row, 5) as NSNumber)
            )
            result += [customer]
        })
        return result
    }
    
    func selectAllActiveCustomers() -> [Customer]
    {
        var result = [Customer]()
        let selectStatementQuery = "SELECT customer_id, customer_name, email, phone, postcode, archived FROM customer WHERE archived = 0;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let customer = Customer(
                customer_id: sqlite3_column_int(row, 0),
                customer_name: String(cString:sqlite3_column_text(row, 1)),
                email: String(cString:sqlite3_column_text(row, 2)),
                phone: sqlite3_column_int(row, 3),
                postcode: sqlite3_column_int(row, 4),
                archived: Bool(truncating: sqlite3_column_int(row, 5) as NSNumber)
            )
            result += [customer]
        })
        return result
    }
    
    func selectCustomerByID(customer_id:Int32) -> Customer
    {
        var result:Customer = Customer(customer_id: 0, customer_name: "", email: "", phone: 0, postcode: 0, archived: false)
        let selectStatementQuery = "SELECT customer_id, customer_name, email, phone, postcode, archived FROM customer where customer_id = ?;"
           
           selectWithQuery(selectStatementQuery,
                           eachRow: { (row) in
                               let customer = Customer(
                                   customer_id: sqlite3_column_int(row, 0),
                                   customer_name: String(cString:sqlite3_column_text(row, 1)),
                                   email: String(cString:sqlite3_column_text(row, 2)),
                                   phone: sqlite3_column_int(row, 3),
                                   postcode: sqlite3_column_int(row, 4),
                                   archived: Bool(truncating: sqlite3_column_int(row, 5) as NSNumber)
                               )
                               result = customer
                           },
                           bindingFunction: { (insertStatement) in
                               sqlite3_bind_int(insertStatement, 1, customer_id)
                           }
           )
           return result
       }
    
    func selectAllTickets() -> [Ticket]
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket;"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            let ticket = Ticket(
                ticket_id: sqlite3_column_int(row, 0),
                raffle_id: sqlite3_column_int(row, 1),
                customer_id: sqlite3_column_int(row, 2),
                number: sqlite3_column_int(row, 3),
                sold: String(cString:sqlite3_column_text(row, 4)),
                win: sqlite3_column_int(row, 5)
            )
            result += [ticket]
        })
        return result
    }
    
    func selectTicketsByRaffle(raffle_id:Int32) -> [Ticket] //Can change to pass Raffle as parameter instead
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket where raffle_id = ?;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                sold: String(cString:sqlite3_column_text(row, 4)),
                                win: sqlite3_column_int(row, 5)
                            )
                            result += [ticket]
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                        }
        )
        return result
    }
    
    func selectWinningTicketsByRaffle(raffle_id:Int32) -> [Ticket] //Can change to pass Raffle as parameter instead
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket where raffle_id = ? and win <> 0 order by win;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                sold: String(cString:sqlite3_column_text(row, 4)),
                                win: sqlite3_column_int(row, 5)
                            )
                            result += [ticket]
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                        }
        )
        return result
    }
    
    func selectWinningMarginTicketByRaffle(raffle_id:Int32, margin:Int32) -> Ticket
    {
        var result: Ticket?
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket where raffle_id = ? and win == 0 and number = ?;"
        print("Select: \(margin)")
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                sold: String(cString:sqlite3_column_text(row, 4)),
                                win: sqlite3_column_int(row, 5)
                            )
                            result = ticket
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                            sqlite3_bind_int(insertStatement, 2, margin)
                        }
        )
        return result ?? Ticket(raffle_id: -2, customer_id: -1, number: -2, win: -1)
    }
    
    func selectNonWinningTicketsByRaffle(raffle_id:Int32) -> [Ticket] //Can change to pass Raffle as parameter instead
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket where raffle_id = ? and win = 0;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                sold: String(cString:sqlite3_column_text(row, 4)),
                                win: sqlite3_column_int(row, 5)
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
        let selectStatementQuery = "SELECT ticket_id, raffle_id, customer_id, number, sold, win FROM ticket where raffle_id = ? and customer_id = ?;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            let ticket = Ticket(
                                ticket_id: sqlite3_column_int(row, 0),
                                raffle_id: sqlite3_column_int(row, 1),
                                customer_id: sqlite3_column_int(row, 2),
                                number: sqlite3_column_int(row, 3),
                                sold: String(cString:sqlite3_column_text(row, 4)),
                                win: sqlite3_column_int(row, 5)
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
    
    func selectWinningTicketCountByRaffle(raffle_id:Int32) -> Int32
    {
        var result:Int32 = 0
        let selectStatementQuery = "SELECT count(*) FROM ticket where raffle_id = ? and win <> 0;"
        
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
    
    func selectSoldTicketNumbersByRaffle(raffle_id:Int32) -> [Int32]
    {
        var result = [Int32]()
        let selectStatementQuery = "SELECT distinct number FROM ticket where raffle_id = ? and win <> 0 order by number;"
        
        selectWithQuery(selectStatementQuery,
                        eachRow: { (row) in
                            result += [sqlite3_column_int(row, 0)]
                        },
                        bindingFunction: { (insertStatement) in
                            sqlite3_bind_int(insertStatement, 1, raffle_id)
                        }
        )
        return result
    }
    
}
