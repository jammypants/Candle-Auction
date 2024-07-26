// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CandleAuction {
    mapping(address => uint) public biddersData; // address of the bidder and their bid
    uint public highestbidamt;
    address public highestBidder;
    address payable public beneficiary;
    uint public auctionStartTime;
    uint public auctionEndTime;
    uint public auctionDuration;
    bool public ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(
        uint _auctionStartTime,
        uint _auctionDuration,  // Total auction duration
        address payable _beneficiary
    ) {
        beneficiary = _beneficiary;
        auctionStartTime = _auctionStartTime;
        auctionDuration = _auctionDuration;
    }
    
    function startAuction() public {
        require(block.timestamp >= auctionStartTime, "Auction has not started yet.");
        require(auctionEndTime == 0, "Auction has already started.");
        
        // Set auction end time to a random point within the duration using block.timestamp and block.difficulty
        uint randomness = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
        uint randomEndTime = auctionStartTime + (randomness % auctionDuration);
        if (randomEndTime < block.timestamp) {
            auctionEndTime = block.timestamp + 1; // End auction immediately if random end time is in the past
        } else {
            auctionEndTime = randomEndTime;
        }
    }
    
    // Placing bid function
    function putBid() public payable {
        require(block.timestamp <= auctionEndTime, "Auction has ended.");
        
        uint calc = biddersData[msg.sender] + msg.value;
        require(msg.value > 0, "Bid cannot be zero");
        require(calc > highestbidamt, "There already is a higher bid");

        biddersData[msg.sender] = calc;
        highestbidamt = calc;
        highestBidder = msg.sender;

        emit HighestBidIncreased(msg.sender, calc);
    }

    // Get contract balance (testing)
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // Getting bid of bidder
    function getBidderBid(address sender) public view returns(uint) {
        return biddersData[sender];
    }

    // Getting highest bid amount
    function highestBid() public view returns(uint) {
        return highestbidamt;
    }

    // Highest bid address
    function highestBidderAddress() public view returns(address) {
        return highestBidder;
    }

    // Ending the auction
    function auctionEnd() public {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");
        
        ended = true;
        emit AuctionEnded(highestBidder, highestbidamt);
        
        beneficiary.transfer(highestbidamt);
    }
}