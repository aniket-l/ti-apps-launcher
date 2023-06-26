import QtQuick 2.2
import QtQuick.Window 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Extras.Private 1.0
import QtGraphicalEffects 1.12
import QtMultimedia 5.1

Rectangle{
    id: window
    height: Screen.desktopAvailableHeight * 0.6
    width: Screen.desktopAvailableWidth * 0.825
    Rectangle {
        id: backgroundrect
        width: window.width
        height: window.height
        property int count: 0
        property int autocontrolmotor1: 0
        property int autocontrolmotor2: 0
        Image {
            id: backgroundimage
            source:"../images/Background.png"
            width: parent.width
            height: parent.height
        }
        Image {
            id: toprb
            source: "../images/Top_Righ_Box.png"
            anchors.top: parent.top
            anchors.topMargin: window.height * 0.01
            anchors.bottom: parent.bottom
            anchors.bottomMargin: window.height * 0.52
            anchors.right: parent.right
            anchors.rightMargin: window.width * 0.01
            anchors.left: parent.left
            anchors.leftMargin: window.width * 0.74
            Text {
                id: motor1text
                text: qsTr("Motor-1 RPM Control")
                color: "#FFFFFF"
                anchors.top: parent.top
                anchors.topMargin: window.height * 0.02
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: parent.width * 0.035
            }
            CircularGauge {
                id: motorspeed1
                maximumValue: 130
                height: parent.height * 0.8
                width: height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: motor1text.bottom
                property int count1: 0
                value: count1
                Behavior on value {
                    NumberAnimation {
                        duration: 200
                    }
                }
                Component.onCompleted: forceActiveFocus()

                style: CircularGaugeStyle {
                    labelStepSize: 10
                    labelInset: outerRadius / 2.2
                    tickmarkInset: outerRadius / 4.2
                    minorTickmarkInset: outerRadius / 4.2
                    minimumValueAngle: -144
                    maximumValueAngle: 144

                    background: Rectangle {
                        implicitHeight: motorspeed1.height
                        implicitWidth: motorspeed1.width
                        color: "white"
                        anchors.centerIn: parent
                        radius: 360

                        Image {
                            anchors.fill: parent
                            source: "qrc:/images/gaugebackground.svg"
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            sourceSize {
                                width: width
                            }
                        }

                        Canvas {
                            property int value: motorspeed1.value

                            anchors.fill: parent
                            onValueChanged: requestPaint()

                            function degreesToRadians(degrees) {
                              return degrees * (Math.PI / 180);
                            }

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.beginPath();
                                ctx.strokeStyle = "black"
                                ctx.lineWidth = outerRadius
                                ctx.arc(outerRadius,
                                      outerRadius,
                                      outerRadius - ctx.lineWidth / 2,
                                      degreesToRadians(valueToAngle(motorspeed1.value) - 90),
                                      degreesToRadians(valueToAngle(motorspeed1.maximumValue + 1) - 90));
                                ctx.stroke();
                            }
                        }
                    }

                    needle: Item {
                        y: -outerRadius * 0.78
                        height: outerRadius * 0.27
                        Image {
                            id: needle
                            source: "qrc:/images/needle.svg"
                            height: parent.height
                            width: height * 0.1
                            asynchronous: true
                            antialiasing: true
                        }

                        Glow {
                            anchors.fill: needle
                            radius: 5
                            samples: 10
                            color: "white"
                            source: needle
                        }
                    }

                    foreground: Item {
                        Text {
                            id: speedLabel
                            anchors.centerIn: parent
                            text: motorspeed1.value.toFixed(0)
                            font.pixelSize: outerRadius * 0.3
                            color: "#e34c22"
                            antialiasing: true
                        }
                    }

                    tickmarkLabel:  Text {
                        font.pixelSize: Math.max(6, outerRadius * 0.1)
                        text: styleData.value
                        color: styleData.value <= motorspeed1.value ? "red" : "#777776"
                        antialiasing: true
                    }

                    tickmark: Image {
                        source: "qrc:/images/tickmark.svg"
                        width: outerRadius * 0.018
                        height: outerRadius * 0.15
                        antialiasing: true
                        asynchronous: true
                    }

                    minorTickmark: Rectangle {
                        implicitWidth: outerRadius * 0.01
                        implicitHeight: outerRadius * 0.03

                        antialiasing: true
                        smooth: true
                        color: styleData.value <= motorspeed1.value ? "#e34c22" : "darkGray"
                    }
                }
            }
            Rectangle {
                id: rectbox1
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.10
                height: width * 3
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.015
                Image {
                    id: minusbox1
                    source: "../images/Minux_Box.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: width
                    anchors.bottom: parent.bottom
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (backgroundrect.count == 1) {
                                motorspeed1.count1 -=10
                                thermometer1.value = motorspeed1.count1
                                if (motorspeed1.count1 <= 40) {
                                    red1.active = false
                                    yellow1.active = false
                                    green1.active = true
                                }
                                else if (motorspeed1.count1 <= 90) {
                                    red1.active = false
                                    yellow1.active = true
                                    green1.active = false
                                }
                                else {
                                    red1.active = true
                                    yellow1.active = false
                                    green1.active = false
                                }
                                if(motorspeed1.count1 <= 90) {
                                    alert1glow.spread = 0
                                    tempalert1glow.spread = 0
                                }
                                else {
                                    alert1glow.spread = 0.6
                                    tempalert1glow.spread = 0.6
                                }
                            }
                        }
                    }
                }
                Image {
                    id: plusbox1
                    source: "../images/Plus_Box.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: width
                    anchors.top: parent.top
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (backgroundrect.count == 1) {
                                motorspeed1.count1 +=10
                                thermometer1.value = motorspeed1.count1
                                if (motorspeed1.count1 <= 40) {
                                    red1.active = false
                                    yellow1.active = false
                                    green1.active = true
                                }
                                else if (motorspeed1.count1 <= 90) {
                                    red1.active = false
                                    yellow1.active = true
                                    green1.active = false
                                }
                                else {
                                    red1.active = true
                                    yellow1.active = false
                                    green1.active = false
                                }
                                if(motorspeed1.count1 <= 90) {
                                    alert1glow.spread = 0
                                    tempalert1glow.spread = 0
                                }
                                else {
                                    alert1glow.spread = 0.6
                                    tempalert1glow.spread = 0.6
                                }
                            }
                        }
                    }
                }
            }
        }
        Image {
            id: bottomrb
            source: "../images/Bottom_Right_Box.png"
            anchors.top: toprb.bottom
            anchors.topMargin: window.height * 0.005
            anchors.left: toprb.left
            width: toprb.width
            height: toprb.height
            Text {
                id: motor2text
                text: qsTr("Motor-2 RPM Control")
                color: "#FFFFFF"
                anchors.top: parent.top
                anchors.topMargin: window.height * 0.02
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: parent.width * 0.035
            }
            CircularGauge {
                id: motorspeed2
                maximumValue: 130
                height: parent.height * 0.8
                width: height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: motor2text.bottom
                property int count2: 0
                value: count2
                Behavior on value {
                    NumberAnimation {
                        duration: 200
                    }
                }
                style: CircularGaugeStyle {
                    labelStepSize: 10
                    labelInset: outerRadius / 2.2
                    tickmarkInset: outerRadius / 4.2
                    minorTickmarkInset: outerRadius / 4.2
                    minimumValueAngle: -144
                    maximumValueAngle: 144

                    background: Rectangle {
                        implicitHeight: motorspeed2.height
                        implicitWidth: motorspeed2.width
                        color: "white"
                        anchors.centerIn: parent
                        radius: 360

                        Image {
                            anchors.fill: parent
                            source: "qrc:/images/gaugebackground.svg"
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            sourceSize {
                                width: width
                            }
                        }

                        Canvas {
                            property int value: motorspeed2.value

                            anchors.fill: parent
                            onValueChanged: requestPaint()

                            function degreesToRadians(degrees) {
                              return degrees * (Math.PI / 180);
                            }

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.beginPath();
                                ctx.strokeStyle = "black"
                                ctx.lineWidth = outerRadius
                                ctx.arc(outerRadius,
                                      outerRadius,
                                      outerRadius - ctx.lineWidth / 2,
                                      degreesToRadians(valueToAngle(motorspeed2.value) - 90),
                                      degreesToRadians(valueToAngle(motorspeed2.maximumValue + 1) - 90));
                                ctx.stroke();
                            }
                        }
                    }

                    needle: Item {
                        y: -outerRadius * 0.78
                        height: outerRadius * 0.27
                        Image {
                            id: needle
                            source: "qrc:/images/needle.svg"
                            height: parent.height
                            width: height * 0.1
                            asynchronous: true
                            antialiasing: true
                        }

                        Glow {
                            anchors.fill: needle
                            radius: 5
                            samples: 10
                            color: "white"
                            source: needle
                        }
                    }

                    foreground: Item {
                        Text {
                            id: speedLabel
                            anchors.centerIn: parent
                            text: motorspeed2.value.toFixed(0)
                            font.pixelSize: outerRadius * 0.3
                            color: "#e34c22"
                            antialiasing: true
                        }
                    }

                    tickmarkLabel:  Text {
                        font.pixelSize: Math.max(6, outerRadius * 0.1)
                        text: styleData.value
                        color: styleData.value <= motorspeed2.value ? "red" : "#777776"
                        antialiasing: true
                    }

                    tickmark: Image {
                        source: "qrc:/images/tickmark.svg"
                        width: outerRadius * 0.018
                        height: outerRadius * 0.15
                        antialiasing: true
                        asynchronous: true
                    }

                    minorTickmark: Rectangle {
                        implicitWidth: outerRadius * 0.01
                        implicitHeight: outerRadius * 0.03

                        antialiasing: true
                        smooth: true
                        color: styleData.value <= motorspeed2.value ? "#e34c22" : "darkGray"
                    }
                }
            }
            Rectangle {
                id: rectbox2
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.10
                height: width * 3
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.015
                Image {
                    id: minusbox2
                    source: "../images/Minux_Box.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: width
                    anchors.bottom: parent.bottom
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (backgroundrect.count == 1) {
                                motorspeed2.count2 -=10
                                thermometer2.value = motorspeed2.count2
                                if (motorspeed2.count2 <= 40) {
                                    red2.active = false
                                    yellow2.active = false
                                    green2.active = true
                                }
                                else if (motorspeed2.count2 <= 90) {
                                    red2.active = false
                                    yellow2.active = true
                                    green2.active = false
                                }
                                else {
                                    red2.active = true
                                    yellow2.active = false
                                    green2.active = false
                                }
                                if(motorspeed2.count2 <= 90) {
                                    alert2glow.spread = 0
                                    tempalert2glow.spread = 0
                                }
                                else {
                                    alert2glow.spread = 0.6
                                    tempalert2glow.spread = 0.6
                                }
                            }
                        }
                    }
                }
                Image {
                    id: plusbox2
                    source: "../images/Plus_Box.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: width
                    anchors.top: parent.top
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (backgroundrect.count == 1) {
                                motorspeed2.count2 +=10
                                thermometer2.value = motorspeed2.count2
                                if (motorspeed2.count2 <= 40) {
                                    red2.active = false
                                    yellow2.active = false
                                    green2.active = true
                                }
                                else if (motorspeed2.count2 <= 90) {
                                    red2.active = false
                                    yellow2.active = true
                                    green2.active = false
                                }
                                else {
                                    red2.active = true
                                    yellow2.active = false
                                    green2.active = false
                                }
                                if(motorspeed2.count2 <= 90) {
                                    alert2glow.spread = 0
                                    tempalert2glow.spread = 0
                                }
                                else {
                                    alert2glow.spread = 0.6
                                    tempalert2glow.spread = 0.6
                                }
                            }
                        }
                    }
                }
            }
        }
        Image {
            id: centreb
            source: "../images/Center_Box.png"
            anchors.top: toprb.top
            anchors.bottom: bottomrb.bottom
            anchors.right: parent.right
            anchors.rightMargin: window.width * 0.28
            anchors.left: parent.left
            anchors.leftMargin: window.width * 0.01
            //Image {
            //    id: motortemperaturetxt
            //    source: "../images/Motor_Temp.png"
            //    anchors.top: parent.top
            //    anchors.topMargin: parent.height * 0.005
            //    anchors.horizontalCenter: parent.horizontalCenter
            //}
            Rectangle {
                id: lefthalf
                width: parent.width * 0.5
                
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "transparent"

                CircularGauge {
                    id: motorpressure1
                    maximumValue: 100
                    height: parent.height * 0.3
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.bottom: telltales1.bottom
                    anchors. bottomMargin : parent.height * 0.13
                    property int count: 0
                    value: count
                    Behavior on value {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    style: CircularGaugeStyle {
                        id: style
                        minimumValueAngle: -90
                        maximumValueAngle: 90
                        function degreesToRadians(degrees) {
                            return degrees * (Math.PI / 180);
                        }

                        background: Canvas {
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();

                                ctx.beginPath();
                                ctx.strokeStyle = "#e34c22";
                                ctx.lineWidth = outerRadius * 0.02;

                                ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                    degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(100) - 90));
                                ctx.stroke();
                            }
                        }

                        tickmark: Rectangle {
                            visible: styleData.value < 80 || styleData.value % 10 == 0
                            implicitWidth: outerRadius * 0.02
                            antialiasing: true
                            implicitHeight: outerRadius * 0.06
                            color: styleData.value >= 80 ? "#e34c22" : "#e5e5e5"
                        }

                        minorTickmark: Rectangle {
                            visible: styleData.value < 80
                            implicitWidth: outerRadius * 0.01
                            antialiasing: true
                            implicitHeight: outerRadius * 0.03
                            color: "#e5e5e5"
                        }

                        tickmarkLabel:  Text {
                            font.pixelSize: Math.max(6, outerRadius * 0.1)
                            text: styleData.value
                            color: styleData.value >= 80 ? "#e34c22" : "#e5e5e5"
                            antialiasing: true
                        }

                        needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.03
                            implicitHeight: outerRadius * 0.9
                            antialiasing: true
                            color: "#e5e5e5"
                        }

                        foreground: Item {
                            Rectangle {
                                width: outerRadius * 0.2
                                height: width
                                radius: width / 2
                                color: "#e5e5e5"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
                Rectangle {
                    id: rectboxpressure1
                    color: "transparent"
                    height: parent.height * 0.07
                    width: height * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.1
                    anchors.bottom: telltales1.top
                    anchors.bottomMargin: parent.height * 0.015
                    Image {
                        id: minusboxpressure1
                        source: "../images/Minux_Box.png"
                        fillMode: Image.PreserveAspectFit
                        height: parent.height
                        width: height
                        anchors.left: parent.left
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                motorpressure1.count -=10
                            }
                        }
                    }
                    Image {
                        id: plusboxpressure1
                        source: "../images/Plus_Box.png"
                        fillMode: Image.PreserveAspectFit
                        height: parent.height
                        width: height
                        anchors.right: parent.right
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                motorpressure1.count += 10
                            }
                        }
                    }
                }
                Rectangle {
                    id: lightpanel1
                    width: parent.width * 0.15
                    height: width * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.6
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.55
                    color: "transparent"
                    StatusIndicator {
                        id: red1
                        anchors.top: parent.top
                        width: parent.width 
                        height: width
                        color: "red"
                    }
                    StatusIndicator {
                        id: yellow1
                        anchors.top: red1.bottom
                        width: parent.width 
                        height: width
                        color: "orange"
                    }
                    StatusIndicator {
                        id: green1
                        anchors.top: yellow1.bottom
                        width: parent.width 
                        height: width
                        color: "green"
                    }
                }
                
                Rectangle {
                    id:telltales1
                    height: parent.height * 0.15
                    width: height * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.bottom: parent.bottom
                    color: "transparent"
                    Image{
                        id: alert1
                        source: "../images/alert.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: parent.left
                        width: parent.width *0.15
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:alert1glow
                        anchors.fill: alert1
                        source: alert1

                        samples: 32
                        radius: 10
                        color: "red"
                        spread: 0
                    }
                    Image{
                        id: tempalert1
                        source: "../images/tempalert.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: alert1.right
                        anchors.leftMargin: parent.width * 0.02
                        width: parent.width *0.2
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:tempalert1glow
                        anchors.fill: tempalert1
                        source: tempalert1

                        samples: 32
                        radius: 10
                        color: "red"
                        spread: 0
                    }
                    Image{
                        id: maintainence1
                        source: "../images/maintainence.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: tempalert1.right
                        anchors.leftMargin: parent.width * 0.02
                        width: parent.width *0.15
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:maintainence1glow
                        anchors.fill: maintainence1
                        source: maintainence1
                        samples: 32
                        radius: 10
                        color: "dodgerblue"
                        spread: 0
                    }
                    Timer {
                        id: maintainence1timer
                        interval: 500
                        running: true
                        property int flag: 0
                        repeat: true
                        onTriggered: {
                            if (flag == 1) {
                                maintainence1glow.spread = 0.6
                                maintainence1timer.flag = 0
                            }
                            else {
                                maintainence1glow.spread = 0
                                maintainence1timer.flag = 1
                            }
                        }
                    }
                }
                Gauge {
                    id: thermometer1
                    minimumValue: 0
                    value: 0
                    maximumValue: 130
                    height: parent.height * 0.7
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on value {
                        NumberAnimation {
                            duration: 1000
                        }
                    }

                    style: GaugeStyle {
                        valueBar: Rectangle {
                            implicitWidth: 16
                            color: Qt.rgba(thermometer1.value / thermometer1.maximumValue, 1-thermometer1.value / thermometer1.maximumValue , 0 , 1)
                        }
                    }
                }
            }

            Rectangle {
                id: righthalf
                width: parent.width * 0.5
                height: parent.height
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "transparent"

                CircularGauge {
                    id: motorpressure2
                    maximumValue: 100
                    height: parent.height * 0.3
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.bottom: telltales2.bottom
                    anchors.bottomMargin: parent.height * 0.13
                    property int count: 0
                    value: count
                    
                    Behavior on value {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    style: CircularGaugeStyle {
                        id: style
                        minimumValueAngle: -90
                        maximumValueAngle: 90
                        function degreesToRadians(degrees) {
                            return degrees * (Math.PI / 180);
                        }

                        background: Canvas {
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();

                                ctx.beginPath();
                                ctx.strokeStyle = "#e34c22";
                                ctx.lineWidth = outerRadius * 0.02;

                                ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                    degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(100) - 90));
                                ctx.stroke();
                            }
                        }

                        tickmark: Rectangle {
                            visible: styleData.value < 80 || styleData.value % 10 == 0
                            implicitWidth: outerRadius * 0.02
                            antialiasing: true
                            implicitHeight: outerRadius * 0.06
                            color: styleData.value >= 80 ? "#e34c22" : "#e5e5e5"
                        }

                        minorTickmark: Rectangle {
                            visible: styleData.value < 80
                            implicitWidth: outerRadius * 0.01
                            antialiasing: true
                            implicitHeight: outerRadius * 0.03
                            color: "#e5e5e5"
                        }

                        tickmarkLabel:  Text {
                            font.pixelSize: Math.max(6, outerRadius * 0.1)
                            text: styleData.value
                            color: styleData.value >= 80 ? "#e34c22" : "#e5e5e5"
                            antialiasing: true
                        }

                        needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.03
                            implicitHeight: outerRadius * 0.9
                            antialiasing: true
                            color: "#e5e5e5"
                        }

                        foreground: Item {
                            Rectangle {
                                width: outerRadius * 0.2
                                height: width
                                radius: width / 2
                                color: "#e5e5e5"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
                Rectangle {
                    id: rectboxpressure2
                    color: "transparent"
                    height: parent.height * 0.07
                    width: height * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.1
                    anchors.bottom: telltales2.top
                    anchors.bottomMargin: parent.height * 0.015
                    Image {
                        id: minusboxpressure2
                        source: "../images/Minux_Box.png"
                        fillMode: Image.PreserveAspectFit
                        height: parent.height
                        width: height
                        anchors.left: parent.left
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                motorpressure2.count -=10
                            }
                        }
                    }
                    Image {
                        id: plusboxpressure2
                        source: "../images/Plus_Box.png"
                        fillMode: Image.PreserveAspectFit
                        height: parent.height
                        width: height
                        anchors.right: parent.right
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                motorpressure2.count += 10
                            }
                        }
                    }
                }
                Rectangle {
                    id: lightpanel2
                    width: parent.width * 0.15
                    height: width * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.6
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.55
                    color: "transparent"
                    StatusIndicator {
                        id: red2
                        anchors.top: parent.top
                        width: parent.width 
                        height: width
                        color: "red"
                    }
                    StatusIndicator {
                        id: yellow2
                        anchors.top: red2.bottom
                        width: parent.width 
                        height: width
                        color: "orange"
                    }
                    StatusIndicator {
                        id: green2
                        anchors.top: yellow2.bottom
                        width: parent.width 
                        height: width
                        color: "green"
                    }
                }
                Rectangle {
                    id:telltales2
                    height: parent.height * 0.15
                    width: height * 3
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.bottom: parent.bottom
                    color: "transparent"
                    Image{
                        id: alert2
                        source: "../images/alert.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: parent.left
                        width: parent.width *0.15
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:alert2glow
                        anchors.fill: alert2
                        source: alert2

                        samples: 32
                        radius: 10
                        color: "red"
                        spread: 0
                    }
                    Image{
                        id: tempalert2
                        source: "../images/tempalert.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: alert2.right
                        anchors.leftMargin: parent.width * 0.02
                        width: parent.width *0.2
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:tempalert2glow
                        anchors.fill: tempalert2
                        source: tempalert2

                        samples: 32
                        radius: 10
                        color: "red"
                        spread: 0
                    }
                    Image{
                        id: maintainence2
                        source: "../images/maintainence.png"
                        sourceSize: Qt.size(parent.width, parent.height)
                        anchors.left: tempalert2.right
                        anchors.leftMargin: parent.width * 0.02
                        width: parent.width *0.15
                        height: width
                        smooth: true
                        visible: false
                    }
                    Glow {
                        id:maintainence2glow
                        anchors.fill: maintainence2
                        source: maintainence2

                        samples: 32
                        radius: 10
                        color: "dodgerblue"
                        spread: 0
                    }
                    Timer {
                        id: maintainence2timer
                        interval: 500
                        running: true
                        property int flag: 0
                        repeat: true
                        onTriggered: {
                            if (flag == 1) {
                                maintainence2glow.spread = 0.6
                                maintainence2timer.flag = 0
                            }
                            else {
                                maintainence2glow.spread = 0
                                maintainence2timer.flag = 1
                            }
                        }
                    }
                }
                Gauge {
                    id: thermometer2
                    minimumValue: 0
                    value: 0
                    maximumValue: 130
                    height: parent.height * 0.7
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on value {
                        NumberAnimation {
                            duration: 1000
                        }
                    }

                    style: GaugeStyle {
                        valueBar: Rectangle {
                            implicitWidth: 16
                            color: Qt.rgba(thermometer2.value / thermometer2.maximumValue, 1-thermometer2.value / thermometer2.maximumValue , 0 , 1)
                        }
                    }
                }
            }
            
        }
        Rectangle{
            id: statusheader
            width: parent.width * 0.2
            height: parent.height * 0.05
            Text {
                text: qsTr("Status Message:")
                anchors.centerIn: parent
                color: "#FFFFFF"
                font.pixelSize: parent.width * 0.12
            }
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            Text {
                id: textupdate
                text: qsTr("Automatic Control")
                anchors.top: parent.top
                anchors.left: parent.right
                color: "#14AFC0"
                font.pixelSize: parent.width * 0.1
            }
        }
        Image {
            id: powerimage
            source: "../images/bluerect.png"
            fillMode: Image.PreserveAspectFit
            height: statusheader.height
            width: statusheader.width * 0.33
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.01
            Image {
                id:slidebutton
                visible: true
                source: "../images/modebutton.png"
                fillMode: Image.PreserveAspectFit
                width: parent.width * 0.4
                height: parent.height 
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                id:slidebutton2
                visible: false
                source: "../images/modebutton.png"
                fillMode: Image.PreserveAspectFit
                width: parent.width * 0.4
                height: parent.height 
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(backgroundrect.count == 1) {
                        backgroundrect.count = 0
                        slidebutton.visible = true
                        slidebutton2.visible = false
                        textupdate.text = "Automatic Control"
                        
                        motorspeed1.count1 = 0
                        red1.active = false
                        yellow1.active = false
                        green1.active = true
                        
                        motorspeed2.count2 = 0
                        red2.active = false
                        yellow2.active = false
                        green2.active = true

                        autotimer1.running = true
                        backgroundrect.autocontrolmotor1 = 0
                        autotimer2.running = true
                        backgroundrect.autocontrolmotor2 = 0
                    }
                    else {
                        backgroundrect.count = 1
                        slidebutton.visible = false
                        slidebutton2.visible = true
                        textupdate.text = "Manual Control"
                        autotimer1.running = false
                        autotimer2.running = false
                    }
                }
            }
        }
        Timer {
            id: autotimer1
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                if(backgroundrect.autocontrolmotor1 == 0){
                    motorspeed1.count1 +=10
                    if (motorspeed1.count1 >= 130) {
                        backgroundrect.autocontrolmotor1 = 1 
                        //video.play()
                    }
                }
                else {
                    motorspeed1.count1 -=10
                    if ( motorspeed1.count1 <= 0) {
                        backgroundrect.autocontrolmotor1 = 0   
                    }
                }
                thermometer1.value = motorspeed1.count1
                if (motorspeed1.count1 <= 40) {
                    red1.active = false
                    yellow1.active = false
                    green1.active = true
                }
                else if (motorspeed1.count1 <= 90) {
                    red1.active = false
                    yellow1.active = true
                    green1.active = false
                    
                }
                else {
                    red1.active = true
                    yellow1.active = false
                    green1.active = false
                }
                if(motorspeed1.count1 <= 90) {
                    alert1glow.spread = 0
                    tempalert1glow.spread = 0
                }
                else {
                    alert1glow.spread = 0.6
                    tempalert1glow.spread = 0.6
                }
            }
        }  
        Timer {
            id: autotimer2
            interval: 1250
            running: true
            repeat: true
            onTriggered: {
                if(backgroundrect.autocontrolmotor2 == 0) {
                    motorspeed2.count2 +=10
                    if (motorspeed2.count2 >= 130) {
                        backgroundrect.autocontrolmotor2 = 1
                    }
                }
                else {
                    motorspeed2.count2 -=10
                    if(motorspeed2.count2 <= 0) {
                        backgroundrect.autocontrolmotor2 = 0
                    }
                }
                thermometer2.value = motorspeed2.count2
                if (motorspeed2.count2 <= 40) {
                    red2.active = false
                    yellow2.active = false
                    green2.active = true
                }
                else if (motorspeed2.count2 <= 90) {
                    red2.active = false
                    yellow2.active = true
                    green2.active = false
                }
                else {
                    red2.active = true
                    yellow2.active = false
                    green2.active = false
                }
                if(motorspeed2.count2 <= 90) {
                    alert2glow.spread = 0
                    tempalert2glow.spread = 0
                }
                else {
                    alert2glow.spread = 0.6
                    tempalert2glow.spread = 0.6
                }
            }
        } 
        //animation 
        //NumberAnimation {
        //    id: animation
        //    target
        //}     
    }
}
