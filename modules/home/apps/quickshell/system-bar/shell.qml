import Quickshell
import QtQuick

Scope {
    id: shell

    property var sharedMetrics: metricsSource
    property var sharedTheme: themeSource

    Metrics { id: metricsSource }
    Theme { id: themeSource }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
            metrics: shell.sharedMetrics
            theme: shell.sharedTheme
        }
    }
}
