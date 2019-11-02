pragma solidity ^0.5.1;

contract automobileIndustry 
{
    
  
  address public regulatorAddress;
  
  uint public carId = 0;
    
  
  event ownerChanged(address _previousOwner, address _newOwner);
    
    
struct Car 
{
      
  uint id;
       
 address owner;
      
  string ownerType;
   
 }
    
 
   mapping (uint => Car) car;
   
 mapping (address => bool) isManufacture;
    
   
 modifier isRegulator() 
{
        
require(msg.sender==regulatorAddress);
      
  _;
}
    
   
 constructor () public 
{
       
 regulatorAddress = msg.sender;
    
}
    
  
 function addManufacture(address _newManufacture) public isRegulator()
 {
        
     
   isManufacture[_newManufacture] = true;
        
  
  }
    
   
 function registerVehicle() public isRegulator() 
 {
  
   carId++;
        
      
  car[carId].id = carId;
      
  car[carId].owner = msg.sender;
       
 car[carId].ownerType = "regulator";
        
   
 }
    
  
  function changeOwnershipToManufacturer(address _manufacturerAddress, uint _carId) public isRegulator() 
{
        
       
 require(isManufacture[_manufacturerAddress]==true);
        
       
 car[_carId].owner = _manufacturerAddress;
      
  car[_carId].ownerType = "manufacturer";
        
      
  emit ownerChanged(msg.sender,_manufacturerAddress);
  
  }
    
   
 function getCar(uint _carId) public view returns (address,string memory) 
{
        
      
  return (car[_carId].owner, car[_carId].ownerType);
    
}
    
   
 
}



