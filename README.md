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
