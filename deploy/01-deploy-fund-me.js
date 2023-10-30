// import
//main function

// calling of the main function

// function deployFunc() {
//     console.log("Hi web3!")
// }

// module.exports.default = deployFunc
// module.exports = async (hre) => {
//     const { getNamedAccounts, deployments} = hre
//     // hre.getNamedAccounts
// hre.deployments
// }
// imports the current network from the hardhat library
// this contains info about the current network
// (e.g mainnet, testnet, or a local development network)
const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    // if chaidId is X use address Y
    // if chainId is Z use Address A

    //  const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]

    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    // if the contract doesn't exist, we deploy a minimal version of our local testing

    //well what happens when we want to change chains?
    // when going to localhost or hardhat network we want to use a mock
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args, // put price feed address
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        // VERIFY
        await verify(fundMe.address, args)
    }
    log("------------------------------------------------")
}
module.exports.tags = ["all", "fundme"]
