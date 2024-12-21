TARGET := iphone:clang:16.5:latest
ARCHS = arm64
THEOS_PACKAGE_SCHEME = rootless
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Experiments
 
Experiments_FILES = Tweak.x persistenceHook.x webViewHook.x
Experiments_CFLAGS = -fobjc-arc 
Experiments_FRAMEWORKS = UIKit AudioToolbox Foundation AVFAudio AVKit WebKit CoreFoundation
Experiments_PRIVATE_FRAMEWORKS = MediaRemote
include $(THEOS_MAKE_PATH)/tweak.mk
