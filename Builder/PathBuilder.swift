import FileProvider

struct PathBuilder {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    public func filePath(in folderPath: String) -> String? {
        let fullPath = getUserPath() + folderPath
        guard let fileEnumarator = fileManager.enumerator(atPath: fullPath) else { return nil }
        for file in fileEnumarator {
            guard let fileName = file as? String else { continue }
            let filePath = fullPath + "/" + fileName
            let fileExtension = URL(filePath: fileName).pathExtension
            if fileExtension == "sqlite" { return filePath }
        }
        return nil
    }
    
    private func getUserPath() -> String {
        return fileManager.homeDirectoryForCurrentUser.relativePath
    }
    
}
