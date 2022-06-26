//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;	// Solidity version

// We import this library to be able to use console.log
import "hardhat/console.sol";

// This is the main building block for smart contracts.
contract Token {
    //function taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol#L15-L35
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    uint productNumber;
    bool issold; 
    address brandAddress;
    address public owner;
    address warrantyStaffAddress;
    uint productCreatedTimestamp;
    uint productSoldTimestamp;
    uint warrantyStartedTimestamp;
    uint ownerNumber;
    uint warrantyTimeBlock;

    uint256 public totalSupply = 1000000;
    mapping(address => uint256) balances;

    constructor() {
        productNumber = 0;
        issold = false;
        brandAddress = 0xD0CD01862660fB5167a73B708B3d46388DD501aC;
        owner = 0xD0CD01862660fB5167a73B708B3d46388DD501aC;
        warrantyStaffAddress = 0x4049C0E8a3b783ee0e4De6B842aA25716B66BFC9;
        productCreatedTimestamp = 0;
        productSoldTimestamp = 0;
        warrantyStartedTimestamp = 0;
        ownerNumber = 0;
        warrantyTimeBlock = 63113852;

        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // We can print messages and values using console.log
        console.log(
            "Transferring from %s to %s %s tokens",
            msg.sender,
            to,
            amount
        );

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    // new start
     modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier isBrand(){
        require(msg.sender == brandAddress, "Caller is not brand");
        _;
    }

    modifier isWarrantyStaff(){
        require(msg.sender == warrantyStaffAddress, "Caller is not Warranty Staff");
        _;
    }

    function createProduct () external isBrand {
        
        productCreatedTimestamp = block.timestamp;
        productNumber = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender)));
        issold = false;
        productSoldTimestamp = 0;
        warrantyStartedTimestamp = 0;
    }

    function sellProduct (address newOwner) public isBrand  {

        if(issold == false && productCreatedTimestamp > 0){
            owner = newOwner;
            issold = true;
            productSoldTimestamp = block.timestamp;
            if(ownerNumber == 0)
            {
                warrantyStartedTimestamp = productSoldTimestamp;
                ownerNumber += 1;
            }
        }
    }

    function changeOwner(address newOwner) public isOwner {
       
        owner = newOwner;
        productSoldTimestamp = block.timestamp;
        
        if(issold == true){
            ownerNumber += 1;
        }
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function setWarrantyStartTime () isWarrantyStaff public {
        if(issold == true)
        {
            warrantyStartedTimestamp = block.timestamp;
        }
    }

    function getWarrantyStartTime () public view returns (string memory) {
        return toString(warrantyStartedTimestamp);
    }


    function getProductCreationTime () public view returns (uint){

       return productCreatedTimestamp; 
    }

    function getProductNumber () public view returns (string memory){

       return toString(productNumber);
    }
    
    function setBrandAddress (address brand) public isBrand{
        brandAddress = brand;
    }

    function retrieveBrand() public view returns (address nameofBrand){
        nameofBrand = brandAddress;
        return nameofBrand;
    }

    function getOwnerCount() public view returns (string memory){
        return toString(ownerNumber);
    }

    function getProductStatus() public view returns (bool){
        return issold;
    }

    function getProductInformation () view public returns (address, uint, uint, uint, uint){

        return (owner, productCreatedTimestamp, productSoldTimestamp, warrantyStartedTimestamp, ownerNumber);

    }

    function getProductSoldTime () view public returns (uint){

        return productSoldTimestamp;
    }

    function checkWarrantyApplicable() public view isWarrantyStaff returns (string memory){

        uint timeNow = block.timestamp - warrantyStartedTimestamp;

        if(timeNow < warrantyTimeBlock)
        {
            return "Applicable";
        }
        else
        {
            return "Expired";
        }
    }

    function enlargeWarranty(uint newTime) public isWarrantyStaff {
    
        if(bytes(checkWarrantyApplicable()).length == bytes("Applicable").length){
            warrantyTimeBlock += newTime;
        }
        else
        {
            warrantyStartedTimestamp = block.timestamp;
            warrantyTimeBlock = newTime;
        }
    }

    function getWarrantyTimePeriod() view public returns (string memory){
        return toString(warrantyTimeBlock);
    }

    // new end 
}
