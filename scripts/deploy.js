const hre = require("hardhat");

async function sleep(ms) {
    await new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {

    /**
     const fakeNFTMarket = await hre.ethers.deployContract("FakeNFTMarketPlace");
     await fakeNFTMarket.waitForDeployment(5);
     console.log("FakeNFTMarketPlace deployed at:", fakeNFTMarket.target);
     
     const blockEx = await hre.ethers.deployContract("BlockEx", fakeNFTMarket.target);
     await blockEx.waitForDeployment();
     console.log("Block-Ex deployed at:", blockEx.target);
    
    
    */
    
    // verifying contracts


    await sleep(7000);

    console.log("waiting for Block-ex...")
    await hre.run("verify:verify", {
        address: "0x992b155b9390Eb60c8A1beA42BFE6982F32D7057",
        constructorArguments: ["0xeB3C515C94b285578F3D33AA98a8c592D4b323e0","0xeB3C515C94b285578F3D33AA98a8c592D4b323e0"],
    });
    console.log("Block-ex done...");
    /**
     await hre.run("verify:verify", {
         address: "0xf675314Fd2df3240db0651b4dc67d7ED81981cB4",
         constructorArguments: [],
     });
 
     console.log("waiting for MKPLC...")
 
     await sleep(7000);
 
     console.log("waiting for Block-ex...")
     await hre.run("verify:verify", {
         address: "0x043d01362ECB86aF9BED3dDC64453393B404eE8B",
         constructorArguments: ["0xf675314Fd2df3240db0651b4dc67d7ED81981cB4"],
     });
     console.log("Block-ex done...");
     */
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});
