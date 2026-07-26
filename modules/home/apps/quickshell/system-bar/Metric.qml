import QtQuick

Item {
    id: root
    required property string icon
    required property string value
    required property var theme
    property int valueWidth: 42
    property string status: "normal"
    property int gap: 4
    width: 18 + gap + valueWidth
    height: 18
    readonly property color foreground: {
        if (root.status === "critical" || root.status === "muted") return root.theme.error;
        if (root.status === "warning") return root.theme.warning;
        return root.theme.foreground;
    }
    Row {
        anchors.fill: parent
        spacing: root.gap

        Text { width: 18; color: root.foreground; font.family: root.theme.fontFamily; font.pointSize: root.theme.fontPointSize; horizontalAlignment: Text.AlignHCenter; text: root.icon }
        Text { width: root.valueWidth; color: root.foreground; font.family: root.theme.fontFamily; font.pointSize: root.theme.fontPointSize; horizontalAlignment: Text.AlignLeft; elide: Text.ElideRight; text: root.value }
    }
}
