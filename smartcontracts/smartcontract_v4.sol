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
    mapping (address => uint) public loyaltypoints;
    
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
    
    modifier onlyCarOwner(uint _carId,address callerAddress) {
        require(car[_carId].owner==callerAddress);
        _;
    }
    
    constructor () public {
        
        regulatorAddress = msg.sender;
        //comment this after
        isManufacture[0x8ca7427653Bd24EE2a6291f4Ba7c452ad36Bf13d] = true;
        isDealer[0x68C32f203D8EDfE4a4A85EEEBeEC548fd68F8cF8] = true;
        isLeasingAgent[0x76E3ABF064a2F68b9aCcb60f1b9dA9d095B266CE] = true;
        
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
    
    function manufactureUpdateMakeandModel(uint _carId,string memory _make,string memory _model) public onlyManufacture() {
        
          car[_carId].make = _make;
          car[_carId].model = _model;
          car[_carId].ownerType = "dealer";
        
    }
    
    function issueVehicleTemplateByDealer(uint _carId) public {
        vehicleTemplates.push(_carId);
        car[_carId].ownerType = "dealerReady";
    }
    
    function getVehicleTemplatesArray() public view returns(uint[] memory) {
        return vehicleTemplates;
    }
    
    function transferVehicleToLeasing(uint _carId) public onlyLeasingAgent() {
        
         car[_carId].ownerType = "leasingAgent";
         loyaltypoints[msg.sender] = loyaltypoints[msg.sender] + 10;
        
    }
    
    function buyCar(uint _carId,address _buyer) public {
        car[_carId].ownerType = "user";
        car[_carId].owner = _buyer;
        
    }
    
    function scrapCar(uint _carId,address _callerAddress) public onlyCarOwner(_carId,_callerAddress) {
        car[_carId].ownerType = "scrapper";
        car[_carId].owner = 0x07C7da9934D3492394975ff37a9d558413844B3C;
    }

  
}



