
import json

from web3 import Web3

def read_json(filename):
    with open(filename, 'r') as f:
        return json.load(f)
    
def write_json(json_file, name):
    with open(name, 'w') as f:
        json.dump(json_file, f)

def main():
    json_file = read_json('count.json')
    new_json_file = {}
    #print key and value
    for key in json_file:
        lowerCaseAddress = key.lower()
        checksumAddress = Web3.toChecksumAddress(lowerCaseAddress)
        new_json_file[checksumAddress] = json_file[key]
    json_file = {k: v for k, v in sorted(new_json_file.items(), key=lambda item: item[1], reverse=True)}
    write_json(json_file, 'count-checksum.json')

if __name__ == "__main__":
    main()

