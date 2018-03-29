pragma solidity ^0.4.21;

contract SolidityVM {

	struct OpCode {
		uint gasCost;
		uint stackSize;
		uint flags;
	}

	function nextCounter(uint inst) public pure returns (uint) {
		return 1;
	}
	/*
	* @dev Nonce increment function
	* Rationale: nonce should be the Program Counter
	*/
	function NextNonce(bytes state, uint pc) public returns (uint) {
		var inst = fetch(state, pc);
		var instLen = nextCounter(inst);
		return pc + instLen;
	}

	/*
	* @dev This function should fetch next instruction
	*/
	function fetch(bytes state, uint pc) public returns (uint) {
		return 0; //TODO
	}

	/*
	* @dev This function should decode instruction and set registers/stack accordingly
	*/
	function decode(bytes state, bytes stack, uint instruction) public returns (bytes) {
		
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
