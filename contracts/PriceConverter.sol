// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // Add this line to import the interface

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // ABI
        //Address 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH in terms of USD
        //3000.00000000
        return uint256(answer * 100000000000); // 1*10**10
    }

    // function getVersion() internal view returns (uint256) {
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    //     );
    //     return priceFeed.version();
    // }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // 300_000000000000000000 = ETH / USD price
        // 100_000_000_000_000_000 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // 299.999999999999999999
        return ethAmountInUsd;
    }
}
