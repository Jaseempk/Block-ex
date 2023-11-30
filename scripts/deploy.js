const hre = require("hardhat");

async function sleep(ms) {
    await new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {

    
    
    /**
     const fakeNFTMarket = await hre.ethers.deployContract("FakeNFTMarketPlace");
     await fakeNFTMarket.waitForDeployment(5);
     console.log("FakeNFTMarketPlace deployed at:", fakeNFTMarket.target);
     
     const blockEx = await hre.ethers.deployContract("BlockEx", [fakeNFTMarket.target]);
     await blockEx.waitForDeployment();
     console.log("Block-Ex deployed at:", blockEx.target);
     */
    
    // verifying contracts

    await hre.run("verify:verify", {
        address: "0x66BDc136Ce8EC63973c2A18F8FA2cb402729F4c2",
        constructorArguments: [],
    });

    console.log("waiting for MKPLC...")

    await sleep(7000);

    console.log("waiting for Block-ex...")
    await hre.run("verify:verify", {
        address: "0xf3dB20106AC59444c2C73cc7d7717972FB220E78",
        constructorArguments: ["0x66BDc136Ce8EC63973c2A18F8FA2cb402729F4c2"],
    });
    console.log("Block-ex done...");

 
    /**
     */
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});
