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
        let id = Expression<String>(BookDatabase.Keys.bookID.rawValue)
        let title = Expression<String>(BookDatabase.Keys.title.rawValue)
        let author = Expression<String>(BookDatabase.Keys.author.rawValue)
        
        let query = table.select(id, title, author)
        
        guard let rows = try? database.prepare(query) else { return [] }
        
        return rows.reduce(into: [Book]()) { partialResult, row in
            let book = Book(id: row[id], title: row[title], author: row[author])
            partialResult.append(book)
        }
    }
}

