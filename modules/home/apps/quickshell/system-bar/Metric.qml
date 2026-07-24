import QtQuick

Row {
    id: root
    required property string icon
    required property string value
    required property var theme
    property string status: "normal"
    readonly property color foreground: {
        if (root.status === "critical" || root.status === "muted") return root.theme.error;
        if (root.status === "warning") return root.theme.warning;
        return root.theme.foreground;
    }
    spacing: 4

    Text { width: 18; color: root.foreground; font.family: root.theme.fontFamily; font.pixelSize: 13; horizontalAlignment: Text.AlignHCenter; text: root.icon }
    Text { color: root.foreground; font.family: root.theme.fontFamily; font.pixelSize: 13; text: root.value }
}
