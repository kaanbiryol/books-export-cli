import SQLite

enum HighlightDatabase {
    
    static let defaultPath = "/Library/Containers/com.apple.iBooksX/Data/Documents/AEAnnotation"
    
    static let table = "ZAEANNOTATION"
    
    enum Keys: String {
        case bookID = "ZANNOTATIONASSETID"
        case note = "ZANNOTATIONNOTE"
        case selectedText = "ZANNOTATIONSELECTEDTEXT"
    }
    
}

