import threading, os, glob, random, shutil
import requests, requests.utils, pickle, re, html.parser, cgi
import json
from github import Github


def scrapeImages():
    obj  = json.load(open(os.getcwd() + "/data1.json"))
    for i in obj:
        response = requests.get(i["avatar"], stream=True)
        with open("../assets/profiles/" + i["username"] + ".png", 'wb') as out_file:
            shutil.copyfileobj(response.raw, out_file)
        del response

scrapeImages()