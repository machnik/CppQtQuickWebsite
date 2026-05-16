#include "TextFileIO.h"

#include <QtCore/QPointer>

#include "Localization.h"

TextFileIO::TextFileIO(QObject *parent)
    : QObject{parent}
{
}

void TextFileIO::loadFileContent()
{
    QPointer<TextFileIO> guardedThis{this};

    QFileDialog::getOpenFileContent(
        Localization::strCpp("Text Files (*.txt)"),
        [guardedThis](const QString &fileName, const QByteArray &fileContent) {
            if (!guardedThis || fileName.isEmpty()) {
                return;
            }

            emit guardedThis->currentFileNameChanged(fileName);
            emit guardedThis->fileContentReady(QString::fromUtf8(fileContent));
        }
    );
}

void TextFileIO::saveFileContent(const QString &fileName, const QString &content)
{
    const auto suggestedFileName{fileName.trimmed().isEmpty() ? QStringLiteral("untitled.txt") : fileName};
    QFileDialog::saveFileContent(content.toUtf8(), suggestedFileName);
}
