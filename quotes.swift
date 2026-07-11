// quotes.swift
import Foundation

struct Quote: Codable {
    let id: Int
    let text: String
    let author: String
    let category: String
}

class QuoteManager {
    private var quotes: [Quote] = []

    init() {
        loadDefaults()
    }

    private func loadDefaults() {
        quotes = [
            Quote(id: 1, text: "Talk is cheap. Show me the code.", author: "Linus Torvalds", category: "wisdom"),
            Quote(id: 2, text: "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", author: "Linus Torvalds", category: "fun"),
            Quote(id: 3, text: "The best way to predict the future is to implement it.", author: "Alan Kay", category: "wisdom"),
            Quote(id: 4, text: "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", author: "Martin Fowler", category: "wisdom"),
            Quote(id: 5, text: "First, solve the problem. Then, write the code.", author: "John Johnson", category: "wisdom"),
            Quote(id: 6, text: "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", author: "Joyce Wheeler", category: "wisdom"),
            Quote(id: 7, text: "Simplicity is the soul of efficiency.", author: "Austin Freeman", category: "wisdom"),
            Quote(id: 8, text: "The only way to learn a new programming language is by writing programs in it.", author: "Dennis Ritchie", category: "learning"),
            Quote(id: 9, text: "If debugging is the process of removing bugs, then programming must be the process of putting them in.", author: "Edsger Dijkstra", category: "humor"),
            Quote(id: 10, text: "It's not a bug – it's an undocumented feature.", author: "Anonymous", category: "humor"),
            Quote(id: 11, text: "Software is a great combination between artistry and engineering.", author: "Bill Gates", category: "wisdom"),
            Quote(id: 12, text: "In theory, there is no difference between theory and practice. But in practice, there is.", author: "Jan L. A. van de Snepscheut", category: "humor"),
            Quote(id: 13, text: "The most important property of a program is whether it accomplishes the intention of its user.", author: "C.A.R. Hoare", category: "wisdom"),
            Quote(id: 14, text: "The computer was born to solve problems that did not exist before.", author: "Bill Gates", category: "wisdom"),
            Quote(id: 15, text: "One of the best programming skills you can have is knowing when to walk away for a while.", author: "Oscar Godson", category: "wisdom"),
        ]
    }

    func random() -> Quote? {
        return quotes.randomElement()
    }

    func all() -> [Quote] {
        return quotes
    }

    func byAuthor(_ author: String) -> [Quote] {
        return quotes.filter { $0.author.lowercased().contains(author.lowercased()) }
    }

    func byCategory(_ category: String) -> [Quote] {
        return quotes.filter { $0.category.lowercased() == category.lowercased() }
    }

    func categories() -> [String] {
        return Set(quotes.map { $0.category }).sorted()
    }

    func add(text: String, author: String, category: String = "general") -> Quote {
        let id = (quotes.map { $0.id }.max() ?? 0) + 1
        let q = Quote(id: id, text: text, author: author, category: category)
        quotes.append(q)
        return q
    }

    func remove(id: Int) -> Bool {
        if let idx = quotes.firstIndex(where: { $0.id == id }) {
            quotes.remove(at: idx)
            return true
        }
        return false
    }

    func saveToFile(filename: String) throws {
        let data = try JSONEncoder().encode(quotes)
        try data.write(to: URL(fileURLWithPath: filename))
    }

    func loadFromFile(filename: String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: filename))
        quotes = try JSONDecoder().decode([Quote].self, from: data)
    }

    func displayQuote(_ q: Quote?) {
        guard let q = q else {
            print("No quotes available.")
            return
        }
        print("\n💬 \"\(q.text)\"\n   – \(q.author) (\(q.category))")
    }
}

func main() {
    let manager = QuoteManager()
    print("=== Programmer Quotes ===")
    while true {
        print("\n1. Get a random quote")
        print("2. Show all quotes")
        print("3. Search by author")
        print("4. Search by category")
        print("5. Add a quote")
        print("6. Remove a quote")
        print("7. Show categories")
        print("8. Save quotes to file")
        print("9. Load quotes from file")
        print("10. Exit")
        print("Choose: ", terminator: "")
        guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
        switch choice {
        case "1":
            manager.displayQuote(manager.random())
        case "2":
            let quotes = manager.all()
            if quotes.isEmpty {
                print("No quotes.")
            } else {
                print("\nAll quotes:")
                for q in quotes {
                    print("[\(q.id)] \"\(q.text)\" – \(q.author) (\(q.category))")
                }
            }
        case "3":
            print("Author: ", terminator: "")
            guard let author = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !author.isEmpty else {
                print("Author cannot be empty.")
                continue
            }
            let results = manager.byAuthor(author)
            if results.isEmpty {
                print("No quotes by '\(author)'.")
            } else {
                print("\nFound \(results.count) quote(s) by \(author):")
                for q in results {
                    print("[\(q.id)] \"\(q.text)\" (\(q.category))")
                }
            }
        case "4":
            print("Category: ", terminator: "")
            guard let category = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !category.isEmpty else {
                print("Category cannot be empty.")
                continue
            }
            let results = manager.byCategory(category)
            if results.isEmpty {
                print("No quotes in category '\(category)'.")
            } else {
                print("\nQuotes in category '\(category)':")
                for q in results {
                    print("[\(q.id)] \"\(q.text)\" – \(q.author)")
                }
            }
        case "5":
            print("Enter quote: ", terminator: "")
            guard let text = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
                print("Quote cannot be empty.")
                continue
            }
            print("Author: ", terminator: "")
            guard let author = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !author.isEmpty else {
                print("Author cannot be empty.")
                continue
            }
            print("Category (optional): ", terminator: "")
            let category = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "general"
            let q = manager.add(text: text, author: author, category: category.isEmpty ? "general" : category)
            print("Quote added with ID \(q.id).")
        case "6":
            print("Enter quote ID to remove: ", terminator: "")
            guard let idStr = readLine(), let id = Int(idStr.trimmingCharacters(in: .whitespaces)) else {
                print("Invalid ID.")
                continue
            }
            if manager.remove(id: id) {
                print("Quote removed.")
            } else {
                print("Quote not found.")
            }
        case "7":
            let cats = manager.categories()
            if cats.isEmpty {
                print("No categories.")
            } else {
                print("Categories: \(cats.joined(separator: ", "))")
            }
        case "8":
            print("Filename: ", terminator: "")
            guard let fname = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
            do {
                try manager.saveToFile(filename: fname)
                print("Saved to \(fname).")
            } catch {
                print("Error saving: \(error)")
            }
        case "9":
            print("Filename: ", terminator: "")
            guard let fname = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
            do {
                try manager.loadFromFile(filename: fname)
                print("Loaded from \(fname).")
            } catch {
                print("Error loading: \(error)")
            }
        case "10":
            print("Goodbye! 💻")
            return
        default:
            print("Invalid choice.")
        }
    }
}

main()
