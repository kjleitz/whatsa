# Whatsa

## The basics

### What's a Whatsa?

Whatsa is a CLI app that allows you to search a word or phrase and receive a quick summary about that subject.

### How does it do that?

It searches your query on Wikipedia and finds the page you're most likely looking for. If you've been somewhat vague, or your search term could refer to multiple things, it will ask you to select from a disambiguation of topics. Usually, however, your term will go straight to an article. Whatsa then gives you the first paragraph of that article (usually a surprisingly decent summary).

If you're not super satisfied with that bit of information (and you need to know a little more) you can type `more` to get a better picture of that subject. If you're _still_ not satisfied, and you want to know something _specific_ about the thing you've searched, type `other`, and it will list the categories of information Wikipedia knows about the subject (its "History", "Early Life", "Uses", etc.). You can select one of those sections, if you'd like, and it will give you the first paragraph of that section, too (which you can extend similarly with another `more` command). You can make a new query with `new`, ask for help at any time with `help`, or exit the application with `exit`.

Simple?

Simple!

## Installing Whatsa

```
userloser@lappytoppy:~$ gem install whatsa
```

Simple as pie.

## Using Whatsa

```
userloser@lappytoppy:~$ whatsa
```

After you run this command, Whatsa will ask you what you'd like to learn about, and you can enter a word or phrase.

If your search term could mean multiple things, it will let you know, and you can select a choice by its name or number.

If you would like a longer explanation, type `more`.

If you would like to select a category of information about the topic, type `other`, then select a choice by its name or number.

If you'd like to search for something else, type `new`.

## Contributing

Bug reports and pull requests for this project are welcome at its [GitHub page](https://github.com/kjleitz/Whatsa). If you choose to contribute, please adhere to the [Ruby Community Conduct Guideline](https://www.ruby-lang.org/en/conduct/) so I don't have to go around breaking necks, running out of bubblegum, etc.

## License

This project is open source, under the terms of the [MIT license](https://opensource.org/licenses/MIT).
