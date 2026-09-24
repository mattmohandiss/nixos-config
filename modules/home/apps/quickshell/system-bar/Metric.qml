import QtQuick

Item {
    id: root
    required property string icon
    required property string value
    required property var theme
    property real fontPointSize: root.theme.fontPointSize
    property int valueWidth: 42
    property string status: "normal"
    property int gap: 4
    property int iconWidth: Math.ceil(root.fontPointSize * 1.6)
    signal wheelChanged(int direction)
    width: iconWidth + gap + valueWidth
    height: Math.ceil(root.fontPointSize * 1.6)
    readonly property color foreground: {
        if (root.status === "critical" || root.status === "muted") return root.theme.error;
        if (root.status === "warning") return root.theme.warning;
        return root.theme.foreground;
    }
    Row {
        anchors.fill: parent
        spacing: root.gap

        Text { width: root.iconWidth; height: parent.height; color: root.foreground; font.family: root.theme.fontFamily; font.pointSize: root.fontPointSize; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; text: root.icon }
        Text { width: root.valueWidth; height: parent.height; color: root.foreground; font.family: root.theme.fontFamily; font.pointSize: root.fontPointSize; horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight; text: root.value }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: root.wheelChanged(wheel.angleDelta.y > 0 ? -1 : 1)
    }
}
