#!/bin/bash

# filepath: /Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml/modify_info.sh

# Ruta al archivo Info.plist
INFO_PLIST="/Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Info.plist"

# Verifica si el archivo Info.plist existe
if [ ! -f "$INFO_PLIST" ]; then
    echo "El archivo Info.plist no se encuentra en la ruta especificada."
    exit 1
fi

# Agregar o modificar claves en el archivo Info.plist
/usr/libexec/PlistBuddy -c "Add :LSEnvironment dict" "$INFO_PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :LSEnvironment:QML_XHR_ALLOW_FILE_READ string 1" "$INFO_PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :LSEnvironment:QML_XHR_ALLOW_FILE_WRITE string 1" "$INFO_PLIST" 2>/dev/null

# Verificar si las claves se han añadido correctamente
READ_VALUE=$(/usr/libexec/PlistBuddy -c "Print :LSEnvironment:QML_XHR_ALLOW_FILE_READ" "$INFO_PLIST" 2>/dev/null)
WRITE_VALUE=$(/usr/libexec/PlistBuddy -c "Print :LSEnvironment:QML_XHR_ALLOW_FILE_WRITE" "$INFO_PLIST" 2>/dev/null)

if [[ "$READ_VALUE" == "1" && "$WRITE_VALUE" == "1" ]]; then
    echo "El archivo Info.plist ha sido modificado correctamente."
else
    echo "Error: No se pudieron añadir las claves al archivo Info.plist."
    exit 1
fi