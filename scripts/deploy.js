const hre = require("hardhat");

async function sleep(ms) {
    await new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
    const fakeNFTMarket = await hre.ethers.deployContract("FakeNFTMarketPlace");
    await fakeNFTMarket.deployed();
    console.log("FakeNFTMarketPlace deployed at:", fakeNFTMarket.address);

    const blockEx = await hre.ethers.deployContract("BlockEx", [fakeNFTMarket.address]);
    await blockEx.deployed();
    console.log("Block-Ex deployed at:", blockEx.address);

    await sleep(5000);

    // verifying contracts
    await hre.run("verify:verify", {
        address: fakeNFTMarket.address,
        constructorArguments: [],
    });

    await hre.run("verify:verify", {
        address: blockEx.address,
        constructorArguments: [fakeNFTMarket.address],
    });
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});
