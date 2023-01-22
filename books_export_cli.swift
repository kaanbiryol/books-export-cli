import Foundation
import ArgumentParser
import SQLite3

@main
struct BooksExport: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "view books and export highligts.",
        subcommands: [List.self, Highlights.self],
        defaultSubcommand: List.self
    )
}

extension BooksExport {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "print the list of books.")
        
        mutating func run() {
            let books = BookService(
                databaseConnection: Dependencies.databaseConnection,
                pathBuilder: Dependencies.pathBuilder
            )
            books.printBooks()
        }
    }
    
    struct Highlights: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Print the product of the values.")
        
        @Argument(help: "id of the book.")
        var bookID: String
        
        mutating func run() {
            let fileWriteService = FileWriteService(
                path: FileManager.default.currentDirectoryPath + "/output.txt"
            )
            let highlights = HighlightService(
                bookID: bookID,
                fileWriteService: fileWriteService,
                databaseConnection: Dependencies.databaseConnection,
                pathBuilder: Dependencies.pathBuilder
            )
            highlights.generateOutputFile()
        }
    }
}
