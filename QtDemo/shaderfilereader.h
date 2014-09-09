#ifndef SHADERFILEREADER_H
#define SHADERFILEREADER_H

#include <QObject>

class ShaderFileReader : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE QString readFile(const QString &fileName);
};

#endif // SHADERFILEREADER_H
