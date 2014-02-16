import "tart.js" as Tart
import bb.cascades 1.2
import "global.js" as Global

Container {
    //background: background.imagePaint
    verticalAlignment: VerticalAlignment.Center
    property int dateStars: 5
    property variant compatibilityVals: [ "No compatibility", "Some similarities...", "Okay connection", "Good enough", "Great together!",
        "Perfect Match!" ]
    property string dateName: "Kristopher Ruzic"
    property string dateLocation: "Calgary, AB"
    property variant dateLanguages: [ "Python", "Java", "C" ]
    property int dateRepos: 0
    property string dateUsername: ""
    property string dateAvatar_url: ""
    property string dateEmail: ""

    onDateEmailChanged: {
        if (email != "") {
            emailAction.enabled = true;
        }
    }

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
        },
        ActionSet {
            ActionItem {
                id: emailAction
            }
        }
    ]
    Container {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Fill
        topPadding: 10
        layout: DockLayout {
        }
        Container {
            leftPadding: 10
            //verticalAlignment: VerticalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Left
            ImageView {
                verticalAlignment: VerticalAlignment.Center
                imageSource: "asset:///images/defaultAvatar.png"
                maxWidth: 100
                maxHeight: 100
            }
            Container {
                translationY: -2
                verticalAlignment: VerticalAlignment.Center
                Label {
                    maxWidth: 300
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.base: lightStyle.style
                    text: dateName
                }
                Label {
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.fontSizeValue: 5
                    textStyle.base: lightStyle.style
                    text: dateLocation
                    textStyle.color: Color.Gray
                }
                Label {
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.fontSizeValue: 5
                    textStyle.base: lightStyle.style
                    text: dateLanguages[0] + ", " + dateLanguages[1] + ", " + dateLanguages[2]
                    textStyle.color: Color.Gray
                }
                Label {
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.fontSizeValue: 5
                    textStyle.base: lightStyle.style
                    text: dateRepos + " Repos"
                    textStyle.color: Color.Gray
                }
            }
        }

        Container {
            rightPadding: 10
            translationY: -5
            horizontalAlignment: HorizontalAlignment.Right
            Label {
                id: compatibilityName
                maxWidth: 250
                topMargin: 0
                bottomMargin: 0
                textStyle.base: lightStyle.style
                text: compatibilityVals[dateStars]
                textStyle.color: Color.Gray
            }
            ImageView {
                id: compatibilityImage
                topMargin: 0
                bottomMargin: 0
                horizontalAlignment: HorizontalAlignment.Right
                imageSource: "asset:///images/hearts/" + dateStars + ".png"
            }
        }
    }
    Divider {
        bottomMargin: 0
    }
}
