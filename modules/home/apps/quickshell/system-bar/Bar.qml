import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root
    required property var metrics
    required property var theme

    function highStatus(value, warning, critical) {
        const number = Number(value);
        if (isNaN(number)) return "normal";
        if (number >= critical) return "critical";
        if (number >= warning) return "warning";
        return "normal";
    }

    function lowStatus(value, warning, critical) {
        const number = Number(value);
        if (isNaN(number)) return "normal";
        if (number <= critical) return "critical";
        if (number <= warning) return "warning";
        return "normal";
    }

    function temperatureIcon(value) {
        const number = Number(value);
        if (isNaN(number) || number < 70) return "";
        if (number < 85) return "";
        return "";
    }

    function wifiIcon(value) {
        const number = Number(value);
        if (isNaN(number)) return "󰤯";
        if (number >= 75) return "󰤨";
        if (number >= 50) return "󰤥";
        if (number >= 25) return "󰤢";
        return "󰤟";
    }

    function volumeIcon(value, muted) {
        if (muted) return "󰖁";
        const number = Number(value);
        if (isNaN(number) || number < 30) return "";
        if (number < 70) return "";
        return "";
    }

    function backlightIcon(value) {
        const number = Number(value);
        if (isNaN(number) || number < 30) return "󰃞";
        if (number < 70) return "󰃟";
        return "󰃠";
    }

    function batteryIcon(value, state) {
        if (state === "charging" || state === "fully-charged") return "󰂄";
        const number = Number(value);
        if (isNaN(number)) return "󰂎";
        if (number >= 90) return "󰁹";
        if (number >= 80) return "󰂂";
        if (number >= 70) return "󰂁";
        if (number >= 60) return "󰂀";
        if (number >= 50) return "󰁿";
        if (number >= 40) return "󰁾";
        if (number >= 30) return "󰁽";
        if (number >= 20) return "󰁼";
        if (number >= 10) return "󰁻";
        return "󰂎";
    }

    Process {
        id: tabletModeMenu
        command: ["bash", "-lc", "exec \"$HOME/.local/bin/tablet-mode-menu\" --toggle"]
    }

    Process {
        id: rotateScreen
        command: ["bash", "-lc", "exec \"$HOME/.local/bin/rotate-screen\""]
    }

    Process {
        id: toggleOverview
        command: ["niri", "msg", "action", "toggle-overview"]
    }

    property int keyboardLayoutIndex: 0
    property int keyboardLayoutTarget: 0
    Process {
        id: keyboardLayoutSet
        command: ["niri", "msg", "action", "switch-layout", root.keyboardLayoutTarget.toString()]
    }

    Process {
        id: keyboardLayoutStatus
        command: ["niri", "msg", "keyboard-layouts"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const match = this.text.match(/^\s*\*\s+(\d+)/m);
                if (match) root.keyboardLayoutIndex = Number(match[1]);
            }
        }
    }

    Process {
        id: onScreenKeyboard
        command: ["wvkbd-tablet"]
        running: false
    }

    Process {
        id: volumeUp
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%+"]
    }

    Process {
        id: volumeDown
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"]
    }

    property int volumeTarget: 0
    Process {
        id: volumeSet
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", root.volumeTarget + "%"]
    }

    Process {
        id: backlightUp
        command: ["brightnessctl", "set", "+1%"]
    }

    Process {
        id: backlightDown
        command: ["brightnessctl", "set", "1%-"]
    }

    property int backlightTarget: 0
    Process {
        id: backlightSet
        command: ["brightnessctl", "set", root.backlightTarget + "%"]
    }

    property string powerProfileTarget: "balanced"
    Process {
        id: powerProfileSet
        command: ["powerprofilesctl", "set", root.powerProfileTarget]
    }

    Process {
        id: wifiToggle
        command: ["nmcli", "radio", "wifi", root.metrics.wifiEnabled ? "off" : "on"]
    }

    Process {
        id: bluetoothToggle
        command: ["rfkill", root.metrics.bluetoothEnabled ? "block" : "unblock", "bluetooth"]
    }

    function setVolume(value) {
        root.volumeTarget = Math.round(value);
        volumeSet.running = false;
        volumeSet.running = true;
    }

    function setBacklight(value) {
        root.backlightTarget = Math.round(value);
        backlightSet.running = false;
        backlightSet.running = true;
    }

    function setKeyboardLayout(value) {
        root.keyboardLayoutTarget = value;
        root.keyboardLayoutIndex = value;
        keyboardLayoutSet.running = false;
        keyboardLayoutSet.running = true;
    }

    property bool tabletMode: false
    property bool keyboardEnabled: false
    property bool screenRotated: false
    property bool quickSettingsOpen: false
    readonly property real barFontPointSize: root.tabletMode ? root.theme.fontPointSize + 3 : root.theme.fontPointSize

    Process {
        id: tabletModeStatus
        command: ["bash", "-lc", "exec \"$HOME/.local/bin/tablet-mode-menu\" --status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const tabletMode = this.text.trim() === "on";
                if (root.tabletMode !== tabletMode) {
                    root.tabletMode = tabletMode;
                }
            }
        }
    }

    Process {
        id: screenRotationStatus
        command: ["bash", "-lc", "exec \"$HOME/.local/bin/rotate-screen\" --status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.screenRotated = this.text.trim() !== "normal"
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!tabletModeStatus.running) tabletModeStatus.running = true
            if (!screenRotationStatus.running) screenRotationStatus.running = true
            if (!keyboardLayoutStatus.running) keyboardLayoutStatus.running = true
        }
    }

    QuickSettings {
        id: quickSettings
        parentWindow: root
        theme: root.theme
        tabletMode: root.tabletMode
        screenRotated: root.screenRotated
        keyboardLayoutIndex: root.keyboardLayoutIndex
        powerProfile: root.metrics.powerProfile
        wifiEnabled: root.metrics.wifiEnabled
        bluetoothEnabled: root.metrics.bluetoothEnabled
        open: root.quickSettingsOpen
        onToggleTabletMode: tabletModeMenu.running = true
        onRotateScreen: rotateScreen.running = true
        onToggleOverview: toggleOverview.running = true
        onSetKeyboardLayout: root.setKeyboardLayout(layoutIndex)
        onSetVolume: root.setVolume(value)
        onSetBacklight: root.setBacklight(value)
        onSetPowerProfile: root.setPowerProfile(profile)
        onToggleWifi: root.toggleWifi()
        onToggleBluetooth: root.toggleBluetooth()
        onCloseRequested: root.quickSettingsOpen = false
    }

    function setPowerProfile(profile) {
        root.powerProfileTarget = profile;
        powerProfileSet.running = false;
        powerProfileSet.running = true;
    }

    function toggleWifi() {
        wifiToggle.running = false;
        wifiToggle.running = true;
    }

    function toggleBluetooth() {
        bluetoothToggle.running = false;
        bluetoothToggle.running = true;
    }

    anchors { top: true; left: true; right: true }
    implicitHeight: barContent.implicitHeight + 12
    color: root.theme.background

    SystemClock { id: clock; precision: SystemClock.Seconds }

    Rectangle {
        anchors.fill: parent
        color: root.theme.background

        Row {
            id: barContent
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Metric { anchors.verticalCenter: parent.verticalCenter; icon: ""; value: root.metrics.cpu + "%"; fontPointSize: root.barFontPointSize; status: root.highStatus(root.metrics.cpu, 70, 90); theme: root.theme }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: root.temperatureIcon(root.metrics.temperature); value: root.metrics.temperature + "°C"; fontPointSize: root.barFontPointSize; status: root.highStatus(root.metrics.temperature, 70, 85); theme: root.theme }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: ""; value: root.metrics.ram + "%"; fontPointSize: root.barFontPointSize; status: root.highStatus(root.metrics.ram, 70, 85); theme: root.theme }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: ""; value: root.metrics.disk + "%"; fontPointSize: root.barFontPointSize; status: root.highStatus(root.metrics.disk, 80, 90); theme: root.theme }
        }

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                id: clockText
                color: timeMouse.pressed ? root.theme.accent : root.theme.foreground
                font.family: root.theme.fontFamily
                font.pointSize: root.barFontPointSize
                text: Qt.formatDateTime(clock.date, "HH:mm:ss")

                MouseArea {
                    id: timeMouse
                    anchors.fill: parent
                    onClicked: root.quickSettingsOpen = !root.quickSettingsOpen
                }
            }

            Rectangle {
                visible: root.tabletMode
                width: 34
                height: 28
                radius: 8
                color: keyboardMouse.pressed || root.keyboardEnabled ? root.theme.accent : "transparent"
                border.width: 1
                border.color: root.keyboardEnabled ? root.theme.accent : root.theme.muted
                Accessible.name: "On-screen keyboard"

                Text {
                    anchors.centerIn: parent
                    color: keyboardMouse.pressed || root.keyboardEnabled ? root.theme.background : root.theme.foreground
                    font.family: root.theme.fontFamily
                    font.pointSize: root.barFontPointSize
                    text: "⌨"
                }

                MouseArea {
                    id: keyboardMouse
                    anchors.fill: parent
                    onClicked: {
                        root.keyboardEnabled = !root.keyboardEnabled;
                        onScreenKeyboard.running = root.keyboardEnabled;
                    }
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Metric { anchors.verticalCenter: parent.verticalCenter; icon: root.wifiIcon(root.metrics.wifiSignal); value: root.metrics.wifi; valueWidth: 112; fontPointSize: root.barFontPointSize; status: root.metrics.wifi === "offline" ? "critical" : "normal"; theme: root.theme }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: root.volumeIcon(root.metrics.volume, root.metrics.volumeMuted); value: root.metrics.volume + "%"; fontPointSize: root.barFontPointSize; status: root.metrics.volumeMuted ? "muted" : "normal"; theme: root.theme; onWheelChanged: direction > 0 ? volumeUp.running = true : volumeDown.running = true }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: root.backlightIcon(root.metrics.backlight); value: root.metrics.backlight + "%"; fontPointSize: root.barFontPointSize; theme: root.theme; onWheelChanged: direction > 0 ? backlightUp.running = true : backlightDown.running = true }
            Metric { anchors.verticalCenter: parent.verticalCenter; icon: root.batteryIcon(root.metrics.battery, root.metrics.batteryState); value: root.metrics.battery + "%"; fontPointSize: root.barFontPointSize; status: root.lowStatus(root.metrics.battery, 30, 15); theme: root.theme }
        }
    }
}
