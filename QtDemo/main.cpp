#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "shaderfilereader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ShaderFileReader fileReader;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("shaderFileReader", &fileReader);
    engine.load(QUrl(QStringLiteral("qrc:///qml/QtDemo/main.qml")));

    return app.exec();
}
