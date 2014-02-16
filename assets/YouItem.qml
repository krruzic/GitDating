import bb.cascades 1.2
import "tart.js" as Tart

Container {
    id: youItem
    //background: background.imagePaint
    verticalAlignment: VerticalAlignment.Center
    property string name: "Test Name"
    property string location: "Calgary, AB"
    property variant languages: [ "Python", "Java", "C" ]
    property string imageLoc: ""
    property int repos: 0
    onCreationCompleted: {
        Tart.register(youItem);
    }
    
    function onUserData(data) {
        console.log("data received!!");
        nameID.text = data.data["name"];
        locationID.text = data.data["location"];
        languagesID.text = data.data["languages"][0] + " " + data.data["languages"][1] + " " + data.data["languages"][2];
        imageID.imageSource = data.image;
        repoID.text = data.data["num_of_repos"] + " repos";
        Tart.send('fillList');
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
                id: imageID
                verticalAlignment: VerticalAlignment.Center
                imageSource: "asset:///images/defaultAvatar.png"
                maxWidth: 100
                maxHeight: 100
                minWidth: 100
                minHeight: 100
                onImageSourceChanged: {
                    console.log("IMAGE CHANGED " + imageSource)
                }
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
                    id: nameID
                    maxWidth: 300
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.base: lightStyle.style
                    text: name
                }
                Label {
                    id: repoID
                    topMargin: 0
                    bottomMargin: 0
                    textStyle.fontSizeValue: 5
                    textStyle.base: lightStyle.style
                    text: repos + " Repos"
                    textStyle.color: Color.Gray
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
                id: locationID
                topMargin: 0
                bottomMargin: 0
                textStyle.fontSizeValue: 5
                textStyle.base: lightStyle.style
                text: location
                textStyle.color: Color.Gray
            }
            Label {
                id: languagesID
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
