// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract First_Homework {   
    
    address owner;

    struct Counter {
        uint number;
        string description;
    }

    Counter counter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can increment or decrement the counter");
        _;
    }

    constructor(uint initial_value, string memory description) {
        owner = msg.sender;
        counter = Counter(initial_value, description);
    }


    // This function gets the number field from the counter struct and increases it by one.
    function increment_counter() external onlyOwner {
        counter.number += 1;
    }


    // This function is similar the one above, but instead of increasing we deacrease the number by one.
    function decrement_counter() external onlyOwner {
        counter.number -= 1;
    }

    function get_counter_value() external view returns(uint) {
        return counter.number;
    }

    function get_counter_description() external view returns(string memory){
        return counter.description;
    }
}
