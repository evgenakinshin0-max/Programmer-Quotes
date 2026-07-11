# quotes.rb
require 'json'

class QuoteManager
  def initialize
    @quotes = []
    load_defaults
  end

  def load_defaults
    @quotes = [
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
    ]
  end

  def random
    @quotes.sample
  end

  def all
    @quotes
  end

  def by_author(author)
    @quotes.select { |q| q[:author].downcase.include?(author.downcase) }
  end

  def by_category(category)
    @quotes.select { |q| q[:category].downcase == category.downcase }
  end

  def categories
    @quotes.map { |q| q[:category] }.uniq.sort
  end

  def add(text, author, category = 'general')
    id = @quotes.map { |q| q[:id] }.max.to_i + 1
    quote = { id: id, text: text, author: author, category: category }
    @quotes << quote
    quote
  end

  def remove(id)
    @quotes.reject! { |q| q[:id] == id }
  end

  def save_to_file(filename)
    File.write(filename, JSON.pretty_generate(@quotes))
  end

  def load_from_file(filename)
    data = File.read(filename)
    @quotes = JSON.parse(data, symbolize_names: true)
  rescue Errno::ENOENT
    puts "File not found."
  end

  def display_quote(q)
    if q.nil?
      puts "No quotes available."
      return
    end
    puts "\n💬 \"#{q[:text]}\"\n   – #{q[:author]} (#{q[:category]})"
  end
end

def main
  manager = QuoteManager.new
  puts "=== Programmer Quotes ==="
  loop do
    puts "\n1. Get a random quote"
    puts "2. Show all quotes"
    puts "3. Search by author"
    puts "4. Search by category"
    puts "5. Add a quote"
    puts "6. Remove a quote"
    puts "7. Show categories"
    puts "8. Save quotes to file"
    puts "9. Load quotes from file"
    puts "10. Exit"
    print "Choose: "
    choice = gets.chomp.strip
    case choice
    when '1'
      manager.display_quote(manager.random)
    when '2'
      quotes = manager.all
      if quotes.empty?
        puts "No quotes."
      else
        puts "\nAll quotes:"
        quotes.each { |q| puts "[#{q[:id]}] \"#{q[:text]}\" – #{q[:author]} (#{q[:category]})" }
      end
    when '3'
      print "Author: "
      author = gets.chomp.strip
      if author.empty?
        puts "Author cannot be empty."
        next
      end
      results = manager.by_author(author)
      if results.empty?
        puts "No quotes by '#{author}'."
      else
        puts "\nFound #{results.size} quote(s) by #{author}:"
        results.each { |q| puts "[#{q[:id]}] \"#{q[:text]}\" (#{q[:category]})" }
      end
    when '4'
      print "Category: "
      category = gets.chomp.strip
      if category.empty?
        puts "Category cannot be empty."
        next
      end
      results = manager.by_category(category)
      if results.empty?
        puts "No quotes in category '#{category}'."
      else
        puts "\nQuotes in category '#{category}':"
        results.each { |q| puts "[#{q[:id]}] \"#{q[:text]}\" – #{q[:author]}" }
      end
    when '5'
      print "Enter quote: "
      text = gets.chomp.strip
      if text.empty?
        puts "Quote cannot be empty."
        next
      end
      print "Author: "
      author = gets.chomp.strip
      if author.empty?
        puts "Author cannot be empty."
        next
      end
      print "Category (optional): "
      category = gets.chomp.strip
      category = 'general' if category.empty?
      q = manager.add(text, author, category)
      puts "Quote added with ID #{q[:id]}."
    when '6'
      print "Enter quote ID to remove: "
      id = gets.chomp.to_i
      if manager.remove(id)
        puts "Quote removed."
      else
        puts "Quote not found."
      end
    when '7'
      cats = manager.categories
      if cats.empty?
        puts "No categories."
      else
        puts "Categories: #{cats.join(', ')}"
      end
    when '8'
      print "Filename: "
      fname = gets.chomp.strip
      manager.save_to_file(fname)
      puts "Saved to #{fname}."
    when '9'
      print "Filename: "
      fname = gets.chomp.strip
      manager.load_from_file(fname)
      puts "Loaded from #{fname}."
    when '10'
      puts "Goodbye! 💻"
      break
    else
      puts "Invalid choice."
    end
  end
end

main if __FILE__ == $0
