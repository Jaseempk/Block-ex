const hre=require("hardhat");

async function sleep(ms){
    await new Promise((resolve)=>(resolve,ms))
}


async function main(){

    const fakeNFTMarket=await hre.ethers.deployContract("FakeNFTMarketPlace");
    await fakeNFTMarket.waitForDeployment();
    console.log("FakeNFTMarketPlace deployed at:",fakeNFTMarket.target)

    const blockEx=await hre.ethers.deployContract("BlockEx",[fakeNFTMarket.target]);
    await blockEx.waitForDeployment()
    console.log("Block-Ex deployed at:",blockEx.target)

    await sleep(5000)

    //verifying contracts
    await hre.run("verify:verify",{
        address:fakeNFTMarket.target,
        constructorArguments:[]
    })

    await hre.run("verify:verify",{
        address:blockEx.target,
        constructorArguments:[fakeNFTMarket.target]
    })
}
main().catch((e)=>{
    console.error(e);
    process.exit=1;
  })