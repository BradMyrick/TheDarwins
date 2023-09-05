import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

// (1)
const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("merkleTree.json", "utf8")));
console.log('Merkle root:', tree.root);
// (2)
for (const [i, v] of tree.entries()) {
  if (v[0] === '0xffccf17d09e0585e7c1ba3a3584fc9356c93d11f') {
    const proof = tree.getProof(i);
    console.log('Value:', v);
    console.log('Proof:', proof);
  }
}