import Web3 from 'web3';

var contractData = contractObject.new.getData(someparam, another, {data: contractBytecode});
var estimate = web3.eth.estimateGas({data: contractData})

const Web3 = require('web3'); // Import the web3.js library

// Initialize a web3 instance with your Ethereum provider URL
const web3 = new Web3('YOUR_ETHEREUM_PROVIDER_URL');

// Replace with the actual contract ABI and address
const contractABI = [...]; // ABI of your contract
const contractAddress = 'YOUR_CONTRACT_ADDRESS';

// Create a contract instance
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Specify the quantity for minting
const quantity = 5; // Replace with the desired quantity

// Specify the sender's address
const senderAddress = 'YOUR_SENDER_ADDRESS';

// Specify the gas price (in Wei)
const gasPriceWei = getCurrentGasPrices()
// Create a data object for the _mint() function call
const data = contract.methods._mint(quantity).encodeABI();

// Estimate the gas cost for the _mint() function
contract.methods.estimateGas({
    to: contractAddress,
    data: data,
    from: senderAddress,
    gasPrice: gasPriceWei
})
.then((gasEstimate) => {
    console.log(`Estimated gas cost for minting ${quantity} tokens: ${gasEstimate}`);
})
.catch((error) => {
    console.error('Error estimating gas cost:', error);
});

// Function to get the current gas prices
function getCurrentGasPrices() {
    api = 'https://ethgasstation.info/json/ethgasAPI.json';
    return fetch(api)
    .then(function(response){
        return response.json();
    }
    ).then(function(myJson){
        return myJson.fastest * 100000000;
    }
    );
}

