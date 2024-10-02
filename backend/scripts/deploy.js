async function main() {
  const CarbonCredits = await ethers.getContractFactory("CarbonCredits");
  const carbonCredits = await CarbonCredits.deploy();
  await carbonCredits.deployed();
  console.log("CarbonCredits deployed to:", carbonCredits.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
