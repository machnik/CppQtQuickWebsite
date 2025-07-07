pragma Singleton

import QtQuick

QtObject {

    function descriptions(language) {
        switch(language) {
            case Locale.Polish:
                return descriptionsPolish
            case Locale.German:
                return descriptionsGerman
            default:
                return descriptionsEnglish
        }
    }

    readonly property var descriptionsEnglish: [
        "1. Extensive scrollable text.\nDemonstrates the use of simple QML components to create a functional layout.",
        "2. Image centered within a page.\nShows the use of QML's Image component and demonstrates how to anchor elements within a layout.",
        "3. Qt Quick Controls UI Widget Gallery.\nPresents various controls and layouts, offering a comprehensive overview of ready-to-use UI components.",
        "4. Floating dialog message.\nShows how to create and display dynamic message boxes using QML components.",
        "5. Drag and drop functionality.\nShowcases a draggable and droppable UI item.",
        "6. JavaScript interpreter UI.\nAllows running JavaScript code, demonstrating the integration of JavaScript within QML.",
        "7. Local persistent storage.\nUses QML's LocalStorage module to save and retrieve temporary data, emulating the use of cookies.",
        "8. C++ backend used to implement a button action.\nShows how to interact with C++ code from QML for a seamless integration between the two languages.",
        "9. C++ class used to implement counters.\nDemonstrates how to create and manage counters using C++ and interact with them from QML.",
        "10. Modifying QML properties using JavaScript or C++.\nProvides examples of how to change properties of QML objects dynamically from C++ code.",
        "11. QML ListViews with QML and C++ models.\nPresents a comparison between using QML models and C++ models for populating ListViews.",
        "12. QML UI for long-running parallel computations in C++.\nHighlights the use of C++ for performing intensive computations while maintaining a responsive QML UI.",
        "13. Loading and saving/downloading a local file.\nShows how to handle file operations within a QML application.",
        "14. 2D animation.\nIncludes animated items, demonstrating the capabilities of QML for creating dynamic UIs.",
        "15. 3D animation.\nShowcases the use of Qt Quick 3D to create and display 3D models within a QML application.",
        "16. Qt Quick 3D Physics.\nDemonstrates the integration of physics simulations within a 3D scene using QML.",
        "17. Music playback using Qt's MediaPlayer.\nShows how to play audio files (embedded in the application) using Qt's MediaPlayer component. Does not work in WebAssembly with Qt 6.9!",
        "18. Music playback using the browser's Web Audio API.\nDemonstrates how to play audio (embedded in the application) in a browser environment using its JavaScript engine.",
        "19. WebSocket server.\nShows how to set up and manage a WebSocket server using QML and C++.",
        "20. WebSocket client.\nShows how to set up and manage a WebSocket client that communicates with a WebSocket server.",
        "21. Avatar generator using the DiceBear API.\nDemonstrates how to fetch and display data dynamically from an external source.",
        "22. Using QSysInfo in QML.\nDisplays system information by accessing QSysInfo through a C++ interface exposed to QML.",
        "23. Using QSettings to store files.\nDemonstrates how to download an example image from the internet and store it using QSettings that uses IndexedDB on web and .ini files on desktop.",
        "24. Video playback.\nShows how to implement a video player using Qt's Multimedia module within a QML application. Does not work in WebAssembly with Qt 6.9!",
        "25. Video playback using the browser's built-in player.\nDemonstrates how to play video (embedded in the application) in a browser environment using its JavaScript engine."
    ]

    readonly property var descriptionsPolish: [
        "1. Obszerny przewijalny tekst.\nDemonstruje użycie prostych komponentów QML do stworzenia funkcjonalnego układu wizualnego.",
        "2. Obraz wyśrodkowany na stronie.\nPokazuje użycie komponentu Image w QML i demonstruje, jak zakotwiczyć elementy w układzie.",
        "3. Galeria widżetów interfejsu użytkownika Qt Quick Controls.\nPrezentuje różne kontrolki i układy, oferując kompleksowy przegląd gotowych komponentów UI.",
        "4. Pływające okno dialogowe.\nPokazuje, jak tworzyć i wyświetlać dynamiczne okna dialogowe za pomocą komponentów QML.",
        "5. Funkcjonalność przeciągnij i upuść.\nPrezentuje element interfejsu użytkownika, który można przeciągać i upuszczać.",
        "6. Interpreter JavaScript w interfejsie użytkownika.\nUmożliwia uruchamianie kodu JavaScript, demonstrując integrację JavaScript w QML.",
        "7. Lokalne przechowywanie danych.\nWykorzystuje moduł LocalStorage w QML do zapisywania i pobierania danych tymczasowych, emulując użycie plików cookie.",
        "8. Wywołanie akcji przycisku za pomocą backendu C++.\nPokazuje, jak komunikować się z kodem C++ z poziomu QML, zapewniając płynną integrację między obiema językami.",
        "9. Klasa C++ użyta do implementacji liczników.\nDemonstruje, jak tworzyć i zarządzać licznikami za pomocą C++ oraz jak komunikować się z nimi z poziomu QML.",
        "10. Modyfikowanie właściwości QML za pomocą JavaScript lub C++.\nZawiera przykłady dynamicznej zmiany właściwości obiektów QML z poziomu kodu C++.",
        "11. Obiekt ListView QML z modelami QML i C++.\nPrezentuje porównanie między użyciem modeli QML i modeli C++ do wypełniania obiektów ListView.",
        "12. Interfejs użytkownika QML dla długotrwałych obliczeń równoległych w C++.\nWyróżnia użycie C++ do wykonywania intensywnych obliczeń przy zachowaniu responsywnego interfejsu użytkownika QML.",
        "13. Ładowanie i zapisywanie/pobieranie lokalnego pliku.\nPokazuje, jak obsługiwać operacje na plikach w aplikacji QML.",
        "14. Animacja 2D.\nZawiera animowane elementy, demonstrując możliwości QML do tworzenia dynamicznych interfejsów użytkownika.",
        "15. Animacja 3D.\nPrezentuje użycie Qt Quick 3D do tworzenia i wyświetlania modeli 3D w aplikacji QML.",
        "16. Fizyka Qt Quick 3D.\nDemonstruje integrację symulacji fizyki w scenie 3D za pomocą QML.",
        "17. Odtwarzanie muzyki za pomocą MediaPlayer w Qt.\nPokazuje, jak odtwarzać pliki dźwiękowe (osadzone w aplikacji) za pomocą komponentu MediaPlayer w Qt. Nie działa w WebAssembly z Qt 6.9!",
        "18. Odtwarzanie muzyki za pomocą Web Audio API przeglądarki.\nDemonstruje, jak odtwarzać dźwięk (osadzony w aplikacji) w środowisku przeglądarki za pomocą jej silnika JavaScript.",
        "19. Serwer WebSocket.\nPokazuje, jak skonfigurować i zarządzać serwerem WebSocket za pomocą QML i C++.",
        "20. Klient WebSocket.\nPokazuje, jak skonfigurować i zarządzać klientem WebSocket, który komunikuje się z serwerem WebSocket.",
        "21. Generator awatarów za pomocą interfejsu DiceBear API.\nDemonstruje, jak dynamicznie pobierać i wyświetlać dane z zewnętrznego źródła.",
        "22. Użycie QSysInfo w QML.\nWyświetla informacje o systemie, uzyskując dostęp do QSysInfo za pośrednictwem interfejsu C++ udostępnionego w QML.",
        "23. Użycie QSettings do przechowywania plików.\nDemonstruje, jak pobrać przykładowy obraz z internetu i przechowywać go za pomocą QSettings, który używa IndexedDB w sieci i plików .ini na komputerze.",
        "24. Odtwarzanie wideo.\nPokazuje, jak zaimplementować odtwarzacz wideo za pomocą modułu Multimedia w Qt w aplikacji QML. Nie działa w WebAssembly z Qt 6.9!",
        "25. Odtwarzacz wideo za pomocą wbudowanego odtwarzacza przeglądarki.\nDemonstruje, jak odtwarzać wideo (osadzone w aplikacji) w środowisku przeglądarki za pomocą jej silnika JavaScript."
    ]

    readonly property var descriptionsGerman: [
        "1. Umfangreicher scrollbarer Text.\nDemonstriert die Verwendung einfacher QML-Komponenten zur Erstellung eines funktionalen Layouts.",
        "2. Bild zentriert auf einer Seite.\nZeigt die Verwendung des QML-Bildkomponenten und demonstriert, wie Elemente in einem Layout verankert werden können.",
        "3. Qt Quick Controls UI Widgetgalerie.\nPräsentiert verschiedene Steuerelemente und Layouts und bietet einen umfassenden Überblick über einsatzbereite UI-Komponenten.",
        "4. Schwebende Dialognachricht.\nZeigt, wie dynamische Meldungsfelder mit QML-Komponenten erstellt und angezeigt werden können.",
        "5. Drag-and-Drop-Funktionalität.\nZeigt ein ziehbares und ablegbares UI-Element.",
        "6. JavaScript-Interpreter-Benutzeroberfläche.\nErmöglicht das Ausführen von JavaScript-Code und demonstriert die Integration von JavaScript in QML.",
        "7. Lokale dauerhafte Speicherung.\nVerwendet das QML-LocalStorage-Modul zum Speichern und Abrufen temporärer Daten und emuliert die Verwendung von Cookies.",
        "8. C++-Backend zur Implementierung einer Schaltflächenaktion.\nZeigt, wie mit C++-Code aus QML interagiert werden kann, um eine nahtlose Integration zwischen den beiden Sprachen zu erreichen.",
        "9. C++-Klasse zur Implementierung von Zählern.\nZeigt, wie Zähler in C++ erstellt und verwaltet werden und wie man mit ihnen aus QML interagieren kann.",
        "10. Ändern von QML-Eigenschaften mit JavaScript oder C++.\nBietet Beispiele dafür, wie Eigenschaften von QML-Objekten dynamisch aus C++-Code geändert werden können.",
        "11. QML-ListViews mit QML- und C++-Modellen.\nStellt einen Vergleich zwischen der Verwendung von QML-Modellen und C++-Modellen zur Befüllung von ListViews dar.",
        "12. QML-Benutzeroberfläche für langlaufende parallele Berechnungen in C++.\nHebt die Verwendung von C++ für die Durchführung intensiver Berechnungen hervor, während eine reaktionsfähige QML-Benutzeroberfläche beibehalten wird.",
        "13. Laden und Speichern/Herunterladen einer lokalen Datei.\nZeigt, wie Dateioperationen in einer QML-Anwendung gehandhabt werden.",
        "14. 2D-Animation.\nEnthält animierte Elemente und demonstriert die Fähigkeiten von QML zur Erstellung dynamischer Benutzeroberflächen.",
        "15. 3D-Animation.\nZeigt die Verwendung von Qt Quick 3D zur Erstellung und Anzeige von 3D-Modellen in einer QML-Anwendung.",
        "16. Qt Quick 3D Physics.\nDemonstriert die Integration von Physiksimulationen in einer 3D-Szene mit QML.",
        "17. Musikwiedergabe mit Qt's MediaPlayer.\nZeigt, wie Audiodateien (die in der Anwendung eingebettet sind) mit Qt's MediaPlayer-Komponente abgespielt werden können. Funktioniert nicht in WebAssembly mit Qt 6.9!",
        "18. Musikwiedergabe mit dem Web Audio API des Browsers.\nDemonstriert, wie Audio (das in der Anwendung eingebettet ist) in einer Browser-Umgebung mit seiner JavaScript-Engine abgespielt werden kann.",
        "19. WebSocket-Server.\nZeigt, wie ein WebSocket-Server mit QML und C++ eingerichtet und verwaltet werden kann.",
        "20. WebSocket-Client.\nZeigt, wie ein WebSocket-Client eingerichtet und verwaltet werden kann, der mit einem WebSocket-Server kommuniziert.",
        "21. Avatar-Generator mit der DiceBear API.\nDemonstriert, wie Daten dynamisch von einer externen Quelle abgerufen und angezeigt werden können.",
        "22. Verwendung von QSysInfo in QML.\nZeigt Systeminformationen an, indem auf QSysInfo über ein C++-Interface zugegriffen wird, das in QML verfügbar gemacht wurde.",
        "23. Verwendung von QSettings zum Speichern von Dateien.\nDemonstriert, wie ein Beispielbild aus dem Internet heruntergeladen und mit QSettings gespeichert wird, das IndexedDB im Web und .ini-Dateien auf dem Desktop verwendet.",
        "24. Videowiedergabe.\nZeigt, wie ein Videoplayer mit Qt's Multimedia-Modul in einer QML-Anwendung implementiert werden kann. Funktioniert nicht in WebAssembly mit Qt 6.9!",
        "25. Videowiedergabe mit dem integrierten Player des Browsers.\nDemonstriert, wie Video (das in der Anwendung eingebettet ist) in einer Browser-Umgebung mit seiner JavaScript-Engine abgespielt werden kann."
    ]
}
