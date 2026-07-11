// quotes.js
const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

class QuoteManager {
    constructor() {
        this.quotes = [];
        this.loadDefaults();
    }

    loadDefaults() {
        this.quotes = [
            { id: 1, text: "Talk is cheap. Show me the code.", author: "Linus Torvalds", category: "wisdom" },
            { id: 2, text: "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", author: "Linus Torvalds", category: "fun" },
            { id: 3, text: "The best way to predict the future is to implement it.", author: "Alan Kay", category: "wisdom" },
            { id: 4, text: "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", author: "Martin Fowler", category: "wisdom" },
            { id: 5, text: "First, solve the problem. Then, write the code.", author: "John Johnson", category: "wisdom" },
            { id: 6, text: "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", author: "Joyce Wheeler", category: "wisdom" },
            { id: 7, text: "Simplicity is the soul of efficiency.", author: "Austin Freeman", category: "wisdom" },
            { id: 8, text: "The only way to learn a new programming language is by writing programs in it.", author: "Dennis Ritchie", category: "learning" },
            { id: 9, text: "If debugging is the process of removing bugs, then programming must be the process of putting them in.", author: "Edsger Dijkstra", category: "humor" },
            { id: 10, text: "It's not a bug – it's an undocumented feature.", author: "Anonymous", category: "humor" },
            { id: 11, text: "Software is a great combination between artistry and engineering.", author: "Bill Gates", category: "wisdom" },
            { id: 12, text: "In theory, there is no difference between theory and practice. But in practice, there is.", author: "Jan L. A. van de Snepscheut", category: "humor" },
            { id: 13, text: "The most important property of a program is whether it accomplishes the intention of its user.", author: "C.A.R. Hoare", category: "wisdom" },
            { id: 14, text: "The computer was born to solve problems that did not exist before.", author: "Bill Gates", category: "wisdom" },
            { id: 15, text: "One of the best programming skills you can have is knowing when to walk away for a while.", author: "Oscar Godson", category: "wisdom" },
        ];
    }

    getRandom() {
        if (this.quotes.length === 0) return null;
        return this.quotes[Math.floor(Math.random() * this.quotes.length)];
    }

    getAll() { return this.quotes; }

    getByAuthor(author) {
        return this.quotes.filter(q => q.author.toLowerCase().includes(author.toLowerCase()));
    }

    getByCategory(category) {
        return this.quotes.filter(q => q.category.toLowerCase() === category.toLowerCase());
    }

    getCategories() {
        return [...new Set(this.quotes.map(q => q.category))].sort();
    }

    add(text, author, category = "general") {
        const id = this.quotes.length ? this.quotes[this.quotes.length-1].id + 1 : 1;
        const quote = { id, text, author, category };
        this.quotes.push(quote);
        return quote;
    }

    remove(id) {
        const idx = this.quotes.findIndex(q => q.id === id);
        if (idx === -1) return false;
        this.quotes.splice(idx, 1);
        return true;
    }

    saveToFile(filename) {
        fs.writeFileSync(filename, JSON.stringify(this.quotes, null, 2), 'utf8');
    }

    loadFromFile(filename) {
        try {
            const data = fs.readFileSync(filename, 'utf8');
            this.quotes = JSON.parse(data);
        } catch (e) {
            console.log(`Error loading ${filename}: ${e.message}`);
        }
    }
}

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

function displayQuote(q) {
    if (!q) {
        console.log("No quotes available.");
        return;
    }
    console.log(`\n💬 "${q.text}"\n   – ${q.author} (${q.category})`);
}

async function main() {
    const manager = new QuoteManager();
    console.log("=== Programmer Quotes ===");
    while (true) {
        console.log("\n1. Get a random quote");
        console.log("2. Show all quotes");
        console.log("3. Search by author");
        console.log("4. Search by category");
        console.log("5. Add a quote");
        console.log("6. Remove a quote");
        console.log("7. Show categories");
        console.log("8. Save quotes to file");
        console.log("9. Load quotes from file");
        console.log("10. Exit");
        const choice = await ask("Choose: ");
        switch (choice.trim()) {
            case "1": {
                displayQuote(manager.getRandom());
                break;
            }
            case "2": {
                const quotes = manager.getAll();
                if (quotes.length === 0) console.log("No quotes.");
                else {
                    console.log("\nAll quotes:");
                    quotes.forEach(q => {
                        console.log(`[${q.id}] "${q.text}" – ${q.author} (${q.category})`);
                    });
                }
                break;
            }
            case "3": {
                const author = await ask("Author: ");
                if (!author.trim()) { console.log("Author cannot be empty."); break; }
                const results = manager.getByAuthor(author);
                if (results.length === 0) console.log(`No quotes by '${author}'.`);
                else {
                    console.log(`\nFound ${results.length} quote(s) by ${author}:`);
                    results.forEach(q => console.log(`[${q.id}] "${q.text}" (${q.category})`));
                }
                break;
            }
            case "4": {
                const category = await ask("Category: ");
                if (!category.trim()) { console.log("Category cannot be empty."); break; }
                const results = manager.getByCategory(category);
                if (results.length === 0) console.log(`No quotes in category '${category}'.`);
                else {
                    console.log(`\nQuotes in category '${category}':`);
                    results.forEach(q => console.log(`[${q.id}] "${q.text}" – ${q.author}`));
                }
                break;
            }
            case "5": {
                const text = await ask("Enter quote: ");
                if (!text.trim()) { console.log("Quote cannot be empty."); break; }
                const author = await ask("Author: ");
                if (!author.trim()) { console.log("Author cannot be empty."); break; }
                const category = await ask("Category (optional): ");
                const q = manager.add(text.trim(), author.trim(), category.trim() || "general");
                console.log(`Quote added with ID ${q.id}.`);
                break;
            }
            case "6": {
                const idStr = await ask("Enter quote ID to remove: ");
                const id = parseInt(idStr, 10);
                if (isNaN(id)) { console.log("Invalid ID."); break; }
                if (manager.remove(id)) console.log("Quote removed.");
                else console.log("Quote not found.");
                break;
            }
            case "7": {
                const cats = manager.getCategories();
                if (cats.length === 0) console.log("No categories.");
                else console.log("Categories:", cats.join(", "));
                break;
            }
            case "8": {
                const fname = await ask("Filename: ");
                manager.saveToFile(fname);
                console.log(`Saved to ${fname}.`);
                break;
            }
            case "9": {
                const fname = await ask("Filename: ");
                manager.loadFromFile(fname);
                console.log(`Loaded from ${fname}.`);
                break;
            }
            case "10":
                console.log("Goodbye! 💻");
                rl.close();
                return;
            default:
                console.log("Invalid choice.");
        }
    }
}

main().catch(console.error);
