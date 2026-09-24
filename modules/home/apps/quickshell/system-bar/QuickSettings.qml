import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: root
    required property var parentWindow
    required property var theme
    required property bool tabletMode
    required property bool screenRotated
    required property int keyboardLayoutIndex
    required property string powerProfile
    required property bool wifiEnabled
    required property bool bluetoothEnabled
    property bool open: false
    property bool wifiDetailsOpen: false
    property bool bluetoothDetailsOpen: false
    property var wifiNetworks: []
    property var bluetoothDevices: []
    signal toggleTabletMode()
    signal rotateScreen()
    signal toggleOverview()
    signal setKeyboardLayout(int layoutIndex)
    signal setVolume(real value)
    signal setBacklight(real value)
    signal setPowerProfile(string profile)
    signal toggleWifi()
    signal toggleBluetooth()
    signal toggleWifiDetails()
    signal toggleBluetoothDetails()
    signal closeRequested()

    Process {
        id: wifiScan
        command: ["sh", "-c", "nmcli -t -f IN-USE,SSID,SIGNAL dev wifi list | head -n 6"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n").filter(line => line.length > 0);
                root.wifiNetworks = lines.map(line => {
                    const fields = line.split(":");
                    return { active: fields[0] === "*", name: fields[1] || "Hidden network", signal: fields[2] || "--" };
                });
            }
        }
    }

    Process {
        id: bluetoothScan
        command: ["bluetoothctl", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.bluetoothDevices = this.text.trim().split("\n").filter(line => line.length > 0);
            }
        }
    }

    function refreshDetails() {
        if (root.wifiDetailsOpen) {
            wifiScan.running = false;
            wifiScan.running = true;
        }
        if (root.bluetoothDetailsOpen) {
            bluetoothScan.running = false;
            bluetoothScan.running = true;
        }
    }

    onWifiDetailsOpenChanged: refreshDetails()
    onBluetoothDetailsOpenChanged: refreshDetails()

    screen: root.parentWindow.screen
    anchors { top: true; bottom: true; left: true; right: true }
    visible: root.open
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay

    onVisibleChanged: {
        if (!visible) root.closeRequested();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.closeRequested()
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 360
        height: 450 + (root.wifiDetailsOpen ? 142 : 0) + (root.bluetoothDetailsOpen ? 118 : 0)
        radius: 18
        color: root.theme.background
        border.width: 1
        border.color: root.theme.muted

        MouseArea {
            anchors.fill: parent
            onClicked: mouse.accepted = true
        }

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            Item {
                width: parent.width
                height: 105

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Rectangle {
                        width: 72
                        height: 72
                        radius: width / 2
                        color: tabletMouse.pressed || root.tabletMode ? root.theme.accent : "transparent"
                        border.width: 2
                        border.color: root.tabletMode ? root.theme.accent : root.theme.muted

                        Text {
                            anchors.centerIn: parent
                            color: tabletMouse.pressed || root.tabletMode ? root.theme.background : root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize + 10
                            text: "󰓶"
                        }

                        MouseArea {
                            id: tabletMouse
                            anchors.fill: parent
                            onClicked: root.toggleTabletMode()
                        }
                    }

                    Rectangle {
                        width: 72
                        height: 72
                        radius: width / 2
                        color: rotationMouse.pressed || root.screenRotated ? root.theme.accent : "transparent"
                        border.width: 2
                        border.color: root.screenRotated ? root.theme.accent : root.theme.muted

                        Text {
                            anchors.centerIn: parent
                            color: rotationMouse.pressed || root.screenRotated ? root.theme.background : root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize + 10
                            text: "↻"
                        }

                        MouseArea {
                            id: rotationMouse
                            anchors.fill: parent
                            onClicked: root.rotateScreen()
                        }
                    }

                    Rectangle {
                        width: 72
                        height: 72
                        radius: width / 2
                        color: overviewMouse.pressed ? root.theme.accent : "transparent"
                        border.width: 2
                        border.color: overviewMouse.pressed ? root.theme.accent : root.theme.muted

                        Text {
                            anchors.centerIn: parent
                            color: overviewMouse.pressed ? root.theme.background : root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize + 10
                            text: "▦"
                        }

                        MouseArea {
                            id: overviewMouse
                            anchors.fill: parent
                            onClicked: root.toggleOverview()
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 10

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: 58
                    radius: 12
                    color: wifiMouse.pressed || root.wifiEnabled ? root.theme.accent : root.theme.surfaceRaised
                    border.width: 1
                    border.color: root.wifiEnabled ? root.theme.accent : root.theme.muted
                    Accessible.name: "Wi-Fi"

                    Text {
                        anchors.centerIn: parent
                        color: wifiMouse.pressed || root.wifiEnabled ? root.theme.background : root.theme.foreground
                        font.family: root.theme.fontFamily
                        font.pointSize: root.theme.fontPointSize + 10
                        text: root.wifiEnabled ? "󰤨" : "󰤭"
                    }

                    MouseArea {
                        id: wifiMouse
                        anchors.fill: parent
                        onClicked: root.toggleWifi()
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 8
                        anchors.bottomMargin: 4
                        color: wifiMouse.pressed || root.wifiEnabled ? root.theme.background : root.theme.muted
                        font.pointSize: root.theme.fontPointSize
                        text: root.wifiDetailsOpen ? "⌃" : "⌄"
                    }

                    MouseArea {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 32
                        height: 32
                        onClicked: root.wifiDetailsOpen = !root.wifiDetailsOpen
                    }
                }

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: 58
                    radius: 12
                    color: bluetoothMouse.pressed || root.bluetoothEnabled ? root.theme.accent : root.theme.surfaceRaised
                    border.width: 1
                    border.color: root.bluetoothEnabled ? root.theme.accent : root.theme.muted
                    Accessible.name: "Bluetooth"

                    Text {
                        anchors.centerIn: parent
                        color: bluetoothMouse.pressed || root.bluetoothEnabled ? root.theme.background : root.theme.foreground
                        font.family: root.theme.fontFamily
                        font.pointSize: root.theme.fontPointSize + 10
                        text: root.bluetoothEnabled ? "󰂯" : "󰂲"
                    }

                    MouseArea {
                        id: bluetoothMouse
                        anchors.fill: parent
                        onClicked: root.toggleBluetooth()
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 8
                        anchors.bottomMargin: 4
                        color: bluetoothMouse.pressed || root.bluetoothEnabled ? root.theme.background : root.theme.muted
                        font.pointSize: root.theme.fontPointSize
                        text: root.bluetoothDetailsOpen ? "⌃" : "⌄"
                    }

                    MouseArea {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 32
                        height: 32
                        onClicked: root.bluetoothDetailsOpen = !root.bluetoothDetailsOpen
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: root.wifiDetailsOpen ? 128 : 0
                visible: root.wifiDetailsOpen
                clip: true
                radius: 10
                color: root.theme.surfaceRaised

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Repeater {
                        model: root.wifiNetworks

                        Text {
                            required property var modelData
                            width: parent.width
                            color: modelData.active ? root.theme.accent : root.theme.foreground
                            elide: Text.ElideRight
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize - 1
                            text: (modelData.active ? "󰤨  " : "󰤯  ") + modelData.name + "  " + modelData.signal + "%"
                        }
                    }

                    Text {
                        visible: root.wifiNetworks.length === 0
                        color: root.theme.muted
                        font.family: root.theme.fontFamily
                        font.pointSize: root.theme.fontPointSize - 1
                        text: "No networks found"
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: root.bluetoothDetailsOpen ? 104 : 0
                visible: root.bluetoothDetailsOpen
                clip: true
                radius: 10
                color: root.theme.surfaceRaised

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Repeater {
                        model: root.bluetoothDevices

                        Text {
                            required property string modelData
                            width: parent.width
                            color: root.theme.foreground
                            elide: Text.ElideRight
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize - 1
                            text: modelData.replace(/^Device [^ ]+ /, "󰂯  ")
                        }
                    }

                    Text {
                        visible: root.bluetoothDevices.length === 0
                        color: root.theme.muted
                        font.family: root.theme.fontFamily
                        font.pointSize: root.theme.fontPointSize - 1
                        text: "No devices found"
                    }
                }
            }

            Row {
                id: powerProfileRow
                width: parent.width
                spacing: 6

                Repeater {
                    model: ["performance", "balanced", "power-saver"]

                    Rectangle {
                        required property string modelData
                        width: (powerProfileRow.width - 12) / 3
                        height: 46
                        radius: 10
                        color: profileMouse.pressed || root.powerProfile === modelData ? root.theme.accent : root.theme.surfaceRaised
                        border.width: 1
                        border.color: root.powerProfile === modelData ? root.theme.accent : root.theme.muted

                        Text {
                            anchors.centerIn: parent
                            color: profileMouse.pressed || root.powerProfile === modelData ? root.theme.background : root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pointSize: root.theme.fontPointSize + 7
                            text: modelData === "power-saver" ? "󰐥" : modelData === "balanced" ? "󰾅" : "󰓅"
                            Accessible.name: modelData === "power-saver" ? "Power Saver" : modelData === "balanced" ? "Balanced" : "Performance"
                        }

                        MouseArea {
                            id: profileMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            ToolTip.visible: containsMouse
                            ToolTip.text: modelData === "power-saver" ? "Power Saver" : modelData === "balanced" ? "Balanced" : "Performance"
                            onClicked: root.setPowerProfile(modelData)
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 12

                Text {
                    width: 28
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.theme.foreground
                    font.family: root.theme.fontFamily
                    font.pointSize: root.theme.fontPointSize + 4
                    text: "⌨"
                    Accessible.name: "Keyboard layout"
                }

                ComboBox {
                    id: keyboardLayoutSelector
                    width: parent.width - 40
                    model: ["Danish", "English (US)"]
                    currentIndex: root.keyboardLayoutIndex
                    onActivated: root.setKeyboardLayout(currentIndex)

                    contentItem: Text {
                        leftPadding: 12
                        rightPadding: 12
                        verticalAlignment: Text.AlignVCenter
                        color: root.theme.foreground
                        font.family: root.theme.fontFamily
                        font.pointSize: root.theme.fontPointSize
                        text: keyboardLayoutSelector.displayText
                    }

                    background: Rectangle {
                        radius: 8
                        color: root.theme.surfaceRaised
                        border.width: 1
                        border.color: keyboardLayoutSelector.activeFocus ? root.theme.accent : root.theme.muted
                    }
                }
            }

            Text {
                color: root.theme.foreground
                font.family: root.theme.fontFamily
                font.pointSize: root.theme.fontPointSize + 3
                text: "󰕾"
                Accessible.name: "Volume"
            }

            Slider {
                id: volumeSlider
                width: parent.width
                height: 22
                from: 0
                to: 100
                value: Math.max(0, Number(root.parentWindow.metrics.volume) || 0)
                enabled: root.parentWindow.metrics.volume !== "--"
                onPressedChanged: if (!pressed) root.setVolume(value)

                background: Rectangle {
                    x: volumeSlider.leftPadding
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: volumeSlider.availableWidth
                    height: 6
                    radius: 3
                    color: root.theme.surfaceRaised

                    Rectangle {
                        width: volumeSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 3
                        color: root.theme.accent
                    }
                }

                handle: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: volumeSlider.pressed ? root.theme.foreground : root.theme.accent
                }
            }

            Text {
                color: root.theme.foreground
                font.family: root.theme.fontFamily
                font.pointSize: root.theme.fontPointSize + 3
                text: "󰃠"
                Accessible.name: "Brightness"
            }

            Slider {
                id: backlightSlider
                width: parent.width
                height: 22
                from: 0
                to: 100
                value: Math.max(0, Number(root.parentWindow.metrics.backlight) || 0)
                enabled: root.parentWindow.metrics.backlight !== "--"
                onPressedChanged: if (!pressed) root.setBacklight(value)

                background: Rectangle {
                    x: backlightSlider.leftPadding
                    y: backlightSlider.topPadding + backlightSlider.availableHeight / 2 - height / 2
                    width: backlightSlider.availableWidth
                    height: 6
                    radius: 3
                    color: root.theme.surfaceRaised

                    Rectangle {
                        width: backlightSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 3
                        color: root.theme.accent
                    }
                }

                handle: Rectangle {
                    x: backlightSlider.leftPadding + backlightSlider.visualPosition * (backlightSlider.availableWidth - width)
                    y: backlightSlider.topPadding + backlightSlider.availableHeight / 2 - height / 2
                    width: 14
                    height: 14
                    radius: 7
                    color: backlightSlider.pressed ? root.theme.foreground : root.theme.accent
                }
            }
        }
    }
}
