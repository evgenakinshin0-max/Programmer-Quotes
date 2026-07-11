// quotes.go
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

type Quote struct {
	ID       int    `json:"id"`
	Text     string `json:"text"`
	Author   string `json:"author"`
	Category string `json:"category"`
}

type QuoteManager struct {
	quotes []Quote
}

func NewQuoteManager() *QuoteManager {
	m := &QuoteManager{}
	m.loadDefaults()
	return m
}

func (m *QuoteManager) loadDefaults() {
	m.quotes = []Quote{
		{1, "Talk is cheap. Show me the code.", "Linus Torvalds", "wisdom"},
		{2, "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program.", "Linus Torvalds", "fun"},
		{3, "The best way to predict the future is to implement it.", "Alan Kay", "wisdom"},
		{4, "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", "Martin Fowler", "wisdom"},
		{5, "First, solve the problem. Then, write the code.", "John Johnson", "wisdom"},
		{6, "Sometimes it's better to leave something alone, to pause, and that's very true of programming.", "Joyce Wheeler", "wisdom"},
		{7, "Simplicity is the soul of efficiency.", "Austin Freeman", "wisdom"},
		{8, "The only way to learn a new programming language is by writing programs in it.", "Dennis Ritchie", "learning"},
		{9, "If debugging is the process of removing bugs, then programming must be the process of putting them in.", "Edsger Dijkstra", "humor"},
		{10, "It's not a bug – it's an undocumented feature.", "Anonymous", "humor"},
		{11, "Software is a great combination between artistry and engineering.", "Bill Gates", "wisdom"},
		{12, "In theory, there is no difference between theory and practice. But in practice, there is.", "Jan L. A. van de Snepscheut", "humor"},
		{13, "The most important property of a program is whether it accomplishes the intention of its user.", "C.A.R. Hoare", "wisdom"},
		{14, "The computer was born to solve problems that did not exist before.", "Bill Gates", "wisdom"},
		{15, "One of the best programming skills you can have is knowing when to walk away for a while.", "Oscar Godson", "wisdom"},
	}
}

func (m *QuoteManager) getRandom() *Quote {
	if len(m.quotes) == 0 {
		return nil
	}
	return &m.quotes[rand.Intn(len(m.quotes))]
}

func (m *QuoteManager) getAll() []Quote {
	return m.quotes
}

func (m *QuoteManager) getByAuthor(author string) []Quote {
	var res []Quote
	for _, q := range m.quotes {
		if strings.Contains(strings.ToLower(q.Author), strings.ToLower(author)) {
			res = append(res, q)
		}
	}
	return res
}

func (m *QuoteManager) getByCategory(category string) []Quote {
	var res []Quote
	for _, q := range m.quotes {
		if strings.EqualFold(q.Category, category) {
			res = append(res, q)
		}
	}
	return res
}

func (m *QuoteManager) getCategories() []string {
	m := make(map[string]bool)
	for _, q := range m.quotes {
		m[q.Category] = true
	}
	var cats []string
	for c := range m {
		cats = append(cats, c)
	}
	return cats
}

func (m *QuoteManager) add(text, author, category string) Quote {
	if category == "" {
		category = "general"
	}
	id := 1
	if len(m.quotes) > 0 {
		id = m.quotes[len(m.quotes)-1].ID + 1
	}
	q := Quote{ID: id, Text: text, Author: author, Category: category}
	m.quotes = append(m.quotes, q)
	return q
}

func (m *QuoteManager) remove(id int) bool {
	for i, q := range m.quotes {
		if q.ID == id {
			m.quotes = append(m.quotes[:i], m.quotes[i+1:]...)
			return true
		}
	}
	return false
}

func (m *QuoteManager) saveToFile(filename string) error {
	data, err := json.MarshalIndent(m.quotes, "", "  ")
	if err != nil {
		return err
	}
	return ioutil.WriteFile(filename, data, 0644)
}

func (m *QuoteManager) loadFromFile(filename string) error {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, &m.quotes)
}

func displayQuote(q *Quote) {
	if q == nil {
		fmt.Println("No quotes available.")
		return
	}
	fmt.Printf("\n💬 \"%s\"\n   – %s (%s)\n", q.Text, q.Author, q.Category)
}

