import CSI 1.0
import QtQuick

import "../../Screens/Defines"

Module
{
	id: mixer
	property bool shift:     false
	property string surface: ""

  property bool fineMasterTempoAdjust: true
  property bool mixerFXSelector: false
  property bool prioritizeFXSelection: false

  // Master Clock
	MasterClock { name: "MasterTempo" }
  Wire { from: "%surface%.mixer.tempo"; to: (mixer.fineMasterTempoAdjust) ? "MasterTempo.coarse" : "MasterTempo.fine"; enabled:  shift }
  Wire { from: "%surface%.mixer.tempo"; to: (mixer.fineMasterTempoAdjust) ? "MasterTempo.fine" : "MasterTempo.coarse"; enabled: !shift }


  // Channels
  Channel
  {
    name:    "channel1"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  1
    mixerFXSelector: mixer.mixerFXSelector
    prioritizeFXSelection: mixer.prioritizeFXSelection
  }

  Channel
  {
    name:    "channel2"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  2
    mixerFXSelector: mixer.mixerFXSelector
    prioritizeFXSelection: mixer.prioritizeFXSelection
  }

  Channel
  {
    name:    "channel3"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  3
    mixerFXSelector: mixer.mixerFXSelector
    prioritizeFXSelection: mixer.prioritizeFXSelection
  }

  Channel
  {
    name:    "channel4"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  4
    mixerFXSelector: mixer.mixerFXSelector
    prioritizeFXSelection: mixer.prioritizeFXSelection
  }

  // Xfader
  Wire { from: "%surface%.mixer.xfader.adjust"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust"; } }

  // Snap / Quant
  Wire { from: "%surface%.mixer.snap";  to: TogglePropertyAdapter { path: "app.traktor.snap";  } }
  Wire { from: "%surface%.mixer.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant"; } }
  
  // Master Clip
  Wire { from: "%surface%.mixer.clip.left";   to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"  } }
  Wire { from: "%surface%.mixer.clip.right";  to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right" } }
}
