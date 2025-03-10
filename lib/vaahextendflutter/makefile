.PHONY: do_setup check_git clone_repository update_package_name \
        update_android_package_identifier update_ios_package_identifier \
        update_vaahflutter_env update_android_app_label update_ios_app_label \
		setup_state_management generate_state_management_boiler_plate

# Detect OS
OS := $(shell uname -s 2>/dev/null)
ifeq ($(OS),Linux)
    SED_I := sed -i
else ifeq ($(OS),Darwin)
    SED_I := sed -i ''
else
    SED_I := sed -i
endif

# Define files to be created
VAAH_FLUTTER_CONFIG := ./vaah_flutter_config.json

# Get user input
APP_NAME := $(shell read -p "> Enter App Name: " input && echo $$input)
PACKAGE_IDENTIFIER := $(shell read -p "> Enter Package Identifier: " input && \
    if [[ $$input =~ ^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$$ ]]; then \
        echo $$input; \
    else \
        echo "\n>>>>> Error: Invalid package identifier format\n" >&2; exit 1; \
    fi)

# Extract Package Name and Path
PACKAGE_NAME := $(shell echo $(PACKAGE_IDENTIFIER) | awk -F'.' '{print $$NF}')
PACKAGE_PATH := $(subst .,/, $(PACKAGE_IDENTIFIER))

ifeq ($(PACKAGE_IDENTIFIER),)
    $(error Package identifier is invalid. Exiting.)
endif

# ========================================================================= #

vaahflutter/app: check_git clone_repository update_package_name \
                 update_android_package_identifier update_ios_package_identifier \
                 update_vaahflutter_env update_android_app_label update_ios_app_label \
				 setup_state_management generate_state_management_boiler_plate

# ========================================================================= #

check_git:
	@command -v git >/dev/null 2>&1 || { \
		echo ""; \
		echo ">>>>> Error: Git is not installed. Please install Git and try again."; \
		echo ""; \
		exit 1; \
	}

# ========================================================================= #

clone_repository:
	@if [ -z "$(PACKAGE_NAME)" ]; then \
		echo ""; \
		echo ">>>>> Error: Invalid App Name."; \
		echo ""; \
		exit 1; \
	fi
	@if [ -d "$(PACKAGE_NAME)" ]; then \
		read -p "> Directory '$(PACKAGE_NAME)' already exists. Do you want to remove it and continue? (y/N): " confirm; \
		if [ "$$confirm" = "y" ]; then \
			rm -rf "$(PACKAGE_NAME)"; \
			echo "> Removed existing directory '$(PACKAGE_NAME)'"; \
		else \
			echo ""; \
			echo ">>>>> Aborting..."; \
			echo ""; \
			exit 1; \
		fi \
	fi	
	@echo "> Cloning repository"
	git clone https://github.com/webreinvent/vaahflutter.git "$(PACKAGE_NAME)" >/dev/null 2>&1 --branch "develop"
	@echo "> Cloned successfully"
	@cd ${PACKAGE_NAME} && rm -rf .git

# ========================================================================= #

update_package_name:
	@if [ -f "$(PACKAGE_NAME)/pubspec.yaml" ]; then \
		$(SED_I) 's/vaahflutter/$(PACKAGE_NAME)/g' "$(PACKAGE_NAME)/pubspec.yaml"; \
		echo "> Updated flutter package name"; \
	else \
		echo ">>>>> Error: pubspec.yaml not found!"; \
		exit 1; \
	fi

# ========================================================================= #

update_android_package_identifier:
	@if [ -f "$(PACKAGE_NAME)/android/app/build.gradle" ]; then \
		$(SED_I) 's/com.webreinvent.vaahflutter/$(PACKAGE_IDENTIFIER)/g' "$(PACKAGE_NAME)/android/app/build.gradle"; \
	else \
		echo ">>>>> Error: build.gradle not found!"; \
		exit 1; \
	fi

	@if [ -f "$(PACKAGE_NAME)/android/app/src/main/kotlin/com/webreinvent/vaahflutter/MainActivity.kt" ]; then \
		$(SED_I) 's/com.webreinvent.vaahflutter/$(PACKAGE_IDENTIFIER)/g' "$(PACKAGE_NAME)/android/app/src/main/kotlin/com/webreinvent/vaahflutter/MainActivity.kt"; \
		mv "$(PACKAGE_NAME)/android/app/src/main/kotlin/com/webreinvent/vaahflutter/MainActivity.kt" "/tmp/MainActivity.kt"; \
		rm -rf "$(PACKAGE_NAME)/android/app/src/main/kotlin/com/"; \
		mkdir -p "$(PACKAGE_NAME)/android/app/src/main/kotlin/$(PACKAGE_PATH)"; \
		mv "/tmp/MainActivity.kt" "$(PACKAGE_NAME)/android/app/src/main/kotlin/$(PACKAGE_PATH)/MainActivity.kt"; \
		echo "> Updated android package identifier"; \
	else \
		echo ">>>>> Error: MainActivity.kt not found!"; \
		exit 1; \
	fi

# ========================================================================= #

