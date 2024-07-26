Candle Auction Simulation using smart contract in Solidity

The randomness in the auction end time is introduced using the block timestamp and block difficulty at the time of starting the auction. 
1. **Start Auction**:
    - The auction can only be started after the specified start time.
    - The auction end time is set to a random point within the duration using a combination of `block.timestamp` and `block.difficulty`.

2. **Generate Random End Time**:
    - A random value is generated using the hash of the current block’s timestamp and difficulty.
    - The random end time is then calculated as:
     uint randomness = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
      Generates a pseudorandom number using the current block timestamp and difficulty.
      uint randomEndTime = auctionStartTime + (randomness % auctionDuration);
Calculates the auction end time by adding a random value (within the auction duration) to the auction start time.
    - If the calculated random end time is already in the past, the auction is set to end immediately.
    - Otherwise it is set to the calculated endtime
   
   

