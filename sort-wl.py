import csv
import sys
import os
import json

filename = "holder-snapshot.csv"
def read_csv(filename):
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        return list(reader)
    
def sort_csv(csv_file): 
    sorted_csv = {}
    for row in csv_file:
        if len(row) < 2:
            continue
        if row[1] in sorted_csv:
            sorted_csv[row[1]].append(row[0])
        else:
            sorted_csv[row[1]] = [row[0]]
    return sorted_csv


def write_json(csv_file, name):
    with open(name, 'w') as f:
        json.dump(csv_file, f)

def count(jsonfile):
    newdict = {}
    with open(jsonfile, 'r') as f:
        data = json.load(f)

    for key in data:
        data[key] = len(data[key])
        newdict[key] = data[key]

    #sort by value
    newdict = {k: v for k, v in sorted(newdict.items(), key=lambda item: item[1], reverse=True)}

    with open('count.json', 'w') as f:
        json.dump(newdict, f)
        

def main():
    csv_file = read_csv(filename)
    print(csv_file)
    sorted_csv = sort_csv(csv_file)
    name = filename.split('.')[0] + '.json'
    write_json(sorted_csv, name)
    count(name)

        

if __name__ == "__main__":
    main()