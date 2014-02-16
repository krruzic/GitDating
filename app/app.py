import threading, os, glob
# from .HNStoryAPI import getStoryPage
# from .HNCommentAPI import getCommentPage
# from .HNUserAPI import getUserPage
# from .HNSearchAPI import getSearchResults
from bs4 import BeautifulSoup
from datetime import datetime, timedelta
import requests, requests.utils, pickle, re, html.parser, cgi
from github import Github
import tart

import readeryc

class App(tart.Application):
    """ The class that directly communicates with Tart and Cascades
    """

    HEADERS = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.29 Safari/537.22',
    }
    gd = None

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
    def onSignIn(self, username, password):
        self.gd = gitDate(username, password)
        me = self.gd.get_user()

        myRepos = me.get_repos()
        for repo in myRepos:
            if repo != None:
                print(repo.name, repo.language)

        data = {}
        data["location"] = me.location
        data["avatar_url"] = me.avatar_url
        data["languages"] = []
        if repos != None:
            for item in repos:                        
                data["num_of_repos"] = data["num_of_repos"] + 1
                if (item.language not in person["languages"] and item.language != None):
                    if (len(data["languages"]) < 3):
                        data["languages"].append(item.language)

        self.personalData = data
        tart.send('userData', data=data)


    def onGetRecs(self):
        results = github.calculateCompatibility(self.personalData) 
        tart.send('datesReceived', results=results)