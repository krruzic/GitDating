import threading, os, glob, random
import requests, requests.utils, pickle, re, html.parser, cgi
import json
from github import Github



class gitDate():

    def getAuth(self, session):


        people = []
        names = []
        genders = []
        thing = []
        a = open("names.txt", "r+")
        for line in a.readlines():
            lines = line.split(', ')
            thing.append(lines)
        for i in thing:
            print(i)
            i[1].replace("\\n", "")
            names.append(i[0])
            genders.append(i[1])
        iterNames = iter(names)

            #print(genders)
        for i in range(len(names)):
            print("entering name " + names[i])
            try:
                account = session.get_user(names[i])
            # try:
                
            except:
                print("Skipping " + names[i])
                next(iterNames)
            person = {}
            person["username"] = names[i]
            person["num_of_repos"] = 0
            person["languages"] = []
            person["location"] = account.location
            person["avatar"] = account.avatar_url
            person["email"] = account.email
            person["name"] = account.name
            person["gender"] = genders[i]

            if person["name"] == None:
                person["name"] = names[i]
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
                    if (item.language != None):
                        if (item.language not in person["languages"] and len(person["languages"]) < 3):
                            person["languages"].append(item.language)
                while len(person["languages"]) < 3:
                    person["languages"].append("")

                people.append(person)

        with open('data1.json', 'w') as outfile:
            json.dump(people, outfile, indent=4, separators=(',',':'))
        a.close()
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


    def calculateCompatibility(self, data):

        obj = json.load(open(os.getcwd() + "/app/native/app/data1.json"))

        res = []
        locations = [x.strip() for x in data["location"].split(',')]

        for i in obj:
            skip = True
            date = {}
            locationStars = 0
            repoStars = 0
            languageStars = 0

            dateLanguages = i["languages"]

            dateLocations = [x.strip() for x in i["location"].split(',')]
            dateRepos = i["num_of_repos"]
            print(data["looking_for"])

            if i["gender"] == data["looking_for"]:
                print("Skipping gender")
                skip = False
            # if i["name"] == data["name"]:
            #     print("Skipping you")
            #     skip = True


            for item in dateLocations:
                if (item in locations and locationStars == 0):
                    if (item != ""):
                        print("item in location " + item)
                        locationStars = 1
            if dateLanguages != ['', '', '']:
                for item in dateLanguages:
                    if item in data["languages"]:
                        if item != '':
                            languageStars += 1

            mini = data["num_of_repos"] - 5
            maxi = data["num_of_repos"] + 5
            if dateRepos != 0:
                if (dateRepos >= mini) and (dateRepos <= maxi):
                    repoStars = 1

            date["dateStars"] = (locationStars + repoStars + languageStars)
            date["dateRepos"] = i["num_of_repos"]
            date["dateLanguages"] = i["languages"]
            date["dateLocation"] = i["location"]
            date["dateEmail"] = i["email"]
            date["dateAvatar_url"] = i["avatar"]
            date["dateUsername"] = i["username"]
            date["dateName"] = i["name"]
            date["dateImg"] = os.getcwd() + "/app/native/assets/profiles/" + i["username"] + ".png"
            date["gender"] = i["gender"]

            if date["dateName"] == None:
                date["dateName"] = i["username"]
            if date["dateLocation"] == None:
                date["dateLocation"] = ""
            if date["dateEmail"] == None:
                date["dateEmail"] = ""

            if data["languages"][2] == "" and date["dateLanguages"][2] == "":
                date["dateStars"] += 1
            print("Skipping? ", str(skip))
            if skip == False:
                res.append(date)

        return res




            #j = json.dumps(i, indent=4, separators=',')
            #res.append(j)
        #print(res


# data = {
#     "name": "Kristopher Ruzic",
#     "looking_for": "female",
#     "location": "Calgary, AB",
#     "languages": [
#     "Python", "PHP"],
#     "num_of_repos": 10
#     }

# gh = gitDate()
# #sess = Github('krruzic', '872lbangk278')
# #results = gh.getAuth(sess)
# res = gh.calculateCompatibility(data)
# with open('test.json', 'w') as outfile:
#     json.dump(res, outfile, indent=4, separators=(',',':'))

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