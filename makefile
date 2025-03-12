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

vaahflutter/app: check_git clone_repository choose_state_management setup_bloc_related_files\
                 update_package_name update_android_package_identifier \
                 update_ios_package_identifier update_vaahflutter_env \
                 update_android_app_label update_ios_app_label \
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
	@echo "> Cloning repository from debug-dynamic-statemgmt branch"
	git clone https://github.com/webreinvent/vaahflutter.git "$(PACKAGE_NAME)" --branch "debug-dynamic-statemgmt" >/dev/null 2>&1
	@echo "> Cloned successfully"
	@cd ${PACKAGE_NAME} && rm -rf .git

# ========================================================================= #

choose_state_management:
	@read -p "> Choose state management (bloc/getx): " STATE_MGMT; \
	if [ "$$STATE_MGMT" = "bloc" ]; then \
		echo "> Removing GetX state management"; \
		rm -rf "$(PACKAGE_NAME)/lib/state_management/getx"; \
		if [ -f "$(PACKAGE_NAME)/lib/state_management/bloc/main.dart" ]; then \
			cp "$(PACKAGE_NAME)/lib/state_management/bloc/main.dart" "$(PACKAGE_NAME)/lib/main.dart"; \
			echo "> Updated main.dart with Bloc configuration"; \
		else \
			echo ">>>>> Error: main.dart for Bloc not found!"; \
			exit 1; \
		fi \
	elif [ "$$STATE_MGMT" = "getx" ]; then \
		echo "> Removing Bloc state management"; \
		rm -rf "$(PACKAGE_NAME)/lib/state_management/bloc"; \
	else \
		echo "\n>>>>> Error: Invalid choice. Please select either 'bloc' or 'getx'"; \
		exit 1; \
	fi

# ========================================================================= #

setup_bloc_related_files:
	@if [ -f "$(PACKAGE_NAME)/lib/state_management/bloc/app_config.dart" ]; then \
		cp "$(PACKAGE_NAME)/lib/state_management/bloc/app_config.dart" "$(PACKAGE_NAME)/lib/app_config.dart"; \
		echo "> Copied bloc's app_config.dart to the root lib directory"; \
	else \
		echo ">>>>> Error: Bloc's app_config.dart not found!"; \
		exit 1; \
	fi

# ========================================================================= #

# remove_getx_specific_files:
# 	@echo "> Removing GetX specific files..."
# 	@rm -f "$(PACKAGE_NAME)/lib/app_config.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/base/base_controller.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/base/root_assets_controller.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/services/notification/push/notification.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/env/env.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/env/env.g.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/helpers/alerts.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/services/logging_library/logging_library.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/services/notification/internal/notification.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/services/notification/push/notification.dart"
# 	@rm -f "$(PACKAGE_NAME)/lib/vaahextendflutter/services/notification/push/services/remote.dart"
# 	@echo "> GetX specific files removed."

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
