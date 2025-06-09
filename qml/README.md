# DjMirror: New screens for **Traktor Pro 3.10.x, 3.11.x and 4.x**

**Contact:**
  Subscribe and help us to improve this project. Thanks to your subscription you will have access to the latest versions of the MOD with dozens of improvements.

  - Patreon: [@DjMirrorTraktor](https://www.patreon.com/DjMirrorTraktor)

**Features:**
# Changes in v1.2.0
  - Remix set: Slots navigator
  - Remix set: Play samples with touch
  - Touch hotcues
  - Play button
  - Best playmarker
  - Touch color effects (short and long)  
  - Touch sync button (short and long)
  - Reduced time for certain actions (from three to two seconds) to improve usability
  - Resizing of top controls FX1/2
  - Relocate MySettings widgets
  - Relocated the browser loading button to the bottom right (to improve usability).

# Changes in v1.1.0
  - You can now switch FX1, FX2, FX3 and FX4 effects using the effect selector. You can change the effect type, router and effect selection.
  - Show Loop Size when change.
  - Wave Zoom
  - Fix: Disable browser when inactive
  - Fix: Remove problematic shading effects on certain operating systems

# Changes in v1.0.0
  KEY FEATURES:

  - Features:
    - Real-time theme preview and application
    - Multiple font customization options
    - Extensive waveform and visual customization
    - Musical key colors (16 key notation / 4 notations)
    - Compatibility with Traktor Pro 3.10.x, 3.11.x and 4.x
    - Stability and Performance
    - Advanced touch browser for load track

  - Visual design
    - Redesigned deck header layout with improved visibility
    - Album cover display toggle
    - Phase meter visualization
    - Warning message system
    - Hot cue bar visibility
    - Deck colors (A/B/C/D identifiers)
    - Loop line visualization
    - Loop size indicator
    - Configurable loop dotted lines visualization
    - Better contrast in all deck states
    - Consistent behavior across all deck types
    - Automatic waveform refresh when loading Stem tracks
    - Proper bar.beat display (e.g., "04.2")
    - Configurable Beatgrid Lines
    - Hot Cue bar w/cue point names
    - Wave bar Markers
    - Stem color bars
    - Responsive loop indicator

  - BPM difference indicator
    - Visual feedback for BPM differences between decks
    - Helps prevent drastic BPM changes during mixing
    - SYNC indicator turns red when difference is greater than 2 BPM

  - Deck indicators:
    - Configurable display of SYNC, MASTER, MIXER FX and LOOP indicators
    - Phase meter with sync visualization
    - Dynamic BPM difference calculation and display

  - Time display:
    - Milliseconds display toggle
    - Progress color indicators
    - Configurable warning thresholds
    - Multiple time format options
    - Time warning system, display color indicators:
      - Normal: Default deck color
      - Warning: Orange (configurable threshold)
      - Critical: Red (last 5% of track)

  - Cover Art:
    - Cover art handling with drop shadows
    - New empty deck state visualization
    - Cover size through preferences

  - State Management:
    - Direct thru mode visualization
    - Beats-to-cue calculation and display
    - Dynamic text updates based on deck state

  - Performance & UI:
    - Improved font handling with configurable styles
    - Better color management through theme system
    - Configurable stripe display visibility
    - Waveform Themes (16 presets):
      * Kokernutz (Default visualization)
      * Nexus
      * Prime
      * Denon SC5000/SC6000 style
      * Pioneer CDJ-2000 style
      * Pioneer CDJ-3000 style
      * NUMARK style
      * X-RAY visualization
      * Infrared spectrum
      * Ultraviolet spectrum
      * Spectrum
      * CDJ-3000 Pro Style
      * Club Style
      * Energy Flow
      * Deep House
      * Techno Dark
    - Themes: Normal & Light
    - Real-time theme switching without restart
    - Validation system for musical keys

  SETTINGS:
  - Automatic configuration saving *
    * NOTE: Review INSTALL.md file to help with the installation process

  - If you wish to use settings feature to access local files, you can set the following environment variables to 1 **
        QML_XHR_ALLOW_FILE_READ=1
        QML_XHR_ALLOW_FILE_WRITE=1

    ** NOTE: The zip includes two initial configuration files for Windows "SettingsForWin.json" and for MacOSX "SettingsForMacOSX.json" in case they are not generated correctly.

  - To access settings menu: Touch top header deck on mirror Window (left or right)

  - Configuration Options:
    - Config Header and footer fonts

    - Configurable deck indicators display
    - Customizable font families for headers
    - Theme-aware color system for all elements
    - Configurable warning message display
    - Configurable Fonts
        "Pragmatica"            // Require install
        "Pragmatica MediumTT"   // Require install
        "TRAKTORFREON"
        "UpheavalX1"
        "ProggyCleanTT"         // Require install
        "ProggyVector"          // Require install
        "Webdings"              // Require install
        "Consolas"
        "Consolas Bold"
        "Roboto"
        "Roboto Light"
        "Roboto Medium"
        "Roboto Regular"

  - Configuration Categories:
    - HELP: Navigation instructions and usage tips
    - MIRROR OPTIONS: Mirror inverted, screen scale
    - DISPLAY DECK TOP: Album cover, deck indicators, phase meter, phase meter height
    - DISPLAY DECK CENTER: Loop lines
    - DISPLAY DECK BOTTOM: Hot cue bar, stripe
    - DISPLAY TIME: Milliseconds, progress colors, time warnings and thresholds, Elapsed instead beats
    - DISPLAY BROWSER: Match guides, item count and more items(display 7 or 9 items on screen)
    - DISPLAY THEME: Theme selection and customization (normal, light)
    - DISPLAY WAVEFORM: Spectrum theme, beatgrid height and grid visualization, full height grid , full red grid
    - DISPLAY KEY: Key notation (open key, musical, musical all, camelot)
    - GENERAL OPTIONS: Phrase length settings
    - GENERAL FONTS: Normal, medium and cue font type selection
    - SIZE FONTS: Font size factors for small, middle, large and extra large text
    - HEADER FONTS: Font configuration for header numbers and strings
    - MIXER FX SLOTS: Configuration for 4 mixer FX slots
    - MIXER OPTIONS: Fine Mastertempo, Fine deck tempo adjustment
    - EXPERIMENTAL OPTIONS: Mixer FX selector and FX prioritization
    - DEVELOPER MODE: Debug mode, log level, version number

  THEMES:

  - Theme Customization:
    - All themes are defined in ThemeDefinitions.qml
    - Easy to modify existing themes or create new ones
    - Detailed color documentation with RGB and HEX values
    - Support for opacity levels
    - Color inheritance system for consistent modifications

    - Multiple built-in themes:
      * Default: Classic dark theme optimized for low light
      * Light: High contrast theme for bright environments
      * Pastel (in progress): Soft color palette for reduced eye strain

    - We encourage users to create and share their own themes! You can:
      * Modify existing themes in ThemeDefinitions.qml
      * Create new theme entries in the themes object
      * Share your themes with the community
      * Contribute improvements to the theming system




