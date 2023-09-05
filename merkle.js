import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import {parse} from "csv-parse";

// Read the content of the Snapshot.csv file
const csvContent = fs.readFileSync("Snapshot.csv", "utf-8");

// Remove the UTF-8 BOM from the content
const contentWithoutBOM = csvContent.replace(/^\uFEFF/, "");

// Parse the content to create an array of values
parse(contentWithoutBOM, {
  columns: false,
  skip_empty_lines: true,
}, (err, values) => {
  if (err) {
    console.error("Error parsing CSV:", err);
    return;
  }
  console.log("CSV parsed successfully:", values);

    const merkleTree = StandardMerkleTree.of(values, ["address", "uint256"]);

    console.log("Merkle root:", merkleTree.root);

    fs.writeFileSync("merkleTree.json", JSON.stringify(merkleTree.dump()));
});
