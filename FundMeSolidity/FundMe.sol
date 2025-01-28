
// get funds from user
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


error NotOwner();

contract FundMe{

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18; 
    //constant keyword saves the data directly into bytecode therefore costs less gas
    
    
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    //immutable keyword saves the data directly into bytecode therefore costs less gas

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable  {
        //Alllow users to send money
        // have a minimum money sent
        // 1).How do we send ETH to this contarct? 
        require(msg.value.getConversionRate() >= MINIMUM_USD,"Didnt; sne enough ETH");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        
        //What is a revert?
        // --> Undo any actions that have been done, and send the remaining gas back

    }

    modifier onlyOwner(){
        //   require(msg.sender == i_owner,"Sender is not Owner!");
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }


    function withdraw() public onlyOwner{

        for(uint256 funderIndex; funderIndex < funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        }
        //reset the index
        funders = new address[](0);

        // actually withdraw the funds
        
        // //transfer
        // payable(msg.sender).transfer(address (this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send Failed");

        //call --> Recommended
        (bool callSuccess,)= payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call Failed");
    }   

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }  
 }