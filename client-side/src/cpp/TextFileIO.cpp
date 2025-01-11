#include "TextFileIO.h"

#include "Localization.h"

TextFileIO::TextFileIO(QObject *parent) : QObject(parent)
{
}

void TextFileIO::loadFileContent()
{
    QFileDialog::getOpenFileContent(
        Localization::strCpp("Text Files (*.txt)"),
        [this](const QString &fileName, const QByteArray &fileContent) {
            emit currentFileNameChanged(fileName);
            emit fileContentReady(QString::fromUtf8(fileContent));
        }
    );
}

void TextFileIO::saveFileContent(const QString &fileName, const QString &content)
{
    QFileDialog::saveFileContent(content.toUtf8(), fileName);
}