update_ios_package_identifier:
	@find "$(PACKAGE_NAME)/ios" -type f \( -name "project.pbxproj" -o -name "Runner.entitlements" -o -name "OneSignalNotificationServiceExtension.entitlements" \) -exec $(SED_I) 's/com.webreinvent.vaahflutter/$(PACKAGE_IDENTIFIER)/g' {} +
	@echo "> Updated iOS package identifier"

# ========================================================================= #

update_vaahflutter_env:
	@find "$(PACKAGE_NAME)/assets/env" -type f -name "*.json" -exec $(SED_I) 's/VaahFlutter/$(APP_NAME)/g' {} +
	@echo "> Updated VaahFlutter Environment"

# ========================================================================= #

update_android_app_label:
	@if [ -f "$(PACKAGE_NAME)/android/app/src/main/AndroidManifest.xml" ]; then \
		$(SED_I) 's/VaahFlutter/$(APP_NAME)/g' "$(PACKAGE_NAME)/android/app/src/main/AndroidManifest.xml"; \
		echo "> Updated android app label"; \
	else \
		echo ">>>>> Error: AndroidManifest.xml not found!"; \
		exit 1; \
	fi

# ========================================================================= #

update_ios_app_label:
	@find "$(PACKAGE_NAME)/ios" -type f \( -name "Info.plist" -o -name "project.pbxproj" \) -exec $(SED_I) 's/VaahFlutter/$(APP_NAME)/g' {} +
	@echo "> Updated iOS app label"

# ========================================================================= #

setup_state_management:
	@read -p "Choose state management (bloc/getx): " sm; \
	if [ "$$sm" != "bloc" ] && [ "$$sm" != "getx" ]; then \
		echo ">> Error: Invalid choice. Please choose either 'bloc' or 'getx'."; \
		exit 1; \
	fi; \
	echo '{ "state_management": "'$$sm'" }' > $(VAAH_FLUTTER_CONFIG); \
	echo ">> SDK setup completed. State management set to $$sm!"; \

# ========================================================================= #

generate_state_management_boiler_plate:
	@read -p "Enter module name: " module; \
	if [ -z "$$module" ]; then \
		echo ">> Error: Module name cannot be empty."; \
		exit 1; \
	fi; \
	STATE_MGMT=$$(cat $(VAAH_FLUTTER_CONFIG) | grep -oP '"state_management":\s*"\K\w+'); \
	SNAKE_CASE_MODULE=$$(echo $$module | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\L\2/g' | tr '[:upper:]' '[:lower:]'); \
	STATE_MGMT_PATH="$(PACKAGE_NAME)/lib/state_management"; \
	mkdir -p "$$STATE_MGMT_PATH"; \
	echo ">> Generating $$SNAKE_CASE_MODULE for $$STATE_MGMT..."; \
	if [ "$$STATE_MGMT" = "bloc" ]; then \
		mkdir -p "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE"; \
		echo 'import "package:equatable/equatable.dart";' > "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_event.dart"; \
		echo "abstract class $$(echo $$module | sed 's/^./\U&/')Event extends Equatable { const $$(echo $$module | sed 's/^./\U&/')Event(); @override List<Object> get props => []; }" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_event.dart"; \
		\
		echo 'import "package:equatable/equatable.dart";' > "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_state.dart"; \
		echo "abstract class $$(echo $$module | sed 's/^./\U&/')State extends Equatable { const $$(echo $$module | sed 's/^./\U&/')State(); @override List<Object> get props => []; }" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_state.dart"; \
		\
		echo 'import "package:flutter_bloc/flutter_bloc.dart";' > "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo 'import "./'$$SNAKE_CASE_MODULE'_event.dart";' >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo 'import "./'$$SNAKE_CASE_MODULE'_state.dart";' >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo "class $$(echo $$module | sed 's/^./\U&/')Bloc extends Bloc<$$(echo $$module | sed 's/^./\U&/')Event, $$(echo $$module | sed 's/^./\U&/')State> {" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo "  static final $$(echo $$module | sed 's/^./\U&/')Bloc _instance = $$(echo $$module | sed 's/^./\U&/')Bloc._internal();" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo "  static $$(echo $$module | sed 's/^./\U&/')Bloc get instance => _instance;" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo "  $$(echo $$module | sed 's/^./\U&/')Bloc._internal() : super(Initial$$(echo $$module | sed 's/^./\U&/')State());" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
		echo "}" >> "$$STATE_MGMT_PATH/bloc/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_bloc.dart"; \
	elif [ "$$STATE_MGMT" = "getx" ]; then \
		mkdir -p "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE"; \
		echo 'import "package:get/get.dart";' > "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
		echo "class $$(echo $$module | sed 's/^./\U&/')Controller extends GetxController {" >> "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
		echo "  static final $$(echo $$module | sed 's/^./\U&/')Controller instance = Get.find();" >> "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
		echo "  final count = 0.obs;" >> "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
		echo "  void increment() => count++;" >> "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
		echo "}" >> "$$STATE_MGMT_PATH/getx/$$SNAKE_CASE_MODULE/$$SNAKE_CASE_MODULE""_controller.dart"; \
	fi; \
	echo ">> Module $$SNAKE_CASE_MODULE generated successfully!"

# ========================================================================= #
