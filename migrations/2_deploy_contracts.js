var contracts = [
  artifacts.require("SpaceBase"),
  artifacts.require("SpaceAccessControl"),
  artifacts.require("SpaceCreation"),
  artifacts.require("Pausable"),
  artifacts.require("Ownable"),
  artifacts.require("SpaceAuction"),
  artifacts.require("ClockAuctionBase"),
  artifacts.require("ClockAuction"),
  artifacts.require("SpaceOwnership")
];

var SpaceCore = artifacts.require("SpaceCore");
var SaleClockAuction = artifacts.require("SaleClockAuction");

module.exports = function(deployer) {
  deployer.deploy(contracts);

  deployer.deploy(SpaceCore);
  deployer.deploy(SaleClockAuction);

  var coreInstance;
  deployer.then(() => SpaceCore.deployed())
  .then(instance => coreInstance = instance)
  .then(() => {
    coreInstance.setSaleAuctionAddress(SaleClockAuction.address);
    console.log('Expected SaleClockAuction Address: ' + SaleClockAuction.address);
    coreInstance.saleAuction.call().then(val => console.log('Actual: ' + val));
  })
  .catch(err => console.error(err));
};
