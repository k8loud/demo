.PHONY: help

define CONFIG_MAP_HEADER
apiVersion: v1
kind: ConfigMap
metadata:
  name: test
  namespace: default
data:
  rules: |
endef
export CONFIG_MAP_HEADER

TARGET_DIR = "target"
SCENARIOS_DIR = "scenarios"
CONFIG_MAP_FILENAME = "cm.yaml"
RULES_FILENAME = "rules.drl"

TARGET_CONFIG_MAP_PATH = "$(TARGET_DIR)/$(CONFIG_MAP_FILENAME)"
TARGET_RULES_PATH = "$(TARGET_DIR)/$(RULES_FILENAME)"

run: ## runs scenario with name passed as SCENARIO_NAME
	@echo "Running scenario $(SCENARIO_NAME)}"
	make create-cm-file SOURCE_RULES_PATH=$(SCENARIOS_DIR)/$(SCENARIO_NAME)/$(RULES_FILENAME)
	make upload-rules

create-cm-file:
	@echo "Creating a ConfigMap file: $(TARGET_CONFIG_MAP_PATH)"
	@echo "$$CONFIG_MAP_HEADER" > $(TARGET_CONFIG_MAP_PATH)
	cp $(SOURCE_RULES_PATH) $(TARGET_RULES_PATH)
	sed -i 's/^/    /' $(TARGET_RULES_PATH) # assuming tab = 4 spaces
	cat $(TARGET_RULES_PATH) >> $(TARGET_CONFIG_MAP_PATH)

upload-rules:
	@echo "Uploading rules"
	kubectl replace -f $(TARGET_CONFIG_MAP_PATH)

.DEFAULT_GOAL := help
