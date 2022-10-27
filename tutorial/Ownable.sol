pragma solidity 0.8.7;

contract Ownable{
    address internal owner;

    modifier onlyOwner {
        require(msg.sender == owner, "you are not the owner");
        _;
    }

    constructor(){
        owner = msg.sender;
    }    
}