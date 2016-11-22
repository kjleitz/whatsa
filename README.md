# whatsa

## The basics

### `whatsa whatsa`?

Whatsa is a CLI app that allows you to search a term or phrase and receive a quick summary about that subject.

### How does it do that?

It searches your term on Wikipedia and finds the page you're most likely looking for. Whatsa gives you the first paragraph of that article, then lists the sections on the page ("History", "Early Life", "Uses", etc.). You can select one of those sections, if you'd like, and it will give you the first paragraph of that section, too. If that's not enough for you, you can ask for more, and it will give you the full section.

## Using whatsa

Clone this repo, `cd` to the directory, run `bundle install`, then run the `bin/whatsa` script in a terminal. It will ask you what you'd like to learn about, and you can enter a word or phrase.

If your search term could mean multiple things, it will let you know, and you can select a choice by its name or number.

If you would like a longer explanation, type `more`.

If you would like to select a category of information about the topic, type `other`, then select a choice by its name or number.

If you'd like to search for something else, type `new`.

## Dependencies

Requires `open-uri` and `nokogiri`.
