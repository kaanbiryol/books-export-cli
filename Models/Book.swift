import Foundation

struct Book: Codable {
    let id: String
    let title: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ZASSETID"
        case title = "ZTITLE"
        case author = "ZAUTHOR"
    }
}
