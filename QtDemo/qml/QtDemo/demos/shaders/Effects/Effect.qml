/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2

ShaderEffect {
    id: shaderEffect
    property variant source
    property ListModel parameters: ListModel { }
    property bool divider: false
    property real dividerValue: 1.0
    property real targetWidth: 0
    property real targetHeight: 0
    property string fragmentShaderFilename
    property string vertexShaderFilename

    QtObject {
        id: d
        property string fragmentShaderCommon: "
            #ifdef GL_ES
                precision mediump float;
            #else
            #   define lowp
            #   define mediump
            #   define highp
            #endif // GL_ES
        "
    }

    // The following is a workaround for the fact that ShaderEffect
    // doesn't provide a way for shader programs to be read from a file.
    QtObject {
        id: shaderFileReader

        signal fileReady(string shader, string shaderType)

        function readFile(shaderFile, shaderType)
        {
            var xhr = new XMLHttpRequest
            xhr.open("GET", "../" + shaderFile, true)
            xhr.onreadystatechange = function() {
                if (xhr.readyState == XMLHttpRequest.DONE)
                    shaderFileReader.fileReady(xhr.responseText, shaderType)
            }
            xhr.send()
        }

        onFileReady: {
            if (shaderType == "fragment")
                shaderEffect.fragmentShader = d.fragmentShaderCommon + shader
            if (shaderType == "vertex")
                shaderEffect.vertexShader = shader
        }
    }

    onFragmentShaderFilenameChanged: shaderFileReader.readFile(fragmentShaderFilename, "fragment")
    onVertexShaderFilenameChanged: shaderFileReader.readFile(vertexShaderFilename, "vertex")
}
