pragma solidity ^0.5.1;

contract automobileIndustry {
    
  
  address public regulatorAddress;
  
  uint public carId = 0;
  uint[] vehicleTemplates;
    
  
  event ownerChanged(address _previousOwner, address _newOwner);
    
    
  struct Car {
      uint id;
      address owner;
      string ownerType;
      string make;
      string model;
    }
    
    mapping (uint => Car) car;
    mapping (address => bool) isManufacture;
    mapping (address => bool) isDealer;
    mapping (address => bool) isLeasingAgent;
    
    modifier isRegulator() {
        require(msg.sender==regulatorAddress);
        _;
    }
    
    modifier onlyManufacture() {
        require(isManufacture[msg.sender]==true);
        _;
    }
    
    modifier onlyDealer() {
        require(isDealer[msg.sender]==true);
        _;
    }
    
     modifier onlyLeasingAgent() {
        require(isLeasingAgent[msg.sender]==true);
        _;
    }
    
    constructor () public {
        
        regulatorAddress = msg.sender;
        
    }
    
    function addManufacture(address _newManufacture) public isRegulator() {
        
        isManufacture[_newManufacture] = true;
    }
    
    function addDealer(address _newDealer) public isRegulator() {
        
        isDealer[_newDealer] = true;
    }
    
    function addLeasingAgent(address _newLeasingAgent) public isRegulator() {
        
        isLeasingAgent[_newLeasingAgent] = true;
    }
    
    function registerVehicle(address _manufacturerAddress) public isRegulator() {
        
        carId++;
        car[carId].id = carId;
        car[carId].ownerType = "manufacturer";
        car[carId].owner = _manufacturerAddress;
        
         emit ownerChanged(msg.sender,_manufacturerAddress);
    }
    
 
   function getCar(uint _carId) public view returns (address,string memory, string memory, string memory) {
         
        return (car[_carId].owner, car[_carId].ownerType, car[_carId].make, car[_carId].model);
         
    }
    
    function getLatestCarRegisteredNumber() public view returns(uint) {
        return carId;
    }
    
    function manufactureUpdateMakeandModel(string memory _make,string memory _model) public onlyManufacture() {
        
          car[carId].make = _make;
          car[carId].model = _model;
          car[carId].ownerType = "dealer";
        
    }
    
    function issueVehicleTemplateByDealer() public {
        vehicleTemplates.push(carId);
    }
    
    function getVehicleTemplatesArray() public view returns(uint[] memory) {
        return vehicleTemplates;
    }
    
    function transferVehicleToLeasing(uint _carId) public onlyLeasingAgent() {
        
         car[_carId].ownerType = "leasingAgent";
        
    }
 
    
    
  
}



