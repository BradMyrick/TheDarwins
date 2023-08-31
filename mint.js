const { ethers } = require('ethers');

async function mintNFT() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);

  const contractAddress = CONTRACT_ADDRESS; // TODO get from .env
  const contractABI = [
    // Todo: get from .env
  ];

  const contract = new ethers.Contract(contractAddress, contractABI, provider);

  //  MetaMask for now.
  try {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  } catch (error) {
    console.error('User denied account access or MetaMask is not installed');
    return;
  }

  // TODO: flushout logic
  try {
    const quantityToMint = 1; // TODO: get from user input
    const tx = await contract.publicMint(quantityToMint, {
      value: ethers.utils.parseEther((0.0069 * quantityToMint).toString()), // Minting cost
    });

    // Wait for the transaction to be mined
    await tx.wait();

    console.log('NFT minted successfully');
  } catch (error) {
    console.error('Error minting NFT:', error);
  }
}

mintNFT();
