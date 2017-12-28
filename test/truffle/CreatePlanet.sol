pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/SpaceBase.sol";
import "../../contracts/SpaceCreation.sol";

contract CreatePlanet {

  function testPlanet() public {
  	uint256 seed = 0x12345;
  	uint256 planet = createPlanet(seed);
  	getPlanetGenomeByIndex(planet);
  }

}
