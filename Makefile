TARGET := iphone:clang:latest:17.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME := rootless

INSTALL_TARGET_PROCESSES = MobileSafari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = safarimultid

safarimultid_FILES = Tweak.x
safarimultid_CFLAGS = -fobjc-arc -Wall -Werror -Wno-deprecated-declarations
safarimultid_FRAMEWORKS = Foundation WebKit
safarimultid_PRIVATE_FRAMEWORKS =

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSafari || true"
