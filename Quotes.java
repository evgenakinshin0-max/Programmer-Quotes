// Quotes.java
import java.io.*;
import java.nio.file.*;
import java.util.*;

class Quote {
    int id;
    String text;
    String author;
    String category;

    Quote(int id, String text, String author, String category) {
        this.id = id;
        this.text = text;
        this.author = author;
        this.category = category;
    }
}

public class Quotes {
    private List<Quote> quotes = new ArrayList<>();
    private Random rand = new Random();

    public Quotes() {
        loadDefaults();
    }

    private void loadDefaults() {
        quotes.add(new Quote(1, "Talk is cheap. Show me the code.", "Linus Torvalds", "wisdom"));
        quotes.add(new Quote(2, "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", "Linus Torvalds", "fun"));
        quotes.add(new Quote(3, "The best way to predict the future is to implement it.", "Alan Kay", "wisdom"));
        quotes.add(new Quote(4, "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", "Martin Fowler", "wisdom"));
        quotes.add(new Quote(5, "First, solve the problem. Then, write the code.", "John Johnson", "wisdom"));
        quotes.add(new Quote(6, "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", "Joyce Wheeler", "wisdom"));
        quotes.add(new Quote(7, "Simplicity is the soul of efficiency.", "Austin Freeman", "wisdom"));
        quotes.add(new Quote(8, "The only way to learn a new programming language is by writing programs in it.", "Dennis Ritchie", "learning"));
        quotes.add(new Quote(9, "If debugging is the process of removing bugs, then programming must be the process of putting them in.", "Edsger Dijkstra", "humor"));
        quotes.add(new Quote(10, "It's not a bug – it's an undocumented feature.", "Anonymous", "humor"));
        quotes.add(new Quote(11, "Software is a great combination between artistry and engineering.", "Bill Gates", "wisdom"));
        quotes.add(new Quote(12, "In theory, there is no difference between theory and practice. But in practice, there is.", "Jan L. A. van de Snepscheut", "humor"));
        quotes.add(new Quote(13, "The most important property of a program is whether it accomplishes the intention of its user.", "C.A.R. Hoare", "wisdom"));
        quotes.add(new Quote(14, "The computer was born to solve problems that did not exist before.", "Bill Gates", "wisdom"));
        quotes.add(new Quote(15, "One of the best programming skills you can have is knowing when to walk away for a while.", "Oscar Godson", "wisdom"));
    }

    public Quote getRandom() {
        if (quotes.isEmpty()) return null;
        return quotes.get(rand.nextInt(quotes.size()));
    }

    public List<Quote> getAll() { return quotes; }

    public List<Quote> getByAuthor(String author) {
        List<Quote> result = new ArrayList<>();
        for (Quote q : quotes) {
            if (q.author.toLowerCase().contains(author.toLowerCase())) result.add(q);
        }
        return result;
    }

    public List<Quote> getByCategory(String category) {
        List<Quote> result = new ArrayList<>();
        for (Quote q : quotes) {
            if (q.category.equalsIgnoreCase(category)) result.add(q);
        }
        return result;
    }

    public List<String> getCategories() {
        Set<String> set = new HashSet<>();
        for (Quote q : quotes) set.add(q.category);
        return new ArrayList<>(set);
    }

    public Quote add(String text, String author, String category) {
        int id = quotes.stream().mapToInt(q -> q.id).max().orElse(0) + 1;
        if (category == null || category.trim().isEmpty()) category = "general";
        Quote q = new Quote(id, text, author, category);
        quotes.add(q);
        return q;
    }

    public boolean remove(int id) {
        return quotes.removeIf(q -> q.id == id);
    }

