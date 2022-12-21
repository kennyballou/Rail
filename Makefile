EMACS=emacs

.PHONY: help package elpa clean make-test compile-test test lint

help:
	@printf "\
Main targets\n\
compile    -- compile .el files\n\
elpa 	   -- create a package with the elpa format \n\
package    -- create a tar.gz file with the .el files \n\
test       -- run tests in batch mode\n\
clean      -- delete generated files\n\
lint       -- run package-lint in batch mode\n\
help       -- print this message\n"

package: *.el
	@ver=`grep -o "Version: .*" rail.el | cut -c 10-`; \
	tar czvf rail-$$ver.tar.gz --mode 644 $$(find . -name \*.el)

elpa: *.el
	@version=`grep -o "Version: .*" rail.el | cut -c 10-`; \
	dir=rail-$$version; \
	mkdir -p "$$dir"; \
	cp $$(find . -name \*.el) rail-$$version; \
	echo "(define-package \"rail\" \"$$version\" \
	\"Modular in-buffer completion framework\")" \
	> "$$dir"/rail-pkg.el; \
	tar cvf rail-$$version.tar --mode 644 "$$dir"

clean:
	@rm -rf *.elc ert.el .elpa/ $$(find . -print | grep -i ".elc")

make-test:
	${EMACS}  --batch -l test/make-install.el -l test/make-test.el 


test: make-test clean

compile:
	${EMACS} --batch -l test/make-install.el -L . -f batch-byte-compile rail.el $$(find . -print | grep -i "rail-")

compile-test: compile clean

lint:
	${EMACS} --batch -l test/make-install.el -f package-lint-batch-and-exit $$(find . -print | grep -i "rail-")
