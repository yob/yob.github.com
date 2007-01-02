require "salesreport"

book1 = {"isbn" => "978111111111", "title" => "Book Number One", "author" => "me", "sales" => 10}
book2 = {"isbn" => "978222222222", "title" => "Two is better than one", "author" => "you", "sales" => 267}
book3 = {"isbn" => "978333333333", "title" => "Three Blind Mice", "author" => "John Howard", "sales" => 1}
book4 = {"isbn" => "978444444444", "title" => "The number 4", "author" => "George Bush", "sales" => 1829}

books = [book1, book2, book3, book4]

text = MyReports::SalesReport.render_txt do |e|
  e.report_title = "December 2006 Sales Figues"
  e.titles = books
end

File.open("dec_sales.txt","w") { |f| f.write text}
