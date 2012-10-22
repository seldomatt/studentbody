require 'open-uri'
require 'nokogiri'
require 'sqlite3'

# Create the database


db = SQLite3::Database.new( "db/studentbody.db" )
sql = <<SQL
CREATE table students 
(	id INTEGER PRIMARY KEY,
first_name TEXT,
last_name TEXT,
email TEXT DEFAULT "#",
tag_line TEXT,
bio TEXT,
image_class TEXT,
image_url TEXT,
app_1 TEXT,
app_1_desc TEXT,
app_2 TEXT,
app_2_desc TEXT,
app_3 TEXT,
app_3_desc TEXT,
linked_in TEXT,
blog TEXT,
twitter TEXT,
github TEXT,
code_school TEXT,
coder_wall TEXT,
stack_overflow TEXT,
treehouse TEXT,
githubfeed TEXT,
twitterfeed TEXT
);

CREATE table indexstudents
( id INTEGER PRIMARY KEY, 
	full_name TEXT, 
	tagline TEXT, 
	image_url TEXT,
	page_link TEXT,
	excerpt TEXT
	);

SQL

db.execute_batch( sql )

# Index Parser (get URLs for each student)


urlnoki = "http://students.flatironschool.com/"
profile_links = [] 

doc = Nokogiri::HTML(open(urlnoki))
doc.css('div.one_third a').map do |link| 
  profile_links << urlnoki + link['href']
end
doc.css('div.one_third').each do |studentelement|
	full_name = studentelement.search("h2").inner_text
	tagline = studentelement.search(".position").inner_text
	image_url = studentelement.search("img.person").first['src']
	page_link = studentelement.search("a").first['href']
	excerpt = studentelement.search(".excerpt").inner_text

	db.execute("INSERT into indexstudents (full_name,
																					tagline, 
																					image_url, 
																					page_link, 
																					excerpt) VALUES (?, ?, ?, ?, ?)", full_name, tagline, image_url, page_link, excerpt)


end


# doc.css('div.one_third.last a').map do |link| 
#   profile_links << urlnoki + link['href']
# end

# Iterating through all profile_links (array), running scraper, and saving into DB


profile_links.delete_if {|url| url.include?('billy')}

css = Nokogiri::HTML(open(urlnoki + "/css/matz.css"))

images = css.to_s.scan(/\.(.*?-photo)[^}]+?background:.*\(([\S\s]+?)\)/)

profile_links.each do |link|
		doc = Nokogiri::HTML(open(link))


		name = doc.css('h1').text
		name = name.split(" ")

		first_name = name[0]
		last_name = name[1]

		image_class = doc.css('div#navcontainer.one_third div')[0]['class']
		image_url = " "

		app_1 = doc.css('h4')[0].text
		app_1_desc = doc.css('div.one_third p')[0].text
		app_2 = doc.css('h4')[1].text
		app_2_desc = doc.css('div.one_third p')[1].text
		app_3 = doc.css('h4')[2].text
		app_3_desc = doc.css('div.one_third p')[2].text
		unless doc.css('.mail a').empty?
			email = doc.css('.mail a')[0]["href"]
		end
		if email.include?("mailto:")
			email["mailto:"] = ""
		end
		tag_line = doc.css('#tagline')[0].text
		bio = doc.css('.two_third > p').text
		linked_in = doc.css('.linkedin a')[0]["href"]
		blog = doc.css('.blog a')[0]["href"]
		twitter = doc.css('.twitter a')[0]["href"]
		github = doc.css('a[href*="github"]')[0]["href"]
		code_school = doc.css('a[href*="codeschool"]')[0]["href"]
		coder_wall = doc.css('a[href*="coderwall"]')[0]["href"]
		stack_overflow = doc.css('a[href*="stack"]')[0]["href"]
		treehouse = doc.css('a[href*="treehouse"]')[0]["href"]
		githubfeed = doc.css('.one_half')[0].inner_html
		twitterfeed = doc.css('.one_half')[1].inner_html

		images.each do |imagearray|
			if imagearray[0] == image_class
				image_url = imagearray[1]
			end
		end



		db.execute("INSERT INTO students (first_name, 
																			last_name, 
																			image_class,
																			email, 
																			tag_line, 
																			bio, 
																			app_1, 
																			app_1_desc,
																			app_2, 
																			app_2_desc,
																			app_3,
																			app_3_desc, 
																			linked_in, 
																			blog, 
																			twitter, 
																			github, 
																			code_school, 
																			coder_wall, 
																			stack_overflow, 
																			treehouse,
																			githubfeed,
																			twitterfeed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", first_name, last_name, image_class, email, tag_line, bio, app_1, app_1_desc, app_2, app_2_desc, app_3, app_3_desc, linked_in, blog, twitter, github, code_school, coder_wall, stack_overflow, treehouse, githubfeed, twitterfeed)
end
