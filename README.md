# whatsa

## The basics

### `whatsa whatsa`?

Whatsa is a CLI app that allows you to search a term or phrase and receive a quick summary about that subject.

### How does it do that?

It searches your term on Wikipedia and finds the page you're most likely looking for. Whatsa gives you the first paragraph of that article, then lists the sections on the page ("History", "Early Life", "Uses", etc.). You can select one of those sections, if you'd like, and it will give you the first paragraph of that section, too. If that's not enough for you, you can ask for more, and it will give you the full section.

## Using whatsa

Enter `whatsa` in a terminal. It will ask you what you'd like to learn about, and you can enter a word or phrase. It will give you a brief summary, and a list of more specific categories about that subject, which you can select by number. If the summary it gives you isn't enough, type 'more' to read the full section.

## Anything else?

### Wishy-washy plans

May or may not use the `summarize` ruby gem when all is said and done, instead of using the first paragraph. Might be a pain to install, though, so I'm keeping it simple.

Remove citation numbers in brackets.

Make stuff private if there's no reason for the API to access it.

## So what's yer structure, bucko?

Well, let's see.

- We'll have a `CLI` class that dictates the interface
- We'll have a `Searcher` class which grabs the page you're looking for (maybe just do this in the Article class?)
	- initialized with a term
	- stores the HTML document as a nokogiri object
	- yeah never mind this is just gonna be in the `Article` class
- We'll have an `Article` class which provides an API for handling an article
	- initialized with a search term
	- stores the HTML document as a nokogiri object
	- methods:
		- `#disambiguation?` - returns true if it's a disambiguation page, false if not
		- `#article?` - opposite of `#disambiguation?`
		- `#summary` - returns the first paragraph of the article
		- `#full_text` - returns the full introductory section
		- `#toc` - returns a list of section names (corresponding to the keys of the `#contents` hash)
		- `#contents` - returns a hash of section names, each pointing to an array of their paragraphs (maybe make the sections objects)
		- `#title` - returns the article title
		- `#dmb_choices` - returns a list of page titles the disambiguation page refers to, or `nil` if it's an article
		- `#full_text` - returns the full text of the article, in plain text
- We'll also have a `Section` class, I think, which handles a section of an article
	- initialized with a section name and the parent `Article` object (not necessary, just store it when the `Article` creates it)
	- stores the section name
	- stores its paragraphs in an array
	- maybe has subsections?
	- methods:
		- `#summary` - returns the first paragraph
		- `#full_text` - returns the full text of the section
		- `#title` - returns the section name
