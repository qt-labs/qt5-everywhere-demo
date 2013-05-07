#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QQmlContext>
#include <shaderfilereader.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/QtDemo/main.qml"));
    viewer.showExpanded();

    ShaderFileReader fileReader;
    viewer.rootContext()->setContextProperty("shaderFileReader", &fileReader);

    return app.exec();
}
