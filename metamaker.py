# read a json file and make 10000 copies of it with the index number in the name

import json
import random

genderoptions = ["male", "female"]
nameoptions = {"male": ["Bob", "Joe", "Bill", "Steve", "John", "Mike", "Dave", "Tom", "Jim", "Tim", "Sam", "Dan", "Fred", 
                        "Frank", "Jack", "Harry", "Larry", "Gary", "Jerry", "Terry", "Troy", "Roy", "Ray", "Jay", "Wayne", 
                        "Shane", "Shawn", "Sean", "Dean", "Dane", "Dale", "Drew", "Duke", "Luke", "Jake", "Blake", "Drake", 
                        "Derek", "Derrick", "Dylan", "Dustin", "Dillon", "Dennis", "Darryl", "Darryn", "Damon", "Darby", 
                        "Norbert", "Nigel", "Nathan", "Nate", "Nolan", "Nathaniel", "Ned", "Nedward", "Nedwin", "Lucas", 
                        "Lucius", "Luther", "Lyle", "Lance", "Landon", "Liam", "Lionel", "Leroy", "Lenny", "Zed", "Zach", 
                        "Zachary", "Zane", "Zeke", "Ziggy", "Zigfried", "Zigmond"],
               "female": ["Amy", "Mery", "Ashley", "Sara", "Sarah", "Sally", "Sue", "Susan", "Suzanne", "Margaret", "Marge", 
                          "Maggie", "Megan", "Maggie", "Marge", "Megan", "Molly", "Mindy", "Patty", "Pam", "Onika", "Olive", 
                          "Oprah", "Odelia", "Ophira", "Orianna", "Oriole", "Ori", "Ora", "Oona"]}
clothingoptions = ["none", "tiger-fur", "leather",
                   "gator-skin", "bear-skin", "wool", "cotton", "silk", "linen"]
weaponoptions = list(["none", "club", "spear", "bow",
                      "sword", "axe", "mace", "dagger", "staff"])
armoroptions = ["none", "tiger-fur", "leather", "gator-skin",
                "bear-skin", "wool", "cotton", "silk", "linen"]
accessoryoptions = ["none", "tiger-fur", "leather",
                    "gator-skin", "bear-skin", "wool", "cotton", "silk", "linen"]
healthoptions = [25, 50, 75, 100]
staminaoptions = [25, 50, 75, 100]
strengthoptions = [25, 50, 75, 100]
intelligenceoptions = [25, 50, 75, 100]
speedoptions = [25, 50, 75, 100]
evolution_stageoptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
luckoptions = [25, 50, 75, 100]


def run():
    for i in range(1, 10001):
        gender = random.choice(genderoptions)
        name = random.choice(nameoptions[gender])
        clothing = random.choice(clothingoptions)
        weapon = random.choice(weaponoptions)
        armor = random.choice(armoroptions)
        accessory = random.choice(accessoryoptions)
        health = random.choice(healthoptions)
        stamina = random.choice(staminaoptions)
        strength = random.choice(strengthoptions)
        intelligence = random.choice(intelligenceoptions)
        speed = random.choice(speedoptions)
        evolution_stage = random.choice(evolution_stageoptions)
        luck = random.choice(luckoptions)
        link = "https://darwins.app/images/" + str(i) + ".png"

        data = {
            "name": name,
            "description": "A unique Darwin NFT that evolves through time, starting as a caveman and progressing forward.",
            "image": link,
            "attributes": [
                {
                    "trait_type": "Gender",
                    "value": gender
                },
                {
                    "trait_type": "Clothing",
                    "value": clothing
                },
                {
                    "trait_type": "Weapon",
                    "value": weapon
                },
                {
                    "trait_type": "Armor",
                    "value": armor
                },
                {
                    "trait_type": "Accessory",
                    "value": accessory
                },
                {
                    "trait_type": "Health",
                    "value": health
                },
                {
                    "trait_type": "Stamina",
                    "value": stamina
                },
                {
                    "trait_type": "Strength",
                    "value": strength
                },
                {
                    "trait_type": "Intelligence",
                    "value": intelligence
                },
                {
                    "trait_type": "Speed",
                    "value": speed
                },
                {
                    "display_type": "number",
                    "trait_type": "Evolution Stage",
                    "value": evolution_stage
                },
                {
                    "display_type": "boost_percentage",
                    "trait_type": "Luck",
                    "value": luck
                }
            ]
        }

        converted = json.dumps(data)
        folder = "metadata/"
        filename = folder + str(i) + ".json"

        with open(filename, "w") as f:
            f.write(converted)

    return "done"


if __name__ == "__main__":
    print(run())
