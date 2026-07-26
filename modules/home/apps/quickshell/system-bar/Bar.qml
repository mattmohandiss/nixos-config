import Quickshell
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

    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    color: root.theme.background

    SystemClock { id: clock; precision: SystemClock.Seconds }

    Rectangle {
        anchors.fill: parent
        color: root.theme.background

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Metric { icon: ""; value: root.metrics.cpu + "%"; status: root.highStatus(root.metrics.cpu, 70, 90); theme: root.theme }
            Metric { icon: root.temperatureIcon(root.metrics.temperature); value: root.metrics.temperature + "°C"; status: root.highStatus(root.metrics.temperature, 70, 85); theme: root.theme }
            Metric { icon: ""; value: root.metrics.ram + "%"; status: root.highStatus(root.metrics.ram, 70, 85); theme: root.theme }
            Metric { icon: ""; value: root.metrics.disk + "%"; status: root.highStatus(root.metrics.disk, 80, 90); theme: root.theme }
        }

        Text {
            anchors.centerIn: parent
            color: root.theme.foreground
            font.family: root.theme.fontFamily
            font.pointSize: root.theme.fontPointSize
            text: Qt.formatDateTime(clock.date, "HH:mm:ss")
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Metric { icon: root.wifiIcon(root.metrics.wifiSignal); value: root.metrics.wifi; valueWidth: 112; status: root.metrics.wifi === "offline" ? "critical" : "normal"; theme: root.theme }
            Metric { icon: root.volumeIcon(root.metrics.volume, root.metrics.volumeMuted); value: root.metrics.volume + "%"; status: root.metrics.volumeMuted ? "muted" : "normal"; theme: root.theme }
            Metric { icon: root.backlightIcon(root.metrics.backlight); value: root.metrics.backlight + "%"; theme: root.theme }
            Metric { icon: root.batteryIcon(root.metrics.battery, root.metrics.batteryState); value: root.metrics.battery + "%"; status: root.lowStatus(root.metrics.battery, 30, 15); theme: root.theme }
        }
    }
}
