#
# Makefile: Build, install or release the project
#
#
# Copyright (c) 2012 Sebastien Andre <sebastien.andre@gmx.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# 
#

# Programs
SHELL   = /bin/sh
PERL    = /usr/bin/perl
GIT     = /usr/bin/git
RM      = /bin/rm
GZIP    = /bin/gzip
INSTALL = /usr/bin/install
POD2MAN = /usr/bin/pod2man

# Project
PROJECT = bkp
CURDATE = $(shell $(PERL) -MPOSIX -e 'print strftime "%Y-%m-%d", localtime')
VERSION = $(shell $(GIT) for-each-ref refs/tags \
				--sort=-taggerdate --format='%(refname)' --count=1 \
			| $(PERL) -ne ' \
				s/^$(PROJECT)-//; \
				$$x, $$y = split "."; \
				END { printf("%d.%d", $$x,  $$y + 1) }')

# Directories
DESTDIR =
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
MANDIR  = $(PREFIX)/share/man/man1
SRCDIR  = $(CURDIR)/src/main
TESTDIR = $(CURDIR)/src/test


# Files
PROGS   = $(basename $(wildcard $(SRCDIR)/*.pl))
MANS    = $(addsuffix .1.gz, $(PROGS))
TESTS   = $(addprefix $(TESTDIR)/, $(notdir $(PROGS)))


help:
	@echo "Usage: make <action> [DESTDIR=<dir>] [PREFIX=<dir>] [VERSION=<version>]"
	@echo
	@echo "   build     Generate Perl scripts and check syntax"
	@echo "   dist      Generate a project archive"
	@echo "   test      Run test suites"
	@echo "   install   Install scripts and man pages under DESTDIR/PREFIX"
	@echo "   release   Release next version of the project"
	@echo

build: $(PROGS) $(MANS)

dist: $(PROJECT)-$(VERSION).tar.gz

test: build $(TESTS)

install: build
	$(INSTALL) -m 0755 -d $(DESTDIR)$(BINDIR) $(DESTDIR)$(MANDIR)
	$(INSTALL) -m 0755 $(PROGS) $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 0644 $(MANS) $(DESTDIR)$(MANDIR)

release:
	$(MAKE) test
	$(GIT) tag -m "Release version $(VERSION) of $(PROJECT)" $(PROJECT)-$(VERSION)
	$(GIT) push --tags --dry-run

clean:
	rm -rf $(PROGS) $(MANS) $(TESTS)


$(TESTDIR)/%: $(TESTDIR)/%.sh $(SRCDIR)/%.pl
	$(RM) -rf $@
	$(INSTALL) -m 0755 -d $@
	$(INSTALL) -m 0755 $(PROGS) $@.sh $@
	cd "$@" && PATH="$@:$(PATH)" $(SHELL) $(notdir $@).sh

%.tar:
	$(GIT) archive --prefix="$(basename $(notdir $@))/" -o $@ HEAD

%.1: %.pl
	$(POD2MAN) --center='$(PROJECT)' --official --release="$(VERSION)" \
		--name=$(notdir $(basename $<)) --date="$(CURDATE)" --section=1 \
		$< $@

%.gz: %
	$(GZIP) -c9 $< > $@

%: %.pl
	$(PERL) -ne '\
				s/{{VERSION}}/$(VERSION)/g;\
				s/{{PROG}}/$(notdir $(basename $<))/g;\
				s/{{AUTHOR}}/$(shell $(GIT) config user.name)/g;\
				s/{{EMAIL}}/$(shell $(GIT) config user.email)/g;\
				s/{{DATE}}/$(CURDATE)/g;\
				s/{{PROJECT}}/$(PROJECT)/g;\
			print' $< > $@
	$(PERL) -c $@


.SUFFIXES:
.POSIX:
.PHONY: clean dist

