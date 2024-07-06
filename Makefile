
# install xml2rfc with "pip install xml2rfc"
# install mmark from https://github.com/mmarkdown/mmark 
# install pandoc from https://pandoc.org/installing.html
# install lib/rr.war from https://bottlecaps.de/rr/ui or https://github.com/GuntherRademacher/rr

.PHONE: all clean lint format

all: gen/draft-jennings-moq-log.txt

html: gen/draft-jennings-moq-log.html

clean:
	rm -rf gen/*

lint: gen/draft-jennings-moq-log.xml
	rfclint gen/draft-jennings-moq-log.xml

gen/draft-jennings-moq-log.xml: draft-jennings-moq-log.md
	mkdir -p gen
	mmark  draft-jennings-moq-log.md > gen/draft-jennings-moq-log.xml

gen/draft-jennings-moq-log.txt: gen/draft-jennings-moq-log.xml
	xml2rfc --text --v3 gen/draft-jennings-moq-log.xml

gen/draft-jennings-moq-log.pdf: gen/draft-jennings-moq-log.xml
	xml2rfc --pdf --v3 gen/draft-jennings-moq-log.xml

gen/draft-jennings-moq-log.html: gen/draft-jennings-moq-log.xml
	xml2rfc --html --v3 gen/draft-jennings-moq-log.xml

gen/doc-jennings-moq-log.pdf: title.md abstract.md introduction.md naming.md logcol.md manifest.md relay.md contributors.md
	mkdir -p gen 
	pandoc -s draft-jennings-moq-log.md -o gen/doc-jennings-moq-log.pdf

