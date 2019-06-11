import requests
import json

#Makes a request and returns the data in JSON format
def makeRequest(hashtag):
    api = "https://query.displaypurposes.com/tag/"
    payload = api + hashtag
    r = requests.get(payload)
    json_formatted = r.json()
    return json_formatted

#TODO: change this to dictionary so you can sort by relevance
#get all related hashtags
def relatedHashtags(hashtagInfo):
    relatedHashtags = []
    for hashtag in hashtagInfo['results']:
        relatedHashtags.append(hashtag['tag'])

    return relatedHashtags


# Ask for hashtags
tag = input("Hashtag or hashtags to search: ")
tags = tag.split()

# Store responses
responses = []
for i in tags:
    returned = makeRequest(i)
    responses.append(returned)

# Get all related hashtags
allRelated = []
for r in responses:
    for word in relatedHashtags(r):
        allRelated.append(word)


for hashtag in allRelated:
    print(hashtag)

# print(len(allRelated))




# first index is word index of hashtags given by user: responses[]
# second index is results dictionaries, each dictionary is one hashtag
# last index is index of dictionary pertaining to related hashtags
# print(responses[0]['results'][1])
# print(" --------------- TESTING ----------------\n")
# print(relatedHashtags(responses[0]))

    
