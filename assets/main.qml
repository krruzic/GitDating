import "tart.js" as Tart
import bb.cascades 1.2
import bb.system 1.2

Page {
    id: root
    onCreationCompleted: {
        loginSheet.open();
        //Application.invisible.connect(onInvisible);
        //Application.awake.connect(onVisible);

        //Tart.debug = true;
        Tart.init(_tart, Application);

        Tart.register(root);
        Tart.send('uiReady');

    }

    function onLoginComplete(data) {
        if (data.data == "true") {
            loading.running = false;
        } else {
            errorToast.body = "Error logging in!";
            errorToast.cancel();
            errorToast.show();
            loading.running = false;
            userField.text = "";
            passwordField.text = "";
        }
    }
    function onUserData(data) {
        youItem.name = data.data["name"];
        youItem.location = data.data["location"];
        youItem.languages = data.data["languages"][0] + " " + data.data["languages"][1] + " " + data.data["languages"][2];
        youItem.imageLoc = data.image;
        youItem.repos = data.data["num_of_repos"];
        loginSheet.close();
        Tart.send('fillList');	
    }

    attachedObjects: [
        Sheet {
            id: loginSheet
            peekEnabled: false
            Page {
                id: sheetPage
                property string selected: ""
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
                        Label {
                            text: "Looking for?"
                            textStyle.base: lightStyle.style
                            bottomMargin: 0
                            topMargin: 0
                        }
                        RadioGroup {
                            id: radioButtons

                            options: [
                                Option {
                                    id: femaleSelection
                                    text: "female"
                                    selected: true
                                },
                                Option {
                                    id: maleSelection
                                    text: "male"
                                }
                            ]
                            onSelectedOptionChanged: {
                                sheetPage.selected = selectedOption.text;
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
                                            "password": passwordField.text,
                                            "looking_for": radioButtons.selectedOption.text
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
        },
        SystemToast {
            id: errorToast
        }
    ]

    function onDatesReceived(data) {
        // loadingList.visible = false;
        // loadingList.running = false;
        recModel.append({
                type: 'item',
                name: data.result['dateName'],
                location: data.result['dateLocation'],
                languages: data.result['dateLanguages'],
                repos: data.result['dateRepos'],
                avatar_url: data.result['dateAvatar_url'],
                username: data.result['dateUsername'],
                email: data.result['dateEmail'],
                stars: data.result['dateStars'],
                img: data.result["dateImg"]
            });
        header.subtitle = recModel.size();
    }
    titleBar: TitleBar {
        title: "GitDating"
        kind: TitleBarKind.Default
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
            id: header
            title: "Github users similar to you"
        }
        //        ActivityIndicator {
        //            id: loadingList
        //            visible: true
        //            running: true
        //            horizontalAlignment: HorizontalAlignment.Center
        //            minHeight: 300
        //            minWidth: 300
        //            verticalAlignment: VerticalAlignment.Center
        //            touchPropagationMode: TouchPropagationMode.Full
        //        }
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
                        dateImg: ListItemData.img
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
//                        contextActions: [
//                            ActionSet {
//                                actions: [
//                                    InvokeActionItem {
//                                        id: facebookShare
//                                        enabled: true
//                                        title: "Share to FaceBook"
//                                        query {
//                                            mimeType: "mime/text"
//                                            invokeActionId: "bb.action.SHARE"
//                                            invokeTargetId: "Facebook"
//                                            data: "Hi, " + ListItemData.name + " I just got matched to you with GitDating for BB10. It's great we went to PennApps, will you be my Hackentine?"
//                                        }
//                                        onTriggered: {
//                                            console.log("TEST")                                            
//                                        }
//                                    }
//                                ]
//                            }
//                        ]
                    }

                }
            ]
            onTriggered: {
                console.log(indexPath);
            }
        }
    }
}
