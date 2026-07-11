// Quotes.cs
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;

class Quote
{
    public int Id { get; set; }
    public string Text { get; set; }
    public string Author { get; set; }
    public string Category { get; set; }
}

class QuoteManager
{
    private List<Quote> quotes = new List<Quote>();
    private Random rand = new Random();

    public QuoteManager()
    {
        LoadDefaults();
    }

    private void LoadDefaults()
    {
        quotes = new List<Quote>
        {
            new Quote { Id = 1, Text = "Talk is cheap. Show me the code.", Author = "Linus Torvalds", Category = "wisdom" },
            new Quote { Id = 2, Text = "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", Author = "Linus Torvalds", Category = "fun" },
            new Quote { Id = 3, Text = "The best way to predict the future is to implement it.", Author = "Alan Kay", Category = "wisdom" },
            new Quote { Id = 4, Text = "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", Author = "Martin Fowler", Category = "wisdom" },
            new Quote { Id = 5, Text = "First, solve the problem. Then, write the code.", Author = "John Johnson", Category = "wisdom" },
            new Quote { Id = 6, Text = "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", Author = "Joyce Wheeler", Category = "wisdom" },
            new Quote { Id = 7, Text = "Simplicity is the soul of efficiency.", Author = "Austin Freeman", Category = "wisdom" },
            new Quote { Id = 8, Text = "The only way to learn a new programming language is by writing programs in it.", Author = "Dennis Ritchie", Category = "learning" },
            new Quote { Id = 9, Text = "If debugging is the process of removing bugs, then programming must be the process of putting them in.", Author = "Edsger Dijkstra", Category = "humor" },
            new Quote { Id = 10, Text = "It's not a bug – it's an undocumented feature.", Author = "Anonymous", Category = "humor" },
            new Quote { Id = 11, Text = "Software is a great combination between artistry and engineering.", Author = "Bill Gates", Category = "wisdom" },
            new Quote { Id = 12, Text = "In theory, there is no difference between theory and practice. But in practice, there is.", Author = "Jan L. A. van de Snepscheut", Category = "humor" },
            new Quote { Id = 13, Text = "The most important property of a program is whether it accomplishes the intention of its user.", Author = "C.A.R. Hoare", Category = "wisdom" },
            new Quote { Id = 14, Text = "The computer was born to solve problems that did not exist before.", Author = "Bill Gates", Category = "wisdom" },
            new Quote { Id = 15, Text = "One of the best programming skills you can have is knowing when to walk away for a while.", Author = "Oscar Godson", Category = "wisdom" },
        };
    }

    public Quote GetRandom()
    {
        if (quotes.Count == 0) return null;
        return quotes[rand.Next(quotes.Count)];
    }

    public List<Quote> GetAll() => quotes;

