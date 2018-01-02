pragma solidity ^0.4.18; 

import "./SpaceBase.sol";
import "./SpaceAccessControl.sol";
import "./SpaceOwnership.sol";
import "./SpaceAuction.sol";

contract SpaceCreation is SpaceAuction{
	
	function createPromoPlanet(uint256 seed)
		external
		returns(uint256) {
			uint256 genome = uint256(keccak256(block.blockhash(block.number-1), seed));
			uint256 planet = _createPlanet(0, genome, msg.sender);
			return planet;
	}

	//function createGen0Auction(uint256 _genes) external onlyCOO {}
}