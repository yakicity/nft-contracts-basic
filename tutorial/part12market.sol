pragma solidity 0.8.7;

import "./Ownable.sol";
interface IBank{
    function transferFrom(address _from, address _to, uint _amount) external;
    function getBalance() external view returns(uint);
    function withdraw(uint _amount) external;
}


contract NFTMarket is Ownable{
    struct Kitty{
        uint256 id;
        string name;
        address owner;
    }

    Kitty[] kitties;
    mapping(address => uint256[]) ownedKitties;
    uint private price = 1000000000000000000; //1ETH
    address private bankAddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    IBank bank = IBank(bankAddr);

    function createKitty(string memory _name) external onlyOwner {
        Kitty memory newKitty = Kitty(kitties.length, _name, address(0));
        kitties.push(newKitty);
    }

    function getOwner() view external returns(address){
        return owner;
    }

    function viewKitty() view external returns(Kitty[] memory){
        return kitties;
    }

    function buyKitty(uint256 _id) external {
        require(kitties[_id].owner == address(0), "Kitty not for sale");
        ownedKitties[msg.sender].push(_id);
        kitties[_id].owner = msg.sender;
        IBank(bankAddr).transferFrom(msg.sender, address(this),price);
    }

    function withdrawFromBank() external onlyOwner {
        uint balance = bank.getBalance();
        bank.withdraw(balance);
    }

    function transferToOwner() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance() view external onlyOwner returns(uint){
        return address(this).balance;
    }
    receive() external payable {

    }

}