    public List<Quote> GetByAuthor(string author)
    {
        return quotes.Where(q => q.Author.Contains(author, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Quote> GetByCategory(string category)
    {
        return quotes.Where(q => q.Category.Equals(category, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<string> GetCategories()
    {
        return quotes.Select(q => q.Category).Distinct().OrderBy(c => c).ToList();
    }

    public Quote Add(string text, string author, string category = "general")
    {
        int id = quotes.Count > 0 ? quotes.Max(q => q.Id) + 1 : 1;
        var q = new Quote { Id = id, Text = text, Author = author, Category = category };
        quotes.Add(q);
        return q;
    }

    public bool Remove(int id)
    {
        var q = quotes.FirstOrDefault(x => x.Id == id);
        if (q == null) return false;
        quotes.Remove(q);
        return true;
    }

    public void SaveToFile(string filename)
    {
        var options = new JsonSerializerOptions { WriteIndented = true };
        string json = JsonSerializer.Serialize(quotes, options);
        File.WriteAllText(filename, json);
    }

    public void LoadFromFile(string filename)
    {
        if (!File.Exists(filename)) return;
        string json = File.ReadAllText(filename);
        quotes = JsonSerializer.Deserialize<List<Quote>>(json) ?? new List<Quote>();
    }

    public static void DisplayQuote(Quote q)
    {
        if (q == null)
        {
            Console.WriteLine("No quotes available.");
            return;
        }
        Console.WriteLine($"\n💬 \"{q.Text}\"\n   – {q.Author} ({q.Category})");
    }

    static void Main()
    {
        var manager = new QuoteManager();
        Console.WriteLine("=== Programmer Quotes ===");
        while (true)
        {
            Console.WriteLine("\n1. Get a random quote");
            Console.WriteLine("2. Show all quotes");
            Console.WriteLine("3. Search by author");
            Console.WriteLine("4. Search by category");
            Console.WriteLine("5. Add a quote");
            Console.WriteLine("6. Remove a quote");
            Console.WriteLine("7. Show categories");
            Console.WriteLine("8. Save quotes to file");
            Console.WriteLine("9. Load quotes from file");
            Console.WriteLine("10. Exit");
            Console.Write("Choose: ");
            string choice = Console.ReadLine()?.Trim() ?? "";
            switch (choice)
            {
                case "1":
                    DisplayQuote(manager.GetRandom());
                    break;
                case "2":
                    var all = manager.GetAll();
                    if (all.Count == 0) Console.WriteLine("No quotes.");
                    else
                    {
                        Console.WriteLine("\nAll quotes:");
                        foreach (var q in all)
                            Console.WriteLine($"[{q.Id}] \"{q.Text}\" – {q.Author} ({q.Category})");
                    }
                    break;
                case "3":
                    Console.Write("Author: ");
                    string author = Console.ReadLine()?.Trim() ?? "";
                    if (string.IsNullOrEmpty(author)) { Console.WriteLine("Author cannot be empty."); break; }
                    var results = manager.GetByAuthor(author);
                    if (results.Count == 0)
                        Console.WriteLine($"No quotes by '{author}'.");
                    else
                    {
                        Console.WriteLine($"\nFound {results.Count} quote(s) by {author}:");
                        foreach (var q in results)
                            Console.WriteLine($"[{q.Id}] \"{q.Text}\" ({q.Category})");
                    }
                    break;
                case "4":
                    Console.Write("Category: ");
                    string category = Console.ReadLine()?.Trim() ?? "";
                    if (string.IsNullOrEmpty(category)) { Console.WriteLine("Category cannot be empty."); break; }
                    var catResults = manager.GetByCategory(category);
                    if (catResults.Count == 0)
                        Console.WriteLine($"No quotes in category '{category}'.");
                    else
                    {
                        Console.WriteLine($"\nQuotes in category '{category}':");
                        foreach (var q in catResults)
                            Console.WriteLine($"[{q.Id}] \"{q.Text}\" – {q.Author}");
                    }
                    break;
                case "5":
                    Console.Write("Enter quote: ");
                    string text = Console.ReadLine()?.Trim() ?? "";
                    if (string.IsNullOrEmpty(text)) { Console.WriteLine("Quote cannot be empty."); break; }
                    Console.Write("Author: ");
                    string auth = Console.ReadLine()?.Trim() ?? "";
                    if (string.IsNullOrEmpty(auth)) { Console.WriteLine("Author cannot be empty."); break; }
                    Console.Write("Category (optional): ");
                    string cat = Console.ReadLine()?.Trim() ?? "general";
                    var qNew = manager.Add(text, auth, cat);
                    Console.WriteLine($"Quote added with ID {qNew.Id}.");
                    break;
                case "6":
                    Console.Write("Enter quote ID to remove: ");
                    if (int.TryParse(Console.ReadLine(), out int id))
                    {
                        if (manager.Remove(id)) Console.WriteLine("Quote removed.");
                        else Console.WriteLine("Quote not found.");
                    }
                    else Console.WriteLine("Invalid ID.");
                    break;
                case "7":
                    var cats = manager.GetCategories();
                    if (cats.Count == 0) Console.WriteLine("No categories.");
                    else Console.WriteLine("Categories: " + string.Join(", ", cats));
                    break;
                case "8":
                    Console.Write("Filename: ");
                    string fname = Console.ReadLine()?.Trim() ?? "quotes.json";
                    manager.SaveToFile(fname);
                    Console.WriteLine($"Saved to {fname}.");
                    break;
                case "9":
                    Console.Write("Filename: ");
                    fname = Console.ReadLine()?.Trim() ?? "quotes.json";
                    manager.LoadFromFile(fname);
                    Console.WriteLine($"Loaded from {fname}.");
                    break;
                case "10":
                    Console.WriteLine("Goodbye! 💻");
                    return;
                default:
                    Console.WriteLine("Invalid choice.");
                    break;
            }
        }
    }
}
