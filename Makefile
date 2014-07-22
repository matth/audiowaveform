################################################################################
# Config

NAME     := audiowaveform
DIST     ?= precise
VERSION  := $(shell cat VERSION)
RELEASE  := 1
PKGNAME  := $(NAME)_$(VERSION)
PKGDIR   := pkg

################################################################################
# PACKAGING

.PHONY: clean
clean:
	rm -rf $(PKGDIR)

$(PKGDIR):
	mkdir -p $(PKGDIR)

$(PKGDIR)/$(PKGNAME).orig.tar.gz: $(PKGDIR)
	git archive HEAD | gzip > $(PKGDIR)/$(PKGNAME).orig.tar.gz

.PHONY: package
package: $(PKGDIR)/$(PKGNAME).orig.tar.gz

.PHONY: package-debian
package-debian: package
	mkdir -p $(PKGDIR)/$(PKGNAME)-$(RELEASE)
	tar -C $(PKGDIR)/$(PKGNAME)-$(RELEASE) -xvzf $(PKGDIR)/$(PKGNAME).orig.tar.gz
	cd $(PKGDIR)/$(PKGNAME)-$(RELEASE) && dpkg-buildpackage -S
	cd $(PKGDIR)/ && sudo pbuilder --build --buildresult --distribution $(DIST) . $(PKGNAME)-$(RELEASE).dsc
	cd $(PKGDIR) && lintian -i -I *.changes
