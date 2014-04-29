# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
HEADERS += shaderfilereader.h
SOURCES += main.cpp shaderfilereader.cpp

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

QT += multimedia
QTPLUGIN += qsqlite

RESOURCES += \
    resources.qrc

ios: QMAKE_INFO_PLIST = ios/iosInfo.plist
