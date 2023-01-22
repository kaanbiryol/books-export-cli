final class OutputBuilder {
    
    private var previousHighlight: Highlight?
    
    public func generateOutput(for highlight: Highlight) -> String {
        var output: String = ""
        if let section = highlight.section?.trimmingCharacters(in: .whitespaces), !section.isEmpty {
            passSameSection(for: section, previousHighlight: previousHighlight, output: &output)
        }
        if let selectedText = highlight.selectedText?.trimmingCharacters(in: .whitespaces), !selectedText.isEmpty {
            output += "> " + removeExtraSpaces(input: selectedText)
        }
        if let note = highlight.note?.trimmingCharacters(in: .whitespaces), !note.isEmpty {
            output += "\n\n" + note
        }
        previousHighlight = highlight
        return output + "\n\n"
    }
    
    private func passSameSection(for section: String, previousHighlight: Highlight?, output: inout String) {
        guard let previousSection = previousHighlight?.section, !previousSection.isEmpty else {
            output += ("## " + section + "\n\n")
            return
        }
        if previousSection != section {
            output += ("## " + section + "\n\n")
        }
    }
    
    private func removeExtraSpaces(input: String) -> String {
        return String(input.filter { !"\n\t\r".contains($0) })
    }
}
