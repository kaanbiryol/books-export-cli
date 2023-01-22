import SQLite
import FileProvider

final class HighlightService {
    
    private let bookID: String
    private let fileWriteService: FileWriteService
    private let databaseConnection: DatabaseConnection
    private let pathBuilder: PathBuilder
    
    private var database: Connection?
    
    init(
        bookID: String,
        fileWriteService: FileWriteService,
        databaseConnection: DatabaseConnection,
        pathBuilder: PathBuilder
    ) {
        self.bookID = bookID
        self.fileWriteService = fileWriteService
        self.databaseConnection = databaseConnection
        self.pathBuilder = pathBuilder
        setup()
    }
    
    public func getHighlights() -> [Highlight] {
        guard let database = database else { return [] }
        let table = Table(HighlightDatabase.table)
        let note = Expression<String?>(HighlightDatabase.Keys.note.rawValue)
        let selectedText = Expression<String?>(HighlightDatabase.Keys.selectedText.rawValue)
        let bookID = Expression<String>(HighlightDatabase.Keys.bookID.rawValue)
        let query = table.select(note, selectedText).where(bookID == bookID)
        
        guard let rows = try? database.prepare(query) else { return [] }
        
        return rows.reduce(into: [Highlight]()) { partialResult, row in
            let highlight = Highlight(selectedText: row[selectedText], note: row[note])
            partialResult.append(highlight)
        }
    }
    
    public func generateOutputFile() {
        do {
            let highlights = getHighlights()
            try highlights.forEach { highlight in
                let output = generateOutput(for: highlight)
                try fileWriteService.writeToFile(value: output)
            }
            try fileWriteService.closeFile()
        } catch {
            fatalError()
        }
    }
    
    private func setup() {
        guard let annotationsDatabasePath = pathBuilder.filePath(in: HighlightDatabase.defaultPath) else { return }
        database = databaseConnection.connect(to: annotationsDatabasePath)
    }
    
    private func generateOutput(for highlight: Highlight) -> String {
        var output: String = ""
        if let selectedText = highlight.selectedText, !selectedText.isEmpty {
            output += selectedText
        }
        if let note = highlight.note, !note.isEmpty {
            output += "/n" + note + "/n"
        }
        return output
    }
}
