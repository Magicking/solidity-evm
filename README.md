# Solidity EVM

[![CircleCI](https://circleci.com/gh/Magicking/solidity-evm/tree/master.svg?style=shield)](https://circleci.com/gh/Magicking/solidity-evm/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/Magicking/solidity-evm/badge.svg?branch=master)](https://coveralls.io/github/Magicking/solidity-evm?branch=master)

Solidity EVM is a restricted Ethereum Virtual Machine interpreter, it
interprets only `pure` (and exceptions) solidity-wise EVM bytecode otherwise this implementation
should throw an invalid opcode.

## Idea

The goal is to allow a smart contract to analyze an other smart contract and
detect if it would be allowed to run a function to force the suicide(address)
opcode.

```javascript
//Landlord.sol deployed @ 0xc8f8371BDd6FB64388F0D65F43A0040926Ee38be
contract Landlord {
	modifier canDestruct() {
		...
		evm.RunAtAddress(msg.sender, 0x2be5e0b2); // _eviction() function selector
		// check if `suicide exception` with returning address properly set
		...
	}

	function Register() canDestruct {
		// Register to oracle for service
	}
}

//Tenant.sol deployed @ 0x832658CEcFC4fb19661C3B8Bbd04A3A3720efe1e
contract Tenant {
	address TenantOwner;

	constructor(address owner) {
		TenantOwner = owner;
	}

	function _eviction() pure { // function selector 0x2be5e0b2
		require(msg.sender == 0xc8f8371BDd6FB64388F0D65F43A0040926Ee38be); // TODO add way to use storage for this particular usage
		selfdestruct(TenantOwner);
	}

	function constructor(address landlord) {
		Landlord(landlord).Register();
	}
}

```

This mechanism could enforce a final rent payment would be payable to the Landlord or `Service Provider`.

![Execution flow](docs/diagram.svg)

See https://ethresear.ch/t/paying-rent-with-deposits/2221
Old draft & related ideas: https://ethresear.ch/t/state-channel-toy-implementation/1495
Other idea: implement an oracle/DNS on top of that.
[Execute EVM inside EVM](https://github.com/ethereum/EIPs/issues/726)

## Development requirements

 * Truffle >= 5.0.0
 * Solidity v0.4.25

## Implemented opcode

 - [x] STOP
 - [x] ADD
 - [x] MUL
 - [x] SUB
 - [x] DIV
 - [ ] SDIV
 - [ ] MOD
 - [ ] SMOD
 - [ ] ADDMOD
 - [ ] MULMOD
 - [ ] EXP
 - [ ] SIGNEXTEND
 - [x] LT
 - [x] GT
 - [ ] SLT
 - [ ] SGT
 - [x] EQ
 - [x] ISZERO
 - [x] AND
 - [x] OR
 - [x] XOR
 - [x] NOT
 - [ ] BYTE
 - [ ] SHA3
 - [ ] ADDRESS
 - [x] ORIGIN
 - [x] CALLER
 - [x] CALLVALUE
 - [x] CALLDATALOAD
 - [x] CALLDATASIZE
 - [ ] CALLDATACOPY
 - [ ] CODESIZE
 - [ ] CODECOPY
 - [x] POP
 - [ ] MLOAD
 - [ ] MSTORE
 - [ ] MSTORE8
 - [x] JUMP
 - [x] JUMPI
 - [x] PC
 - [ ] MSIZE
 - [ ] GAS
 - [x] JUMPDEST
 - [ ] LOG0
 - [ ] LOG1
 - [ ] LOG2
 - [ ] LOG3
 - [ ] LOG4
 - [x] RETURN
 - [x] SUICIDE
 - [x] PUSH1
 - [x] PUSH2
 - [x] PUSH3
 - [x] PUSH4
 - [x] PUSH5
 - [x] PUSH6
 - [x] PUSH7
 - [x] PUSH8
 - [x] PUSH9
 - [x] PUSH10
 - [x] PUSH11
 - [x] PUSH12
 - [x] PUSH13
 - [x] PUSH14
 - [x] PUSH15
 - [x] PUSH16
 - [x] PUSH17
 - [x] PUSH18
 - [x] PUSH19
 - [x] PUSH20
 - [x] PUSH21
 - [x] PUSH22
 - [x] PUSH23
 - [x] PUSH24
 - [x] PUSH25
 - [x] PUSH26
 - [x] PUSH27
 - [x] PUSH28
 - [x] PUSH29
 - [x] PUSH30
 - [x] PUSH31
 - [x] PUSH32
 - [x] DUP1
 - [x] SWAP1
 - [x] DUP2
 - [x] SWAP2
 - [x] DUP3
 - [x] SWAP3
 - [x] DUP4
 - [x] SWAP4
 - [x] DUP5
 - [x] SWAP5
 - [x] DUP6
 - [x] SWAP6
 - [x] DUP7
 - [x] SWAP7
 - [x] DUP8
 - [x] SWAP8
 - [x] DUP9
 - [x] SWAP9
 - [x] DUP10
 - [x] SWAP10
 - [x] DUP11
 - [x] SWAP11
 - [x] DUP12
 - [x] SWAP12
 - [x] DUP13
 - [x] SWAP13
 - [x] DUP14
 - [x] SWAP14
 - [x] DUP15
 - [x] SWAP15
 - [x] DUP16
 - [x] SWAP16
