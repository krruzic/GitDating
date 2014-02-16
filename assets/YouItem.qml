import bb.cascades 1.2

Container {
    //background: background.imagePaint
    verticalAlignment: VerticalAlignment.Center
    property int compatibility: 5
    property variant compatibilityVals: [ "No compatibility", "Some similarities...", "Okay connection", "Good enough", "Great together!",
        "Perfect Match!" ]
    property string name: "Kristopher Ruzic"
    property string location: "Calgary, AB"
    property variant languages: [ "Python", "Java", "C" ]
    attachedObjects: [
        TextStyleDefinition {
            id: lightStyle
            base: SystemDefaults.TextStyles.BodyText
            fontSize: FontSize.PointValue
            fontSizeValue: 7
            fontWeight: FontWeight.W300
        },
        ImagePaintDefinition {
            id: background
            imageSource: "asset:///images/itemBackground.amd"
        }
    ]
    Container {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Fill
        maxHeight: 115
        minHeight: 115
        
        layout: DockLayout {
        }
        Container {
            leftPadding: 10
            verticalAlignment: VerticalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Left
            ImageView {
                verticalAlignment: VerticalAlignment.Center
                imageSource: "asset:///images/profileImage.png"
                maxWidth: 100
                maxHeight: 100
            }
            Container {
                translationY: -5
                verticalAlignment: VerticalAlignment.Center
                Label {
                    maxWidth: 400
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.base: lightStyle.style
                    text: "Looking for love..."
                    textStyle.fontSizeValue: 9
                    textStyle.fontWeight: FontWeight.Bold
                }
                Label {
                    maxWidth: 300
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.base: lightStyle.style
                    text: name
                }
            }
        }

        Container {
            rightPadding: 10
            topPadding: 15
            translationY: -5
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Top
            Label {
                topMargin: 0
                bottomMargin: 0
                textStyle.fontSizeValue: 5
                textStyle.base: lightStyle.style
                text: location
                textStyle.color: Color.Gray
            }
            Label {
                topMargin: 0
                bottomMargin: 0
                textStyle.fontSizeValue: 5
                textStyle.base: lightStyle.style
                text: languages[0] + ", " + languages[1] + ", " + languages[2]
                textStyle.color: Color.Gray
            }
        }
    }
}
