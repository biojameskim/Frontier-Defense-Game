# https://stackoverflow.com/questions/3931741/why-does-make-think-the-target-is-up-to-date
.PHONY: test # the original had "check" as well

build:
	dune build

code:
	-dune build
	code .
	! dune build --watch

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec bin/main.exe

# check:
# 	@bash check.sh

# finalcheck:
# 	@bash check.sh final

# zip:
# 	rm -f adventure.zip
# 	zip -r adventure.zip . -x@exclude.lst

# clean:
# 	dune clean
# 	rm -f adventure.zip

doc:
	dune build @doc

# opendoc: doc
# 	@bash opendoc.sh

# added by developer

format:
	dune build @fmt --auto-promote
