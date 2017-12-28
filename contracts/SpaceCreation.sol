pragma solidity ^0.4.18; 

import "./SpaceBase.sol";
import "./SpaceAccessControl.sol";
import "./SpaceOwnership.sol";

contract SpaceCreation is SpaceOwnership{
	
	function createPlanet(uint256 seed)
		external
		whenNotPaused
		returns(uint256) {
			uint256 genome = uint256(keccak256(block.blockhash(block.number-1), seed));
			uint256 planet = _createPlanet(0, genome, msg.sender);
			return planet;
	}

	function getPlanetGenomeByIndex(uint8 index)
		external
		whenNotPaused
		view
		returns(uint256) {

			return planets[index].genes;

	}
}