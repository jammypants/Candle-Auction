async function main() {
    const hre = require("hardhat");
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const Auction = await hre.ethers.getContractFactory("CandleAuction");
    console.log("Contract factory created.");

    try {
        const auction = await Auction.deploy(
            Math.floor(Date.now() / 1000),  // Start time
            3600,  // Duration in seconds
            deployer.address  // Beneficiary
        );
        console.log("Deploy transaction sent.");

        await auction.waitForDeployment();
        console.log("Auction deployed to:", auction.target);
    } catch (error) {
        console.error("Error during deployment:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
