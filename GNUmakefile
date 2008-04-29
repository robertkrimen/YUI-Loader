.PHONY: all test time clean distclean dist distcheck upload distupload

all: test

dist:
	rm -rf inc META.yaml
	perl Makefile.PL
	$(MAKE) -f Makefile dist

distclean tardist: Makefile
	$(MAKE) -f $< $@

Makefile: Makefile.PL
	perl $<

clean: distclean

test: Makefile
	TEST_YUI_HOST=1 $(MAKE) -f $< $@

reset: clean
	perl Makefile.PL
	$(MAKE) test
