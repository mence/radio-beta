# Building Notes

These source of these notes are written in Markdown format (.md). To generate other filetypes, we can use Pandoc.

## Requirements

Assuming you are using OSX and have installed [Homebrew](http://brew.sh):

* Install [pandoc](http://pandoc.org/): `brew install pandoc`
* Install [BasicTeX](https://tug.org/mactex/morepackages.html):
    - Via [Homebrew's Caskroom](http://caskroom.io): `brew tap caskroom/cask; brew cask install basictex`
    - Manually via [MacTex](https://tug.org/mactex/morepackages.html)
* Run `build.sh`