import json
from typing import List, Tuple

from Crypto.Hash import keccak

def hash_data(data: str) -> str:
    keccak_hash = keccak.new(digest_bits=256)
    keccak_hash.update(data.encode('utf-8'))
    return keccak_hash.hexdigest()

def merkle_tree(data: List[str]) -> List[str]:
    if len(data) == 1:
        return data
    tree_layer = []
    for i in range(0, len(data), 2):
        if i + 1 < len(data):
            combined_hash = hash_data(data[i] + data[i + 1])
        else:
            combined_hash = hash_data(data[i] + data[i])
        tree_layer.append(combined_hash)
    return merkle_tree(tree_layer)

def merkle_proof(data: List[str], target: str) -> Tuple[str, List[str]]:
    if len(data) == 1:
        return data[0], []
    tree_layer = []
    proof = []
    for i in range(0, len(data), 2):
        if i + 1 < len(data):
            combined_hash = hash_data(data[i] + data[i + 1])
            if target in (data[i], data[i + 1]):
                proof.append(data[i + (0 if data[i] == target else 1)])
        else:
            combined_hash = hash_data(data[i] + data[i])
            if target == data[i]:
                proof.append(data[i])
        tree_layer.append(combined_hash)
    root, sub_proof = merkle_proof(tree_layer, target)
    return root, proof + sub_proof

file = open("count-checksum.json", "r")
input_data = json.load(file)
file.close()

hashed_data = [hash_data(f"{address}-{quantity}") for address, quantity in input_data.items()]
merkle_root = merkle_tree(hashed_data)[0]
merkle_proofs = {address: merkle_proof(hashed_data, hash_data(f"{address}-{quantity}"))[1] for address, quantity in input_data.items()}

print("Merkle Root:", merkle_root)
print("Merkle Proofs:")
for address, proof in merkle_proofs.items():
    print(f"{address}: {proof}")


# print the decoded data

print("Decoded Data:")
for address, quantity in input_data.items():
    print(f"{address}: {quantity}")
