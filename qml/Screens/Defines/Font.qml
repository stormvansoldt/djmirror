import QtQuick 2.0

QtObject {

// currently mapped to unity but you can use to bulk scale fonsize if needed
function scale(fontSize) { return fontSize; }  

// Font Size Variables
readonly property int miniFontSize:   			scaleSmallFonts(9)
readonly property int smallFontSize:   			scale(12)
readonly property int middleFontSize:  			scaleMiddleFonts(14)
readonly property int largeFontSize:   			scaleLargeFonts(18)
readonly property int largeValueFontSize:   	scale(21)
readonly property int moreLargeValueFontSize: 	scale(33)
readonly property int extraLargeValueFontSize:  scale(45)
readonly property int superLargeValueFontSize:  scale(55)

readonly property int miniFontSizePlus: scaleSmallFonts(11)
readonly property int miniFontSizePlusPlus: scaleSmallFonts(12)
readonly property int middleFontSizePlus: scaleMiddleFonts(16)
readonly property int largeFontSizePlus: scaleLargeFonts(22)
readonly property int largeFontSizePlusPlus: scaleLargeFonts(24)
readonly property int extraLargeFontSize: scaleExtraLargeFonts(34)
readonly property int extraLargeFontSizePlus: scaleExtraLargeFonts(44)
readonly property int extraLargeFontSizePlusPlus: scaleExtraLargeFonts(54)

  function scaleSmallFonts(fontSize) {
      return fontSize + (prefs.factorSmallFontSize);
  }

  function scaleMiddleFonts(fontSize) {
      return fontSize + (prefs.factorMiddleFontSize);
  }

  function scaleLargeFonts(fontSize) {
      return fontSize + (prefs.factorLargeFontSize);
  }

  function scaleExtraLargeFonts(fontSize) {
      return fontSize + (prefs.factorExtraLargeFontSize);
  }
}
