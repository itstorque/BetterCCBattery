TARGET := iphone:clang:11.2:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

SUBPROJECTS += betterccbatterypreferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BetterCCBattery

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

include $(THEOS_MAKE_PATH)/aggregate.mk
