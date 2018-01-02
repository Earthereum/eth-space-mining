var Users = artifacts.require("./Users.sol");
var SpaceBase = artifacts.require("./SpaceBase.sol");
var SpaceAccessControl = artifacts.require("./SpaceAccessControl.sol");
var SpaceOwnership = artifacts.require("./SpaceOwnership.sol");
var SpaceCreation = artifacts.require("./SpaceCreation.sol");
var SpaceAuction = artifacts.require("./SpaceAuction.sol");

module.exports = function(deployer) {
  deployer.deploy(Users);
  deployer.deploy(SpaceBase);
  deployer.deploy(SpaceAccessControl);
  deployer.deploy(SpaceOwnership);
  deployer.deploy(SpaceCreation);
  deployer.deploy(SpaceAuction);
};

