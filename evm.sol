pragma solidity ^0.4.21;

contract SolidityVM {
	/*
	* @dev This function should fetch next instruction
	*/
	function fetch() public returns (uint) {
	}

	/*
	* @dev This function should decode instruction and set registers/stack accordingly
	*/
	function decode(uint instruction) public returns (bool) {
	}

	/*
	* @dev Evaluate the last decoded instruction
	*/
	function eval() public returns (bool) {
	}

	function run() public returns (bool) {
		var instruction = fetch();
		decode(instruction);
		eval();
	}

	function SolidityVM() public {
	}
}
