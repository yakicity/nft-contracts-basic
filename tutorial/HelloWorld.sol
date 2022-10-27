pragma solidity 0.8.7;

contract HelloWorld{
    function hello(string memory message) public pure returns(string memory){
        return message;
    }
}

contract Contract1{
    int a = -5;
    uint b = 3;
    bool c = true;
    string d = "helllo";
    bytes32 e = "ETH";
    address f = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function add(uint x,uint y) public pure returns(uint){
        uint result;
        result = x + y;
        return result;
    }

    function addToB(uint x)public view returns(uint result){
        result = x + b;
    }

    function changeB(uint x) public returns(uint){
        b = x;
        return b;
    }
}

contract Array1{
    uint []  numbers = [1,2,3,4,5];

    function getNumbers() public view returns(uint[] memory){
        return numbers;
    }

    function getNumberLength() public view returns(uint){
        return numbers.length;
    }
    
    function addNumber(uint _number) public {
        numbers.push(_number);
        // numbers[5] = _number; //error
    }

    function popNumber() public {
        numbers.pop();
    }
}

contract Array2{
    uint [6] numbers = [1,2,3,4,5];

    function getNumbers() public view returns(uint[6] memory){
        return numbers;
    }

    function modifyNumber(uint _index, uint _number) public{
        numbers[_index] = _number;
    }

}

contract Mapping{
    mapping(address=>uint) balance;

    function addBalance(uint _toAdd) public returns(uint){
        balance[msg.sender] += _toAdd;
        return balance[msg.sender];
    }

    function getBalance(address _address) public view returns(uint){
        return balance[_address];
    }
}

contract Contract4 {
    struct Kitty{
        string name;
        address owner;
        uint256 id;
    }

    Kitty[] kitties;
    mapping(address=>uint256[]) ownerToKitty;

    function addKitty(string memory _name, address _owner) public {
        uint id = kitties.length;
        Kitty memory newKitty = Kitty(_name, _owner, id);
        kitties.push(newKitty);

        ownerToKitty[_owner].push(id);
    }

    function getKitty(address _owner) public view returns(string[] memory){
        uint numOfKitties = ownerToKitty[_owner].length;
        string[] memory names = new string[](numOfKitties); //string[7]とかはできるが、変数名の値分配列の大きさを決めて作るときはこのようにしないといけない

        for(uint i = 0;i<numOfKitties;i++){
            uint id = ownerToKitty[_owner][i];
            names[i] = (kitties[id].name); //memoryにpushはできない
        }
        return names;
    }
}

contract Contract5_1{
    uint public number = 123; //storage
    string public message = "hello"; //storage

    function setString(string memory input) public {
        // string,[],struct:complexdata -> memoryを書く
        string memory newMessage = input; //mmeory
        message = newMessage;
    }

    function setNumber(uint input) public{
        uint newNumber = input; //memory
        number = newNumber;
    }
}

contract Contract5_2{
    struct Kitty{
        string name;
        address owner;
    }

    Kitty[] public kitties;
    
    function newKitty(string memory _name) public {
        Kitty memory kitty = Kitty(_name,msg.sender);
        kitties.push(kitty);
    }
    
    function sGetKitty(uint _id) public returns(string memory){
        Kitty storage kitty = kitties[_id];//すでにあるkitties[_id]へのポインタという意味、あたらしくは作成していない
        return kitty.name;
    }

    function mGetKitty(uint _id) public returns(string memory){
        Kitty memory kitty = kitties[_id];//この関数内であたらしいKittyを作成
        return kitty.name;
    }

    function sChangeKitty(uint _id,string memory _name) public{
        Kitty storage kitty = kitties[_id];
        kitty.name = _name;
    }
}

contract SimpleBank {
    function deposit() public payable{}

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}


import "./Ownable.sol";

contract Bank is Ownable{ //ownableは親、bankは子、子は親の機能をすべて引き継ぐ
    event balanceUpdate(string indexed _txType, address indexed _owner, uint _amount);


    mapping (address => uint) balance;


    modifier balanceCheck(uint _amount){
        require(balance[msg.sender] >= _amount, "Insufficient balance");
        _;
    }


    function getBarance() public view returns(uint){
        return balance[msg.sender];
    }

    function deposit() public payable onlyOwner{
        balance[msg.sender] += msg.value;
        emit balanceUpdate("Deposit", msg.sender, balance[msg.sender]);
    }

    function withdraw(uint _amount) public balanceCheck(_amount){
        uint beforeWithdraw = balance[msg.sender];
        balance[msg.sender] -= _amount;

        // payable(msg.sender).transfer(_amount);
        
        (bool success, bytes memory data) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer unsuccessuful");
        
        uint afterWithdraw = balance[msg.sender];
        assert(afterWithdraw == beforeWithdraw - _amount);
        emit balanceUpdate("Withdraw", msg.sender, balance[msg.sender]);
    }

    function transfer(address _to, uint _amount) public balanceCheck(_amount){
        require(msg.sender != _to, "Invalid resipient");
        _transfer(msg.sender, _to, _amount);
        emit balanceUpdate("Outgoing Transfer", msg.sender, balance[msg.sender]);
        emit balanceUpdate("Incoming Transfer", _to, balance[_to]);
    }

    function _transfer(address _from, address _to, uint _amount) private {
        balance[_from] -= _amount;
        balance[_to] += _amount;
    }
}

contract A {
    string public msgA ="hello";

    constructor(string memory _msg){
        msgA = _msg;
    }
    
    function print() public virtual view returns(string memory){
        return msgA;
    }

    function helloA() public pure returns(string memory){
        return "helloA";
    }

}
contract B{
    string public msgB ="HELLO";

    constructor(string memory _msg){
        msgB = _msg;
    }

    function print() public  virtual view returns(string memory){
        return msgB;
    }

    function helloB() public pure returns(string memory){
        return "helloB";
    }
}
contract C is A,B{

    constructor(string memory _msg) A(_msg) B("message B"){

    }

    function print() public  override(A,B) view returns(string memory){
        return A.print();
        // return super.print();
    }

    function changemsgB(string memory _msg) public {
        msgB = _msg;
    }
}

