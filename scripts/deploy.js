const hre = require("hardhat");

async function main() {
  const Upload = await hre.ethers.getContractFactory("Upload");
  const upload = await Upload.deploy();

  await upload.waitForDeployment();

  console.log("Deployed to:", await upload.getAddress());
}

main().catch((error) => {
  console.error(error);
  console.log("Not able to deploy");
  process.exitCode = 1;
});
