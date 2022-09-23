pragma solidity >=0.4.22 <0.9.0;

contract UserMgmt{
    struct User{
        string userName;
        string email;
        string password;
        uint age;
        bool alreadyUser;
    }

    mapping(address=>User) private addressToUserDetails;
    mapping(string=>address) private emailVerify;
    mapping(string=>address) private userNameVerify;

    modifier notRegistered(){
        require(addressToUserDetails[msg.sender].alreadyUser==false,"already registered");
        _;
    }
    modifier emailNotUsed(string memory _email){
        require(emailVerify[_email] == address(0x00),"email already used");
        _;
    }
    modifier userNameNotUsed(string memory _name){
        require(userNameVerify[_name] == address(0x00),"user name already used");
        _;
    }

    function _newUser(string memory _name,string memory _email,string memory _password,uint _age) public notRegistered emailNotUsed(_email) userNameNotUsed(_name) returns(bool){
        addressToUserDetails[msg.sender]=User(_name,_email,_password,_age,true);
        return true;
    }

    function _login(string memory _email,string memory _pass)public view returns(bool){
        if((keccak256(abi.encodePacked(addressToUserDetails[msg.sender].email))==keccak256(abi.encodePacked(_email))) && 
            (keccak256(abi.encodePacked(addressToUserDetails[msg.sender].password))==keccak256(abi.encodePacked(_pass)))){
                return true;
        }
        return false;
    }
    function getDetails() public view returns(string memory user_name,
        string memory email,
        string memory password,
        uint age){
        return (addressToUserDetails[msg.sender].userName,
        addressToUserDetails[msg.sender].email,
        addressToUserDetails[msg.sender].password,
        addressToUserDetails[msg.sender].age);
    }
}