func main() {
	rand.Seed(time.Now().UnixNano())
	manager := NewQuoteManager()
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("=== Programmer Quotes ===")
	for {
		fmt.Println("\n1. Get a random quote")
		fmt.Println("2. Show all quotes")
		fmt.Println("3. Search by author")
		fmt.Println("4. Search by category")
		fmt.Println("5. Add a quote")
		fmt.Println("6. Remove a quote")
		fmt.Println("7. Show categories")
		fmt.Println("8. Save quotes to file")
		fmt.Println("9. Load quotes from file")
		fmt.Println("10. Exit")
		fmt.Print("Choose: ")
		scanner.Scan()
		choice := strings.TrimSpace(scanner.Text())
		switch choice {
		case "1":
			displayQuote(manager.getRandom())
		case "2":
			quotes := manager.getAll()
			if len(quotes) == 0 {
				fmt.Println("No quotes.")
			} else {
				fmt.Println("\nAll quotes:")
				for _, q := range quotes {
					fmt.Printf("[%d] \"%s\" – %s (%s)\n", q.ID, q.Text, q.Author, q.Category)
				}
			}
		case "3":
			fmt.Print("Author: ")
			scanner.Scan()
			author := strings.TrimSpace(scanner.Text())
			if author == "" {
				fmt.Println("Author cannot be empty.")
				continue
			}
			results := manager.getByAuthor(author)
			if len(results) == 0 {
				fmt.Printf("No quotes by '%s'.\n", author)
			} else {
				fmt.Printf("\nFound %d quote(s) by %s:\n", len(results), author)
				for _, q := range results {
					fmt.Printf("[%d] \"%s\" (%s)\n", q.ID, q.Text, q.Category)
				}
			}
		case "4":
			fmt.Print("Category: ")
			scanner.Scan()
			category := strings.TrimSpace(scanner.Text())
			if category == "" {
				fmt.Println("Category cannot be empty.")
				continue
			}
			results := manager.getByCategory(category)
			if len(results) == 0 {
				fmt.Printf("No quotes in category '%s'.\n", category)
			} else {
				fmt.Printf("\nQuotes in category '%s':\n", category)
				for _, q := range results {
					fmt.Printf("[%d] \"%s\" – %s\n", q.ID, q.Text, q.Author)
				}
			}
		case "5":
			fmt.Print("Enter quote: ")
			scanner.Scan()
			text := strings.TrimSpace(scanner.Text())
			if text == "" {
				fmt.Println("Quote cannot be empty.")
				continue
			}
			fmt.Print("Author: ")
			scanner.Scan()
			author := strings.TrimSpace(scanner.Text())
			if author == "" {
				fmt.Println("Author cannot be empty.")
				continue
			}
			fmt.Print("Category (optional): ")
			scanner.Scan()
			category := strings.TrimSpace(scanner.Text())
			q := manager.add(text, author, category)
			fmt.Printf("Quote added with ID %d.\n", q.ID)
		case "6":
			fmt.Print("Enter quote ID to remove: ")
			scanner.Scan()
			idStr := strings.TrimSpace(scanner.Text())
			id, err := strconv.Atoi(idStr)
			if err != nil {
				fmt.Println("Invalid ID.")
				continue
			}
			if manager.remove(id) {
				fmt.Println("Quote removed.")
			} else {
				fmt.Println("Quote not found.")
			}
		case "7":
			cats := manager.getCategories()
			if len(cats) == 0 {
				fmt.Println("No categories.")
			} else {
				fmt.Println("Categories:", strings.Join(cats, ", "))
			}
		case "8":
			fmt.Print("Filename: ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			err := manager.saveToFile(fname)
			if err != nil {
				fmt.Println("Error saving:", err)
			} else {
				fmt.Printf("Saved to %s.\n", fname)
			}
		case "9":
			fmt.Print("Filename: ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			err := manager.loadFromFile(fname)
			if err != nil {
				fmt.Println("Error loading:", err)
			} else {
				fmt.Printf("Loaded from %s.\n", fname)
			}
		case "10":
			fmt.Println("Goodbye! 💻")
			return
		default:
			fmt.Println("Invalid choice.")
		}
	}
}
