
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: 'https://sepolia.infura.io/v3/52e2e137806847598483bd7a78a2a0dd',  // Use your Infura Project ID
      accounts: ["0xaee59c95b2c841352044e7ea7abb01a309e7e674c022292b528fdfce6f12afd3"], 
       // We'll get to the private key below
    },
    // mainnet: {
    //   url: 'https://polygon-rpc.com/',
    //   accounts: [`0x${YOUR_PRIVATE_KEY}`],  // Replace with your private key
    // },
  },
};

