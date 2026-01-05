#
# Makefile
#

srcs	=  Frame.ts

dsts	=  $(srcs:.ts=.js)
decls	=  types/FrameCore.d.ts \
	   types/$(srcs:.ts=.d.ts)

dstlib  = Library.js
dstdecl	= ./types/Library.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2024 --lib "es2024" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dstlib) $(dstdecl)

$(dstlib): $(dsts)
	cat $(dsts) > $@

$(dstdecl): $(decls)
	cat $(decls) > $(dstdecl)

clean:
	rm -f $(dsts) 
	(cd types && rm -f $(decls))

