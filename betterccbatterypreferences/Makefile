TARGET := iphone:clang:11.2:7.0
# TODO: Upgrade SDK for Preference.framework support

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BetterCCBatteryPreferences

$(BUNDLE_NAME)_FILES = BCBRootListController.m
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
