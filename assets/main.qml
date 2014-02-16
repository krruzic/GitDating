import "tart.js" as Tart
import bb.cascades 1.2

Page {
    titleBar: TitleBar {
        title: "GitDating"
        kind: TitleBarKind.Default
        attachedObjects: [
            TapHandler {
                onTapped: {
                    youItem.visible = !youItem.visible
                }
            }
        ]
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        YouItem {
            id: youItem
            horizontalAlignment: HorizontalAlignment.Fill
        }
        Header {
            title: "Github users similar to you"
        }
        DateItem {
        }
        ListView {
            dataModel: ArrayDataModel {
                id: recModel
            }
            listItemComponents: [
                ListItemComponent {
                    DateItem {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
            ]
        }
    }
}
