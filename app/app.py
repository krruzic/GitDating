import threading, os, glob, shutil
# from .HNStoryAPI import getStoryPage
# from .HNCommentAPI import getCommentPage
# from .HNUserAPI import getUserPage
# from .HNSearchAPI import getSearchResults
import requests, requests.utils
from github import Github
import tart
from .git import gitDate

class App(tart.Application):
    """ The class that directly communicates with Tart and Cascades
    """

    SETTINGS_FILE = 'data/settings.state'
    HEADERS = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.29 Safari/537.22',
    }
    gh = None
    personalData = {}

    def __init__(self):
        super().__init__(debug=False)   # set True for some extra debug output
        self.settings = {
        }
        self.restore_data(self.settings, self.SETTINGS_FILE)
        print("restored: ", self.settings)

    def onUiReady(self):
        print("UI READY!!")
        tart.send('restoreSettings', **self.settings)

    def onSaveSettings(self, settings):
        self.settings.update(settings)
        self.save_data(self.settings, self.SETTINGS_FILE)

    def onCopy(self, data):
        from tart import clipboard
        c = clipboard.Clipboard()
        mimeType = 'text/plain'
        c.insert(mimeType, articleLink)
        tart.send('copyResult', text=data + " copied to clipboard!")



## Tart sends
    def onSignIn(self, username, password, looking_for="female"):
        print("Signing in!")
        self.gh = Github(username, password)
        me = self.gh.get_user()
    
        myRepos = me.get_repos()
        data = {}
        try:
            data["location"] = me.location
            tart.send('loginComplete', data="true")
        except:
            tart.send('loginComplete', data="false")
            return

        data["name"] = me.name
        data["num_of_repos"] = 0
        data["languages"] = []
        data["looking_for"] = looking_for

        for item in myRepos:                        
            data["num_of_repos"] = data["num_of_repos"] + 1
            if (item.language != None and item.language not in data["languages"] and len(data["languages"]) < 3):
                data["languages"].append(item.language)
        while len(data["languages"]) < 3:
            data["languages"].append("")
        response = requests.get(me.avatar_url, stream=True)
        with open('data/profile.png', 'wb') as out_file:
            shutil.copyfileobj(response.raw, out_file)
        del response
        self.personalData = data
        if data["name"] == None:
            data["name"] = me.username
        if data["location"] == None:
            data["location"] = ""

        tart.send('userData', data=data, image=(os.getcwd() + "/" + "data/profile.png"))
        print("Past tart..")
        return

    def onFillList(self):
        gd = gitDate()
        print(self.personalData)
        results = gd.calculateCompatibility(self.personalData)
        print("List Received!!")
        print(results)
        for result in results:
            tart.send('datesReceived', result=result)