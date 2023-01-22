import Foundation

struct Highlight: Codable {
    let bookID: String
    let section: String?
    let selectedText: String?
    let note: String?
    let creationDate: Double?
    
    enum CodingKeys: String, CodingKey {
        case bookID = "ZANNOTATIONASSETID"
        case section = "ZFUTUREPROOFING5"
        case selectedText = "ZANNOTATIONSELECTEDTEXT"
        case note = "ZANNOTATIONNOTE"
        case creationDate = "ZANNOTATIONCREATIONDATE"
    }
}

