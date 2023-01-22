import SQLite

enum BookDatabase {
    
    static let defaultPath = "/Library/Containers/com.apple.iBooksX/Data/Documents/BKLibrary"
    
    static let table = "ZBKLIBRARYASSET"
    
    enum Keys: String {
        case bookID = "ZASSETID"
        case title = "ZTITLE"
        case author = "ZAUTHOR"
    }
    
}

