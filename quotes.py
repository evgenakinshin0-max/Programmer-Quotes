# quotes.py
import json
import random
from typing import List, Dict, Optional

class QuoteManager:
    def __init__(self):
        self.quotes: List[Dict] = []
        self._load_defaults()

    def _load_defaults(self):
        self.quotes = [
            {"id": 1, "text": "Talk is cheap. Show me the code.", "author": "Linus Torvalds", "category": "wisdom"},
            {"id": 2, "text": "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", "author": "Linus Torvalds", "category": "fun"},
            {"id": 3, "text": "The best way to predict the future is to implement it.", "author": "Alan Kay", "category": "wisdom"},
            {"id": 4, "text": "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", "author": "Martin Fowler", "category": "wisdom"},
            {"id": 5, "text": "First, solve the problem. Then, write the code.", "author": "John Johnson", "category": "wisdom"},
            {"id": 6, "text": "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", "author": "Joyce Wheeler", "category": "wisdom"},
            {"id": 7, "text": "Simplicity is the soul of efficiency.", "author": "Austin Freeman", "category": "wisdom"},
            {"id": 8, "text": "The only way to learn a new programming language is by writing programs in it.", "author": "Dennis Ritchie", "category": "learning"},
            {"id": 9, "text": "If debugging is the process of removing bugs, then programming must be the process of putting them in.", "author": "Edsger Dijkstra", "category": "humor"},
            {"id": 10, "text": "It's not a bug – it's an undocumented feature.", "author": "Anonymous", "category": "humor"},
            {"id": 11, "text": "Software is a great combination between artistry and engineering.", "author": "Bill Gates", "category": "wisdom"},
            {"id": 12, "text": "In theory, there is no difference between theory and practice. But in practice, there is.", "author": "Jan L. A. van de Snepscheut", "category": "humor"},
            {"id": 13, "text": "The most important property of a program is whether it accomplishes the intention of its user.", "author": "C.A.R. Hoare", "category": "wisdom"},
            {"id": 14, "text": "The computer was born to solve problems that did not exist before.", "author": "Bill Gates", "category": "wisdom"},
            {"id": 15, "text": "One of the best programming skills you can have is knowing when to walk away for a while.", "author": "Oscar Godson", "category": "wisdom"},
        ]

    def get_random(self) -> Optional[Dict]:
        return random.choice(self.quotes) if self.quotes else None

    def get_all(self) -> List[Dict]:
        return self.quotes

    def get_by_author(self, author: str) -> List[Dict]:
        return [q for q in self.quotes if author.lower() in q["author"].lower()]

    def get_by_category(self, category: str) -> List[Dict]:
        return [q for q in self.quotes if q["category"].lower() == category.lower()]

    def get_categories(self) -> List[str]:
        return sorted(set(q["category"] for q in self.quotes))

    def add(self, text: str, author: str, category: str = "general") -> Dict:
        new_id = max(q["id"] for q in self.quotes) + 1 if self.quotes else 1
        quote = {"id": new_id, "text": text, "author": author, "category": category}
        self.quotes.append(quote)
        return quote

    def remove(self, qid: int) -> bool:
        for i, q in enumerate(self.quotes):
            if q["id"] == qid:
                del self.quotes[i]
                return True
        return False

    def save_to_file(self, filename: str):
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(self.quotes, f, indent=2, ensure_ascii=False)

    def load_from_file(self, filename: str):
        try:
            with open(filename, 'r', encoding='utf-8') as f:
                self.quotes = json.load(f)
        except FileNotFoundError:
            print(f"File {filename} not found.")

def display_quote(q):
    if not q:
        print("No quotes available.")
        return
    print(f"\n💬 \"{q['text']}\"\n   – {q['author']} ({q['category']})")

def main():
    manager = QuoteManager()
    print("=== Programmer Quotes ===")
    while True:
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
        choice = input("Choose: ").strip()
        if choice == "1":
            display_quote(manager.get_random())
        elif choice == "2":
            quotes = manager.get_all()
            if not quotes:
                print("No quotes.")
            else:
                print("\nAll quotes:")
                for q in quotes:
                    print(f"[{q['id']}] \"{q['text']}\" – {q['author']} ({q['category']})")
        elif choice == "3":
            author = input("Author: ").strip()
            if not author:
                print("Author cannot be empty.")
                continue
            results = manager.get_by_author(author)
            if not results:
                print(f"No quotes by '{author}'.")
            else:
                print(f"\nFound {len(results)} quote(s) by {author}:")
                for q in results:
                    print(f"[{q['id']}] \"{q['text']}\" ({q['category']})")
        elif choice == "4":
            category = input("Category: ").strip()
            if not category:
                print("Category cannot be empty.")
                continue
            results = manager.get_by_category(category)
            if not results:
                print(f"No quotes in category '{category}'.")
            else:
                print(f"\nQuotes in category '{category}':")
                for q in results:
                    print(f"[{q['id']}] \"{q['text']}\" – {q['author']}")
        elif choice == "5":
            text = input("Enter quote: ").strip()
            if not text:
                print("Quote cannot be empty.")
                continue
            author = input("Author: ").strip()
            if not author:
                print("Author cannot be empty.")
                continue
            category = input("Category (optional): ").strip() or "general"
            new_q = manager.add(text, author, category)
            print(f"Quote added with ID {new_q['id']}.")
        elif choice == "6":
            try:
                qid = int(input("Enter quote ID to remove: ").strip())
                if manager.remove(qid):
                    print("Quote removed.")
                else:
                    print("Quote not found.")
            except ValueError:
                print("Invalid ID.")
        elif choice == "7":
            cats = manager.get_categories()
            if cats:
                print("Categories:", ", ".join(cats))
            else:
                print("No categories.")
        elif choice == "8":
            fname = input("Filename: ").strip()
            manager.save_to_file(fname)
            print(f"Saved to {fname}.")
        elif choice == "9":
            fname = input("Filename: ").strip()
            manager.load_from_file(fname)
            print(f"Loaded from {fname}.")
        elif choice == "10":
            print("Goodbye! 💻")
            break
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()
