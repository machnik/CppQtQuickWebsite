#include "TextFileIO.h"

TextFileIO::TextFileIO(QObject *parent) : QObject(parent)
{
}

void TextFileIO::loadFileContent()
{
    QFileDialog::getOpenFileContent(
        "Text Files (*.txt)",
        [this](const QString &fileName, const QByteArray &fileContent) {
            Q_UNUSED(fileName)
            emit fileContentReady(QString::fromUtf8(fileContent));
        }
    );
}

void TextFileIO::saveFileContent(const QString &content)
{
    QFileDialog::saveFileContent(content.toUtf8(), "untitled.txt");
}
