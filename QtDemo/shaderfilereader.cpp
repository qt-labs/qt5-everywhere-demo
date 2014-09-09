#include "shaderfilereader.h"
#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QTextStream>
#include <QtCore/QDebug>

QString ShaderFileReader::readFile(const QString &fileName)
{
    QString content;
    QFile file(QString(QStringLiteral(":/%1")).arg(fileName));

    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        content = stream.readAll();
        file.close();
    }
    return content;
}

