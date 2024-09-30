# S-1335 clock radio

Run in browser at [clock.tazca.com](https://clock.tazca.com). After it has loaded, you can press "Add to homescreen" on mobile Safari/Chrome taskbar to install it as an app.

![app logo](./.github/logo.png)

An app to replace a dead clock radio and retire a 1st gen iPhone SE with dignity. For more details, you can check my [initial blog post](https://tazca.com/journal/2024-07-flutter.html#orgcc9dcc2) or a longer [post-project post](https://tazca.com/journal/2024-09-clockradio.html). A narrative code documentation is on this repository's [github.io page](https://tazca.github.io/s1335).

# Screenshots

![digital clock face](./assets/images/ledclock.png) ![solar clock face](./assets/images/solarclock.png)

A traditional 7-segment digital clock face and a more experimental solar clock face can be used.

![settings view](./.github/settings.png)

Alarm can be set, OLED displays are supported, main view has brief introductory texts, and clock size can be adjusted for bigger displays.

![radio view](./.github/radio.png)

Radios can be added via URL. If an URL does not play on alarm, a default ping sound is played instead.

![irl view](./.github/clockradio.webp)

# Usage

Drag the clock face seen on startup left or right to see general settings and radio settings respectively. Tap to toggle radio. Alarm function is kept true to my original clock radio. It will start playing the radio at set time each day, until alarm is turned off from settings.

# Known issues and limitations

- Digital clock face is blurred on iOS 15 and earlier in browser. Safari has infamously poor SVG rendering, and the better working CanvasKit renderer is not supported on older Safaris.
- Digital clock face is 24h-only.
- User location dot is offset if clock scale is set too big for the screen.

# Compilation

I compile the project as shown in their [Getting started](https://docs.flutter.dev/get-started/install) section using [VSCodium](https://vscodium.com) as IDE with its well integrated Dart/Flutter plugin. iOS builds require paid developer account, so it's off the table for now.

# Tests

There are no tests currently, as most functionality and layouting is non-trivial to test and manual testing covers most issues at this scale. If I retain interest in the project, I'll make an automatic test suite as part of a larger refactor.

# Todo

- Add a checkbox to randomize what station is played on alarm
- Show `media_kit` errors to user for diagnosing radio issues
- Disentangle solar clock face's wireframe presentation from OLED burn-in prevention, and allow scheduling it for night time for displays that don't go very low on brightness.
- Allow putting nicknames for radio station URLs.
