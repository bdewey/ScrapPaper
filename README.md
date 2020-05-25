# Welcome to Scrap Paper

Scrap Paper is a series of tutorials about how to build a iOS notes / writing app in Swift and SwiftUI.

### Does the world need another notes app?

**No!** The App Store is full of excellent writing and notes apps! (I am particularly fond of [Bear](https://bear.app), [Ulysses](https://ulysses.app), and [iA Writer](https://ia.net/writer). Check them out!) However, I’ve been tinkering with home-grown notes apps for over a year as a way to learn new things and have fun programming. Then I saw Nick Lockwood’s cool [retro rampage](https://github.com/nicklockwood/RetroRampage) tutorial series, and it inspired me to turn what I’ve learned in my little Notes apps into a tutorial series of my own.

### A note about what we're going to build

Scrap Paper embraces the “plain text” ethos. The mental model it supports is “my notes are just text files in a directory,” and in the early stages of the tutorial that will be the implementation. (Later steps will explore the tradeoffs of storing the notes in a database.) Like many iOS writing apps, Scrap Paper will support simple formatting, links, and embedded images through Markdown-inspired syntax. Notes locked to a single device aren’t that useful, so Scrap Paper will use iCloud to synchronize notes across your devices.

Things this tutorial will cover:

* The basics of working with Core Text
* Editing text efficiently in a Piece Table
* Parsing Expression Grammars
* Incremental Packrat Parsing
* Moving beyond plain text: Databases, SQLite, and iCloud synchronization

### Out of scope

* I assume you know the basics of Swift — this isn’t a language tutorial.
* I assume you know the concepts behind SwiftUI. However, I don’t think anyone’s an expert at SwiftUI yet, so we’ll be discovering things about SwiftUI together.

## Ready to begin?

* [Part 1](Tutorial/Part1.md)

  In this part, we start with the absolute basics for a writing app -- loading, editing, and saving plain text.
