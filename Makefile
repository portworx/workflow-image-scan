WORKFLOW_VERSION=v2.1.2

.PHONY: update-version
update-version:
	sed -i -E "s/(image-scan.yml@v.+)/image-scan.yml@$(WORKFLOW_VERSION)/g" README.md;
	sed -i -E "s/(scan@v.+)/scan@$(WORKFLOW_VERSION)/g" .github/workflows/image-scan.yml;
	git add README.md .github/workflows/image-scan.yml Makefile;
	git commit -m "Update version to $(WORKFLOW_VERSION)";
	git tag --force "$(WORKFLOW_VERSION)" HEAD ; # don't forget to push the tag
