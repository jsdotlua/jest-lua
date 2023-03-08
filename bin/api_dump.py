#!/usr/bin/python3

import json
import re
from urllib.request import urlopen

VERSION = urlopen("https://s3.amazonaws.com/setup.roblox.com/versionQTStudio").read().decode()
URL = "https://s3.amazonaws.com/setup.roblox.com/" + VERSION + "-API-Dump.json"

instances = {}

EXCLUDED_PROPS = {"Source", "LinkedSource"}
EXCLUDED_TAGS = {"Hidden", "Deprecated", "NotScriptable"}

def has_excluded_properties(prop):
    return prop in EXCLUDED_PROPS

def has_excluded_tags(member):
    if not "Tags" in member:
        return False
    for tag in EXCLUDED_TAGS:
        if tag in member["Tags"]:
            return True

def ignore_class(c):
    return c["Name"] == "Studio" or ("Tags" in c and "Service" in c["Tags"])

data = json.loads(urlopen(URL).read().decode())
for c in data["Classes"]:
    if not ignore_class(c):
        inst = {}
        props = []
        for member in c["Members"]:
            if (member["MemberType"] == "Property" and
                not has_excluded_tags(member) and
                not has_excluded_properties(member["Name"])):
                    props.append(member["Name"])
        inst["Properties"] = props
        if c["Superclass"] != "<<<ROOT>>>":
            inst["Superclass"] = c["Superclass"]
        instances[c["Name"]] = inst

output = json.dumps(instances, separators=(',', '=')).replace('[', '{').replace(']', '}').replace('"Superclass"', "Superclass")
output = re.sub(r'"(\w+)"={', r'\1={', output)
output = "-- " + VERSION + "\n" + "return " + output

file = open("RobloxApiDump.lua", "w")
file.write(output)