const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const Carbon = await hre.ethers.getContractFactory("Carbon");

  // Deploy the contract
  const carbon = await Carbon.deploy();

  // Wait for the contract to be deployed
  await carbon.deployed();

  console.log(`Carbon contract deployed to: ${carbon.address}`);
}

// Run the script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
