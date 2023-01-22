import SQLite
import SwiftyTextTable

final class BookService {
    
    private let databaseConnection: DatabaseConnection
    private let pathBuilder: PathBuilder
    
    private var database: Connection?
    
    public init(databaseConnection: DatabaseConnection, pathBuilder: PathBuilder) {
        self.databaseConnection = databaseConnection
        self.pathBuilder = pathBuilder
        setupDatabase()
    }
    
    public func printBooks() {
        let books = getBooks()
        let idColumn = TextTableColumn(header: "ID")
        let nameColumn = TextTableColumn(header: "Name")
        let authorColumn = TextTableColumn(header: "Author")
        
        var table = TextTable(columns: [idColumn, nameColumn, authorColumn])

        books.forEach {
            table.addRow(values: [
                $0.id, $0.title.prefix(30), $0.author.prefix(30)
            ])
        }
        let tableString = table.render()
        print(tableString)
    }
    
    private func setupDatabase() {
        guard let booksDatabasePath = pathBuilder.filePath(in: BookDatabase.defaultPath) else { return }
        database = databaseConnection.connect(to: booksDatabasePath)
    }
    
    private func getBooks() -> [Book] {
        guard let database = database else { return [] }
        let table = Table(BookDatabase.table)
        let books: [Book]? = try? database.prepare(table).map { row in
            return try row.decode()
        }
        guard let books = books else { return [] }
        return books
    }
}

