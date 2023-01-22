import SQLite
import FileProvider

final class HighlightService {
    
    private let bookID: String
    private let fileWriteService: FileWriteService
    private let databaseConnection: DatabaseConnection
    private let pathBuilder: PathBuilder
    private let outputBuilder: OutputBuilder
    
    private var database: Connection?
    
    init(
        bookID: String,
        fileWriteService: FileWriteService,
        databaseConnection: DatabaseConnection,
        pathBuilder: PathBuilder,
        outputBuilder: OutputBuilder
    ) {
        self.bookID = bookID
        self.fileWriteService = fileWriteService
        self.databaseConnection = databaseConnection
        self.pathBuilder = pathBuilder
        self.outputBuilder = outputBuilder
        setupDatabase()
    }
    
    private func getHighlights() -> [Highlight] {
        guard let database = database else { return [] }
        let table = Table(HighlightDatabase.table)
        
        let highlightCreationDateExpression = Expression<String?>(Highlight.CodingKeys.creationDate.rawValue)
        let bookIDExpression = Expression<String>(Highlight.CodingKeys.bookID.rawValue)
        let query = table.where(bookID == bookIDExpression).order(highlightCreationDateExpression.asc)
        
        let highlights: [Highlight]? = try? database.prepare(query).map { row in
            return try row.decode()
        }
        guard let highlights = highlights else { return [] }
        return highlights
    }
    
    public func generateOutputFile() {
        do {
            let highlights = getHighlights()
            try highlights.forEach { highlight in
                let output = outputBuilder.generateOutput(for: highlight)
                try fileWriteService.writeToFile(value: output)
            }
            try fileWriteService.closeFile()
        } catch {
            print(error)
        }
    }
    
    private func setupDatabase() {
        guard let annotationsDatabasePath = pathBuilder.filePath(in: HighlightDatabase.defaultPath) else { return }
        database = databaseConnection.connect(to: annotationsDatabasePath)
    }
}
