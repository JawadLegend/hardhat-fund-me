// SPDX-License-Identifier: MIT
//Pragma
pragma solidity ^0.8.7;
// imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

//Error codes
error FundMe__NotOwner();

// Interfaces, Libraries, Contracts
/**
 * @title A contract for crowd funding
 * @author Jawwad
 * @notice This contract is to demo a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
    // Type declarations
    using PriceConverter for uint256;
    // State variables
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    // Could we make this constant?
    address private immutable i_Owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18; // 1*10**18
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        // require(msg.sender == i_Owner),
        if (msg.sender != i_Owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address priceFeed) {
        i_Owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    fallback() external payable {
        fund();
    }

    // What happens if someone sends this contract ETH without calling the fund function
    receive() external payable {
        fund();
    }

    /**
     * @notice This function funds this contract
     * @dev This implements price feeds as our library
     */
    function fund() public payable {
        // Want to be able set a minimum fund amount in USD
        // 1. How we do send ETH to this contract
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to send more ETH"
        );
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
        //emit Funded(msg.sender, msg.value);
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_Owner.call{value: address(this).balance}("");
        require(success);
    }
    function cheaperWithdraw () public payable onlyOwner {
      address [] memory funders = s_funders;
      // mappings can't be in memory, sorry!
      for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        s_addressToAmountFunded[funder] = 0;
      } 
      s_funders = new address[](0);
      (bool success, ) = i_Owner.call{value: address(this).balance}("");
      require(success);
    }

    function getOwner() public view returns (address) {
        return i_Owner;
    }
    function getFunder(uint256 index) public view returns (address){
        return s_funders[index];
    }
    function getAddressToAmountFunded(address funder) public view returns (uint256){
       return s_addressToAmountFunded[funder];
    }
    function getPriceFeed() public view returns (AggregatorV3Interface){
        return s_priceFeed;
    }
}
