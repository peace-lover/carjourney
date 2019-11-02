import Web3 from "web3";
import autoMobileArtifact from "../../build/contracts/automobileIndustry.json";

const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = autoMobileArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        autoMobileArtifact.abi,
        deployedNetwork.address,
      );

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

      this.refreshTable();
    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

  refreshTable: async function() {

    const { getLatestCarRegisteredNumber } = this.meta.methods;
    const totalCars = await getLatestCarRegisteredNumber().call();

      if (totalCars>0){

        
        $("#carsTable > tr").remove();
      var i;

      for (i=1; i<=totalCars; i++ ) {

       

        console.log(i);

        const { getCar } = this.meta.methods;
        const carDetails = await getCar(i).call();
        console.log(carDetails);
        let presentOwner = carDetails[1];
        let carmodel = carDetails[3] ? carDetails[3] : "N/A";
        let carmake = carDetails[2] ? carDetails[2] : "N/A";

        let owner;

        let carStage;

        if(presentOwner=="manufacturer") {
          carStage = "Building Car"; 
          owner = "Manufacturer";        
        } else if (presentOwner=="dealer") {
          carStage = "Building Car Completed";
          owner = "Dealer";
          $('#dealerCarTable > tbody:first').append(`<tr><th scope="row">${i}</th><td>${owner}</td><td>${carStage}</td><td>${carmodel}</td><td>${carmake}</td></tr>`);
        } else if (presentOwner=="dealerReady") {
          carStage = "Available For Leasing";
          owner = "Dealer";
          $('#dealerCarTable > tbody:first').append(`<tr><th scope="row">${i}</th><td>${owner}</td><td>${carStage}</td><td>${carmodel}</td><td>${carmake}</td></tr>`);
          $('#leasingTable > tbody:first').append(`<tr><th scope="row">${i}</th><td>${owner}</td><td>${carStage}</td><td>${carmodel}</td><td>${carmake}</td></tr>`);
          
        } else if (presentOwner=="leasingAgent"){
          carStage = "Under Lease";
          owner = "Leasing Agent";
        }

        $('#carsTable > tbody:first').append(`<tr><th scope="row">${i}</th><td>${owner}</td><td>${carStage}</td><td>${carmodel}</td><td>${carmake}</td></tr>`); 
       
      }

    } else {
      console.log("no cars created yet");
    }
  },

  addManufacturer: async function() {

    const manufacturAddr = document.getElementById("manufacturerAddress").value;
  
    this.setStatus("Initiating transaction... (please wait)");

    const { addManufacture } = this.meta.methods;
    await addManufacture(manufacturAddr).send({ from: this.account });

    this.setStatus("Transaction complete!");
    

  },

  addDealer : async function() {

    const dealerAddr = document.getElementById("dealerAddress").value;
  
    this.setStatus("Initiating transaction... (please wait)");

    const { addDealer } = this.meta.methods;
    await addDealer(dealerAddr).send({ from: this.account });

    this.setStatus("Transaction complete!");

  },

  addLeasingAgent : async function() {

    const leasingAgentAddr = document.getElementById("leasingAgentAddress").value;
  
    this.setStatus("Initiating transaction... (please wait)");

    const { addLeasingAgent } = this.meta.methods;
    await addLeasingAgent(leasingAgentAddr).send({ from: this.account });

    this.setStatus("Transaction complete!");

  },

  authorizeManufacturer : async function () {

    const authorizingManufacturerAddr = document.getElementById("authoizingManufacturersAddress").value;
  
    this.setStatus("Initiating transaction... (please wait)");

    const { registerVehicle } = this.meta.methods;
    await registerVehicle(authorizingManufacturerAddr).send({ from: this.account });

    this.setStatus("Transaction complete!");
    location.reload();
    this.refreshTable();

  },

  updateCarMakeAndModel : async function () {
    
    const carId = document.getElementById("manufacturerCarId").value;
    const carmodel = document.getElementById("model").value;
    const carmake = document.getElementById("make").value;

    this.setStatus("Initiating transaction... (please wait)");

    const { manufactureUpdateMakeandModel } = this.meta.methods;
    await manufactureUpdateMakeandModel(carId,carmake,carmodel).send({ from: this.account });

    this.setStatus("Transaction complete!");


  },

  updateVehicleForLeasing : async function() {

    const carId = document.getElementById("dealerCarId").value;

    this.setStatus("Initiating transaction... (please wait)");

    const { issueVehicleTemplateByDealer } = this.meta.methods;
    await issueVehicleTemplateByDealer(carId).send({ from: this.account });

    this.setStatus("Transaction complete!");


  },

  takeCarForLeasing : async function() {

    const leasingAgentCarId = document.getElementById("leasingCarId").value;
  
    this.setStatus("Initiating transaction... (please wait)");

    const { transferVehicleToLeasing } = this.meta.methods;
    await transferVehicleToLeasing(leasingAgentCarId).send({ from: this.account });

    this.setStatus("Transaction complete!");

    location.reload();


  },

  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);`  `
    window.ethereum.enable(); // get permission to access accounts
    window.ethereum.on('accountsChanged', function (accounts) {
      location.reload(); 
    })
    window.ethereum.on('networkChanged', function (accounts) {
      location.reload(); 
    })
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
    );
  }

  App.start();
});
