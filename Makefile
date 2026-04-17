# Build 空山素影 keyboard skin
# See BUILD.md for prerequisites and usage details

SVG_SRC := demo/demo.svg
PNG_OUT := demo.png
SKIN_NAME := 空山素影-calf
ARTIFACT_BASE := kongshan-suying-calf

# Detect version: use git tag on current commit, or "preview"
# Also treat a dirty working tree as preview (local edits not committed)
VERSION := $(shell git tag --points-at HEAD 2>/dev/null | head -1)
ifneq ($(shell git status --porcelain 2>/dev/null),)
  VERSION := preview
endif
ifeq ($(VERSION),)
  VERSION := preview
endif

# Folder name inside the zip: add -preview suffix only for preview builds
ifeq ($(VERSION),preview)
  SKIN_DIR := $(SKIN_NAME)-preview
else
  SKIN_DIR := $(SKIN_NAME)
endif

CSKIN_OUT := $(ARTIFACT_BASE)-$(VERSION).cskin

# --- Targets ---

.PHONY: all rebuild clean cskin jsonnet

all: rebuild

rebuild: clean cskin

# Build .cskin package
cskin: $(CSKIN_OUT)

$(CSKIN_OUT): jsonnet $(PNG_OUT) README-calf.md
	@echo "Packaging $(CSKIN_OUT) (folder: $(SKIN_DIR))..."
	@rm -f $(CSKIN_OUT)
	@mkdir -p $(SKIN_DIR)/light $(SKIN_DIR)/dark
	@cp config.yaml $(PNG_OUT) $(SKIN_DIR)/
	@cp README-calf.md $(SKIN_DIR)/README.md
	@cp light/*.yaml $(SKIN_DIR)/light/
	@cp dark/*.yaml $(SKIN_DIR)/dark/
	@cp -r jsonnet $(SKIN_DIR)/
	zip -r $(CSKIN_OUT) $(SKIN_DIR)
	@rm -rf $(SKIN_DIR)
	@echo "Built $(CSKIN_OUT)"

# Generate keyboard YAML files from jsonnet
jsonnet:
	jsonnet -S -m . jsonnet/main.jsonnet

# Generate demo.png from SVG with version stamp
$(PNG_OUT): $(SVG_SRC) demo/light.png demo/dark.png
	@echo "Version: $(VERSION)"
	@sed 's|vX\.Y|$(VERSION)|' $(SVG_SRC) > demo/_demo_tmp.svg
	rsvg-convert -o $(PNG_OUT) demo/_demo_tmp.svg
	@rm -f demo/_demo_tmp.svg
	@echo "Generated $(PNG_OUT)"

clean:
	rm -f $(PNG_OUT) config.yaml $(ARTIFACT_BASE)-*.cskin
	rm -f light/*.yaml dark/*.yaml
