import SQLite

struct DatabaseConnection {
    private let pathBuilder: PathBuilder
    
    init(pathBuilder: PathBuilder = PathBuilder()) {
        self.pathBuilder = pathBuilder
    }
    
    public func connect(to path: String) -> Connection? {
        return try? Connection(path, readonly: true)
    }
    
}
