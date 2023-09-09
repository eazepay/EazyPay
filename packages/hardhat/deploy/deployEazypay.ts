import { ethers } from "hardhat";
import { EazePay } from "../typechain-types";

async function main() {
  // Deploy the contract
  const EazePayFactory = await ethers.getContractFactory("EazePay");
  const eazePay: EazePay = await EazePayFactory.deploy(
    "EazeToken", // desired token name
    "EZT" // desired token symbol
  ) as EazePay;

  await eazePay.deployed();

  console.log("EazePay contract deployed to:", eazePay.address);

  console.log("Sleeping.....");
  // Wait for polygon to notice that the contract has been deployed
  await sleep(50000);

  // Verify the contract on polygon after deploying
 
  // await hre.run("verify:verify", {
  //   address: eazePay.address,
  //   constructorArguments: [
  //     "EazeToken", // desired token name
  //     "EZT", // desired token symbol
  //   ],
  // });

  console.log("done");
}

// Run the deployment function
main()
  // .then(() => run("etherscan-verify", { network: "goerli" }))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}