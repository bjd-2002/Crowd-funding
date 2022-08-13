pragma soliditty ^0.6.12;

contract crowdfund{
    struct Campaign {
        uint value;
        uint32 _start;
        uint32 _end;
        address recipiant;
        bool completed;
    }
    address public admin;
    address payable [] public recipients;
    uint balance = 0;
    mapping(address=>uint) public contributions;
    
    event TransferReceived(address _from, uint _amount);
    constructor(address payable [] memory _addrs) {
        _start = now;
        admin = msg.sender;
        for(uint i=0; i<_addrs.length; i++){
            contributions[_addrs[i]]=msg.value;
            recipients.push(_addrs[i]);
            balance += msg.value;
        }
    }
    function end( uint duration ) public{
        _end = duration + _start;
    }
    function getRefund()public {
        require(_end < now);
        msg.sender.transfer(contributions[msg.sender]);
        contributions[msg.sender] = 0;      
    }
     modifier onlyAdmin {
        require(msg.sender == admin , " Not Admin ");
        _;
    }
    function collectFund(address payable _address) public onlyAdmin {
        _address.transfer(balance);
        emit TransferReceived(msg.sender, msg.value);
    }
}
