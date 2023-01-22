import Foundation
import FileProvider

final class FileWriteService {

    private let fileManager: FileManager
    
    private var file: FileHandle?
    
    public init(
        fileManager: FileManager = .default,
        path: String
    ) {
        self.fileManager = fileManager
        createFile(path: path)
    }
    
    private func createFile(path: String) {
        _ = fileManager.createFile(atPath: path, contents: nil)
        file = try? FileHandle(forUpdating: URL(filePath: path))
    }
    
    public func writeToFile(value: String) throws {
        guard let file = file else { throw CLIError.message("error opening file") }
        guard let data = value.data(using: .utf8) else { throw CLIError.message("error converting text to data") }
        try file.seekToEnd()
        try file.write(contentsOf: data)
    }
    
    public func closeFile() throws {
        try file?.close()
    }
    
}
