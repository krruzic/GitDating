import threading, os, glob, random
import requests, requests.utils, pickle, re, html.parser, cgi
import json
from github import Github



class gitDate():

    def getAuth(self, session):

        names = self.getNames()
        me = g.get_user()

        print(me.name)
        myRepos = me.get_repos()
        for repo in myRepos:
            if repo != None:
                print(repo.name, repo.language)
        data = {}
        data["location"] = me.location
        data["avatar_url"] = me.avatar_url
        data["languages"] = []
        data["num_of_repos"] = 0

        if myRepos != None:
            for item in myRepos:                        
                    #repo = {}
                data["num_of_repos"] = data["num_of_repos"] + 1
                if (item.language not in data["languages"] and item.language != None):
                    if (len(data["languages"]) < 3):
                        data["languages"].append(item.language)

        print()
        people = []
        iterNames = iter(names)
        f = open('results.json', 'w+')
        for name in names:
            print("entering name " + name)
            try:
                account = g.get_user(name)
            except:
                next(iterNames)
            person = {}
            person["username"] = name
            person["num_of_repos"] = 0
            person["languages"] = []
            person["location"] = account.location
            person["avatar"] = account.avatar_url
            person["email"] = account.email
            person["name"] = account.name
            #person["username"] = account.login

            if person["location"] == None:
                person["location"] = ""
            if person["email"] == None:
                person["email"] = ""


            try:             
                repos = account.get_repos()
            except:
                next(iterNames)
            if repos != None:
                for item in repos:                        
                    #repo = {}
                    person["num_of_repos"] = person["num_of_repos"] + 1
                    if (item.language not in person["languages"] and item.language != None):
                        if (len(person["languages"]) < 3):
                            person["languages"].append(item.language)
                    #person["issue_link"] = "https://github.com/" + name + "/" + item.name + "/issues/"

                    #repo["repo_name"] = item.name
                    #repo["language"] = item.language
                    #person["repos"].append(repo)
                people.append(person)

        with open('data1.json', 'w') as outfile:
            json.dump(people, outfile, indent=4, separators=(',',':'))
        f.close()
        return people

    def getNames(self):
        """ Gets 20 random profile names
        """
        db_url = 'http://total-impact.cloudant.com/github_usernames'

        rand_hex_string = hex(random.getrandbits(128))[2:-1] # courtesy http://stackoverflow.com/a/976607/226013
        req_url = db_url + '/_all_docs?include_docs=true&limit={limit}&startkey="{startkey}"'.format(
            limit=10,
            startkey=rand_hex_string
        )
        r = requests.get(req_url)
        data = r.json()
        names = []
        # for line in f:
        #     if line != None:
        #         names.append(line)
        #         print(line)
        for i in data['rows']:
            names.append(i['doc']['actor'])
        return names


    def calculateCompatibility(self):
        data = {
        "location": "Calgary, AB",
        "languages": ["Python", "Java", "C"],
        "num_of_repos": 5
        }

        obj  = json.load(open("data1.json"))
        selections = []
        for i in range(50):
            selections.append(random.randrange(len(obj)))

        res = []
        locations = [x.strip() for x in data["location"].split(',')]



        print(obj[1]["location"])
        for i in selections:
            date = {}
            locationStars = 0
            repoStars = 0
            languageStars = 0

            dateLanguages = obj[i]["languages"]

            dateLocations = [x.strip() for x in obj[i]["location"].split(',')]
            dateRepos = obj[i]["num_of_repos"]


            for item in dateLocations:
                print(item)
                print(locations)
                if (item in locations and locationStars == 0):
                    print("item in location")
                    locationStars = 1

            for item in dateLanguages:
                if item in data["languages"]:
                    languageStars += 1


            if ((data["num_of_repos"] - 5) <= dateRepos) and (dateRepos >= (data["num_of_repos"] + 5)):
                repoStars = 1

            date["dateStars"] = (locationStars + repoStars + languageStars)
            print("locationStars", locationStars, "repoStars", repoStars, "languageStars", languageStars)
            date["dateRepos"] = dateRepos
            date["dateLanguages"] = dateLanguages
            date["dateLocation"] = obj[i]["location"]
            date["dateEmail"] = obj[i]["email"]
            date["dateAvatar_url"] = obj[i]["avatar"]
            date["dateUsername"] = obj[i]["username"]
            date["dateName"] = obj[i]["name"]

            res.append(date)
        return res




            #j = json.dumps(obj[i], indent=4, separators=',')
            #res.append(j)
        #print(res)


#gh = gitDate()
#results = gh.getAuth('krruzic', '872lbangk278')
#res = gh.calculateCompatibility()
#print(res)
# results = json.dumps(results)
# print(results)
# for res in results:
#     if 'avatar_url' in res:
#         print("avatar " + res['avatar_url'])
#     if 'name' in res:
#         print("name " + res['name'])
#     if 'location' in res:
#         print("location " + res['location'])