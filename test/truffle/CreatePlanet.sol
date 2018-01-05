pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/SpaceBase.sol";
import "../../contracts/SpaceCreation.sol";
import "../../contracts/SpaceCore.sol";
import "../../contracts/SpaceOwnership.sol";

contract CreatePlanet {

  function testPlanet() public {
  	SpaceCore core = SpaceCore(DeployedAddresses.SpaceCore());
  	SpaceCreation creation = SpaceCreation(DeployedAddresses.SpaceCreation());
  	SpaceOwnership ownership = SpaceOwnership(DeployedAddresses.SpaceOwnership());

  	uint256 seed = 0x12345;
  	uint256 planet = creation.createPromoPlanet(seed);

  	uint256 genes1;
  	uint256 genes2;
  	
  	//(,genes1) = core.getPlanet(1);
  	var (a,b,c,d,e,f) = core.getPlanet(1);
  	genes1 = f;
  	(a,b,c,d,e,f) = core.getPlanet(planet);
  	genes2 = f;

  	Assert.equal(genes1, genes2, "Genes should stay the same");
  }

}
