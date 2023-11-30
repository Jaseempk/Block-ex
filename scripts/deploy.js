const hre = require("hardhat");

async function sleep(ms) {
    await new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {

    
    
    /**
     const fakeNFTMarket = await hre.ethers.deployContract("FakeNFTMarketPlace");
     await fakeNFTMarket.waitForDeployment(5);
     console.log("FakeNFTMarketPlace deployed at:", fakeNFTMarket.target);
     const blockEx = await hre.ethers.deployContract("BlockEx", ["0x0891e317Bb3A0ac2c17C6AF3b488cE6CEB163e53"]);
     await blockEx.waitForDeployment();
     console.log("Block-Ex deployed at:", blockEx.target);
     
     */
    
    // verifying contracts
    
    console.log("waiting for Block-ex...")
    await hre.run("verify:verify", {
        address: "0x262Aeadc9C67D0b17cdd63a9a76a6d892174bA35",
        constructorArguments: ["0x0891e317Bb3A0ac2c17C6AF3b488cE6CEB163e53"],
    });
    console.log("Block-ex done...");
    
    
    /**
     await hre.run("verify:verify", {
         address: "0x0891e317Bb3A0ac2c17C6AF3b488cE6CEB163e53",
         constructorArguments: [],
        });
 
     console.log("waiting for MKPLC...")
 
     await sleep(7000);
 
     */
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});
