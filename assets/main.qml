import "tart.js" as Tart
import bb.cascades 1.2

Page {
    id: root
    onCreationCompleted: {
        //Application.invisible.connect(onInvisible);
        //Application.awake.connect(onVisible);

        //Tart.debug = true;
        Tart.init(_tart, Application);

        Tart.register(root);
        Tart.send('uiReady');
        loginSheet.open();
    }
    function onLoginComplete(data) {
        if (data.data == "true") {
            loading.running = false;
            loginSheet.close();
        }
        else {
            userField.text = "";
            passwordField.text = "";
        }
    }

    attachedObjects: [
        Sheet {
            id: loginSheet
            Page {
                titleBar: TitleBar {
                    title: "Login in to Continue"
                    visibility: ChromeVisibility.Visible
                    scrollBehavior: TitleBarScrollBehavior.Sticky
                }
                Container {
                    layout: DockLayout {

                    }
                    Container {
                        topPadding: 10
                        rightPadding: 10
                        leftPadding: 10
                        horizontalAlignment: HorizontalAlignment.Center

                        TextField {
                            enabled: true
                            verticalAlignment: VerticalAlignment.Center
                            id: userField
                            hintText: "Github Account"
                            bottomMargin: 0
                            input {
                                flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.SpellCheckOff
                            }
                        }
                        TextField {
                            enabled: true
                            verticalAlignment: VerticalAlignment.Center
                            id: passwordField
                            hintText: "Password"
                            bottomMargin: 30
                            input.masking: TextInputMasking.Masked
                            inputMode: TextFieldInputMode.Password
                            input {
                                flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.SpellCheckOff
                            }
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center
                            Button {
                                text: "Login"
                                id: loginButton
                                onClicked: {
                                    loading.running = true;
                                    Tart.send('signIn', {
                                            "username": userField.text,
                                            "password": passwordField.text
                                        })
                                }
                            }
                            ActivityIndicator {
                                horizontalAlignment: HorizontalAlignment.Center
                                id: loading
                                visible: true
                                running: false
                                minHeight: 300
                                minWidth: 300
                            }
                        }
                    }

                }
                attachedObjects: [
                    TextStyleDefinition {
                        id: lightStyle
                        base: SystemDefaults.TextStyles.BodyText
                        fontSize: FontSize.PointValue
                        fontSizeValue: 7
                        fontWeight: FontWeight.W100
                    }
                ]
            }
        }
    ]

    function onDatesReceived(data) {
        loadingList.visible = false;
        loadingList.running = false;
        recModel.append({
                type: 'item',
                name: data.result['dateName'],
                location: data.result['dateLocation'],
                languages: data.result['dateLanguages'],
                repos: data.result['dateRepos'],
                avatar_url: data.result['dateAvatar_url'],
                username: data.result['dateUsername'],
                email: data.result['dateEmail'],
                stars: data.result['dateStars']
            });
    }
    titleBar: TitleBar {
        title: "GitDating"
        kind: TitleBarKind.Default
        attachedObjects: [
            TapHandler {
                onTapped: {
                    youItem.visible = ! youItem.visible
                }
            }
        ]
        visibility: ChromeVisibility.Visible
        scrollBehavior: TitleBarScrollBehavior.Sticky
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
        ActivityIndicator {
            id: loadingList
            visible: true
            running: true
            horizontalAlignment: HorizontalAlignment.Center
            minHeight: 300
            minWidth: 300
            verticalAlignment: VerticalAlignment.Center
        }
        ListView {
            dataModel: ArrayDataModel {
                id: recModel
            }
            function itemType(data, indexPath) {
                return data.type
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    DateItem {
                        property string type: ListItemData.type
                        dateName: ListItemData.name
                        dateLocation: ListItemData.location
                        dateLanguages: ListItemData.languages
                        dateRepos: ListItemData.repos
                        dateAvatar_url: ListItemData.avatar_url
                        dateUsername: ListItemData.username
                        dateEmail: ListItemData.email
                        dateStars: ListItemData.stars

                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
            ]
        }
    }
}
