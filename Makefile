MARKDOWN = pandoc --from gfm --to html --standalone

%.html: %.md
	$(MARKDOWN) $< --output $@