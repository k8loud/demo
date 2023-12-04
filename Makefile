.PHONY: help

define CONFIG_MAP_HEADER
apiVersion: v1
kind: ConfigMap
metadata:
  name: rules
  namespace: themis-executor
data:
  rules.drl: |
endef
export CONFIG_MAP_HEADER

SCENARIO_NAME ?= "sample"

TARGET_DIR = target
SCENARIOS_DIR = scenarios
SCENARIO_DIR = $(SCENARIOS_DIR)/$(SCENARIO_NAME)

CONFIG_MAP_FILENAME = cm.yaml
RULES_FILENAME = rules.drl
RUN_FILENAME = run.sh
TEAR_DOWN_FILENAME = tear_down.sh

TARGET_CONFIG_MAP_PATH = $(TARGET_DIR)/$(CONFIG_MAP_FILENAME)
TARGET_RULES_PATH = $(TARGET_DIR)/$(RULES_FILENAME)

# targets that aren't annotated with ## are not supposed to be run on their own

help: ## show Makefile contents
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## run scenario with name passed as SCENARIO_NAME
	@echo "Running scenario $(SCENARIO_NAME)"
	make create-cm-file SOURCE_RULES_PATH=$(SCENARIO_DIR)/$(RULES_FILENAME)
	make upload-rules
	$(SCENARIO_DIR)/$(RUN_FILENAME)
	make tear-down

create-cm-file:
	@mkdir -p target
	@echo "Creating a ConfigMap file: $(TARGET_CONFIG_MAP_PATH)"
	@echo "$$CONFIG_MAP_HEADER" > $(TARGET_CONFIG_MAP_PATH)
	cp $(SOURCE_RULES_PATH) $(TARGET_RULES_PATH)
	sed -i 's/^/    /' $(TARGET_RULES_PATH) # assuming tab = 4 spaces
	cat $(TARGET_RULES_PATH) >> $(TARGET_CONFIG_MAP_PATH)

upload-rules:
	@echo "Uploading rules"
	kubectl replace -f $(TARGET_CONFIG_MAP_PATH)

tear-down:
	@echo "Running tear_down script of scenario $(SCENARIO_NAME)"
	$(SCENARIO_DIR)/$(TEAR_DOWN_FILENAME)

.DEFAULT_GOAL := help
