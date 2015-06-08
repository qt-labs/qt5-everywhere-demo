TEMPLATE = app

QT += qml quick xmlpatterns sql svg multimedia

SOURCES += main.cpp

ios: RESOURCES += qml_ios.qrc
!ios: RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
QTPLUGIN += qsqlite

OTHER_FILES += \
    android/AndroidManifest.xml

ios: QMAKE_INFO_PLIST = ios/iosInfo.plist