    public void saveToFile(String filename) throws IOException {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < quotes.size(); i++) {
            Quote q = quotes.get(i);
            sb.append("{");
            sb.append("\"id\":").append(q.id).append(",");
            sb.append("\"text\":\"").append(q.text.replace("\"", "\\\"")).append("\",");
            sb.append("\"author\":\"").append(q.author.replace("\"", "\\\"")).append("\",");
            sb.append("\"category\":\"").append(q.category.replace("\"", "\\\"")).append("\"");
            sb.append("}");
            if (i < quotes.size()-1) sb.append(",");
        }
        sb.append("]");
        Files.write(Paths.get(filename), sb.toString().getBytes());
    }

    public void loadFromFile(String filename) throws IOException {
        String json = new String(Files.readAllBytes(Paths.get(filename)));
        // Simple manual parsing (no external lib)
        quotes.clear();
        json = json.trim();
        if (!json.startsWith("[")) return;
        json = json.substring(1, json.length()-1);
        if (json.trim().isEmpty()) return;
        String[] items = json.split("\\},\\{");
        for (String item : items) {
            item = item.replace("{", "").replace("}", "");
            String[] fields = item.split(",");
            int id = 0;
            String text = "", author = "", category = "";
            for (String f : fields) {
                String[] kv = f.split(":", 2);
                if (kv.length == 2) {
                    String key = kv[0].trim().replace("\"", "");
                    String val = kv[1].trim().replace("\"", "");
                    if (key.equals("id")) id = Integer.parseInt(val);
                    else if (key.equals("text")) text = val;
                    else if (key.equals("author")) author = val;
                    else if (key.equals("category")) category = val;
                }
            }
            quotes.add(new Quote(id, text, author, category));
        }
    }

    private static void displayQuote(Quote q) {
        if (q == null) {
            System.out.println("No quotes available.");
            return;
        }
        System.out.printf("\n💬 \"%s\"\n   – %s (%s)\n", q.text, q.author, q.category);
    }

    public static void main(String[] args) throws IOException {
        Quotes manager = new Quotes();
        Scanner scanner = new Scanner(System.in);
        System.out.println("=== Programmer Quotes ===");
        while (true) {
            System.out.println("\n1. Get a random quote");
            System.out.println("2. Show all quotes");
            System.out.println("3. Search by author");
            System.out.println("4. Search by category");
            System.out.println("5. Add a quote");
            System.out.println("6. Remove a quote");
            System.out.println("7. Show categories");
            System.out.println("8. Save quotes to file");
            System.out.println("9. Load quotes from file");
            System.out.println("10. Exit");
            System.out.print("Choose: ");
            String choice = scanner.nextLine().trim();
            switch (choice) {
                case "1":
                    displayQuote(manager.getRandom());
                    break;
                case "2":
                    List<Quote> all = manager.getAll();
                    if (all.isEmpty()) System.out.println("No quotes.");
                    else {
                        System.out.println("\nAll quotes:");
                        for (Quote q : all)
                            System.out.printf("[%d] \"%s\" – %s (%s)\n", q.id, q.text, q.author, q.category);
                    }
                    break;
                case "3":
                    System.out.print("Author: ");
                    String author = scanner.nextLine().trim();
                    if (author.isEmpty()) { System.out.println("Author cannot be empty."); break; }
                    List<Quote> results = manager.getByAuthor(author);
                    if (results.isEmpty()) System.out.printf("No quotes by '%s'.\n", author);
                    else {
                        System.out.printf("\nFound %d quote(s) by %s:\n", results.size(), author);
                        for (Quote q : results)
                            System.out.printf("[%d] \"%s\" (%s)\n", q.id, q.text, q.category);
                    }
                    break;
                case "4":
                    System.out.print("Category: ");
                    String category = scanner.nextLine().trim();
                    if (category.isEmpty()) { System.out.println("Category cannot be empty."); break; }
                    List<Quote> catResults = manager.getByCategory(category);
                    if (catResults.isEmpty()) System.out.printf("No quotes in category '%s'.\n", category);
                    else {
                        System.out.printf("\nQuotes in category '%s':\n", category);
                        for (Quote q : catResults)
                            System.out.printf("[%d] \"%s\" – %s\n", q.id, q.text, q.author);
                    }
                    break;
                case "5":
                    System.out.print("Enter quote: ");
                    String text = scanner.nextLine().trim();
                    if (text.isEmpty()) { System.out.println("Quote cannot be empty."); break; }
                    System.out.print("Author: ");
                    String auth = scanner.nextLine().trim();
                    if (auth.isEmpty()) { System.out.println("Author cannot be empty."); break; }
                    System.out.print("Category (optional): ");
                    String cat = scanner.nextLine().trim();
                    Quote qNew = manager.add(text, auth, cat);
                    System.out.printf("Quote added with ID %d.\n", qNew.id);
                    break;
                case "6":
                    System.out.print("Enter quote ID to remove: ");
                    try {
                        int id = Integer.parseInt(scanner.nextLine().trim());
                        if (manager.remove(id)) System.out.println("Quote removed.");
                        else System.out.println("Quote not found.");
                    } catch (NumberFormatException e) {
                        System.out.println("Invalid ID.");
                    }
                    break;
                case "7":
                    List<String> cats = manager.getCategories();
                    if (cats.isEmpty()) System.out.println("No categories.");
                    else System.out.println("Categories: " + String.join(", ", cats));
                    break;
                case "8":
                    System.out.print("Filename: ");
                    String fname = scanner.nextLine().trim();
                    manager.saveToFile(fname);
                    System.out.printf("Saved to %s.\n", fname);
                    break;
                case "9":
                    System.out.print("Filename: ");
                    fname = scanner.nextLine().trim();
                    manager.loadFromFile(fname);
                    System.out.printf("Loaded from %s.\n", fname);
                    break;
                case "10":
                    System.out.println("Goodbye! 💻");
                    scanner.close();
                    return;
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
