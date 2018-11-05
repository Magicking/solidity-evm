pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract SolidityEVM {

	enum Exception {NO_EXCEPTION, Halt, OutOfGas, Throw, InvalidOpcode, InvalidCode, InvalidDestination, StackUndeflow, StackOverflow, Suicide}

	struct OpCode {
		uint8 Ins;
		uint8 Outs;
		int Gas;
		uint8 flags;
	}

	struct Context {
		uint[] Stack;
		uint StackPtr;
		bytes Mem;
		address From;
		address Origin;
		uint256 RetOffset;
		uint256 RetSize;
		bytes Code;
		bytes Input;
		uint Value;
		uint PC;
		int GasLeft;
		Exception StopReason;
	}

	Context public _ctx;

//	/*
//	* @dev Evaluate the last decoded instruction JULIA flavor
//	*/
//	function evalJULIA(Context memory ctx, uint256 instruction) internal returns (Exception) {
//		Exception ret;
//
//		assembly {
//			switch instruction
//			case 0x00 { // STOP
//				ret := 1 // Exception.Halt
//			}
//			case 0x01 {
//				// push OpCodes[instruction].Ins
//				// add
//				// pop  OpCodes[instruction].Outs
//				// set memory
//			}
//			default {
//				ret := 2 // Exception.Throw
//				//throw
//			}
//		}
//
//		return ret;
//	}

	/*
	* @dev Pop uint256 from stack
	*/
	function _pop(Context storage ctx) internal returns (uint256) {
		if (ctx.StackPtr == 0) {
			ctx.StopReason = Exception.StackUndeflow;
			return 0;
		}
		ctx.StackPtr--;
		return ctx.Stack[ctx.StackPtr];
	}

	/*
	* @dev Push uint256 from stack
	*/
	function _push(Context storage ctx, uint256 value) internal {
		if (ctx.StackPtr == 1024) { // stack size max, see Yellow Paper: 9.1 and 9.4.2.
			ctx.StopReason = Exception.StackOverflow;
			return;
		}

		if (ctx.StackPtr < ctx.Stack.length) {
			ctx.Stack[ctx.StackPtr] = value;
		} else {
			ctx.Stack.push(value);
		}
		ctx.StackPtr++;
	}

	/*
	* @dev Set uint256 to memory
	*/
//	function _setUint256(Context memory ctx, uint256 offset, uint256 value) internal {
//		if (offset > ctx.Mem.length) {
//			ctx.Mem.length = offset + 0x20; // 256-bit word, see Yellow Paper: 9.1. 0x20
//		}
//		ctx.Mem[offset] = value;
//	}

	/*
	* @dev Set bytes to memory
	*/
//	function _setBytes(Context memory ctx, uint256 offset, bytes data) internal {
//		bytes(ctx.Stack)[ctx.StackPtr] = data;
//		ctx.StackPtr++;
//	}

	/*
	* @dev Evaluate the last decoded instruction Solidity flavor
	*/
	function eval(Context storage ctx, uint256 instruction) internal {
		uint256 r1; // us[] is stack, r stand for register 1, 2, 3
		uint256 r2;
		uint256 r3;
		uint256 i;
		if (instruction == 0x00) { // STOP
			if (ctx.Mem.length == 0)
				ctx.Mem.push(0);
			ctx.Mem[0] = byte(0);
			ctx.StopReason = Exception.Halt;
			return;
		}
		if (instruction == 0x01) { // ADD
			ctx.GasLeft -= 3;
			_push(ctx, _pop(ctx) + _pop(ctx));
			ctx.PC++;
			return;
		}
		if (instruction == 0x02) { // MUL
			ctx.GasLeft -= 5;
			_push(ctx, _pop(ctx) * _pop(ctx));
			ctx.PC++;
			return;
		}
		if (instruction == 0x03) { // SUB
			ctx.GasLeft -= 3;
			r1 = _pop(ctx);
			_push(ctx, r1 - _pop(ctx));
			ctx.PC++;
			return;
		}
		if (instruction == 0x04) { // DIV
			ctx.GasLeft -= 5;
			r1 = _pop(ctx);
			if (r1 == 0)
				_push(ctx, 0);
			else
				_push(ctx, r1 / _pop(ctx));
			ctx.PC++;
			return;
		}
		if (instruction == 0x10) { // LT
			ctx.GasLeft -= 3;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 > _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x11) { // GT
			ctx.GasLeft -= 3;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 < _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x14) { // EQ
			ctx.GasLeft -= 3;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 == _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x15) { // ISZERO
			ctx.GasLeft -= 3;
			_push(ctx, _pop(ctx) == 0 ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x16) { // AND
			ctx.GasLeft -= 3;
			r1 = _pop(ctx);
			_push(ctx, r1 & _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x17) { // OR
			ctx.GasLeft -= 3;
			r1 = _pop(ctx);
			_push(ctx, r1 | _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x18) { // XOR
			ctx.GasLeft -= 3;
			r1 = _pop(ctx);
			_push(ctx, r1 ^ _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x19) { // NOT
			ctx.GasLeft -= 3;
			_push(ctx, _pop(ctx) ^ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x32) { // ORIGIN
			ctx.GasLeft -= 2;
			_push(ctx, uint256(ctx.Origin));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x33) { // CALLER
			ctx.GasLeft -= 2;
			_push(ctx, uint256(ctx.From));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x34) { // CALLVALUE
			ctx.GasLeft -= 2;
			_push(ctx, ctx.Value);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x35) { // CALLDATALOAD
			ctx.GasLeft -= 3;
			r2 = _pop(ctx);
			r3 = ctx.Input.length < 32 ? ctx.Input.length : 32;
			for (i = 0; i < r3 && (i+r2) < ctx.Input.length; i++)
				r1 |= uint256(ctx.Input[i+r2]) << ((31-i) * 8);
			_push(ctx, r1);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x36) { // CALLDATASIZE
			ctx.GasLeft -= 2;
			_push(ctx, ctx.Input.length);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x50) { // POP
			ctx.GasLeft -= 2;
			_pop(ctx);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x56) { // JUMP
			ctx.GasLeft -= 8;
			r1 = _pop(ctx);
			if (ctx.Code[r1] != 0x5b) {
				ctx.StopReason = Exception.InvalidDestination;
				return;
			}
			ctx.PC = r1;
			return;
		}
		if (instruction == 0x57) { // JUMPI
			ctx.GasLeft -= 10;
			r1 = _pop(ctx);
			r2 = _pop(ctx);
			if (r2 != 0) {
				if (ctx.Code[r1] != 0x5b) {
					ctx.StopReason = Exception.InvalidDestination;
					return;
				}
				ctx.PC = r1;
			} else {
				ctx.PC++;
			}
			return;
		}
		if (instruction == 0x58) { // PC
			ctx.GasLeft -= 2;
			_push(ctx, ctx.PC);
			ctx.PC++;
			return;
		}
		if (instruction == 0x5b) { // JUMPDEST
			ctx.GasLeft -= 1;
			ctx.PC++;
			return;
		}
		if (0x60 <= instruction && instruction <= 0x7f) { // PUSHXX
			ctx.GasLeft -= 3;
			for (i = 0; i < (instruction-0x5f); i++)
				r1 |= uint256(ctx.Code[ctx.PC+i+1]) << (((instruction-0x60)-i) * 8);
			_push(ctx, r1);
			ctx.PC += instruction-0x5e;
			return;
		}
		if (0x80 <= instruction && instruction <= 0x8f) { // DUPXX
			if (ctx.StackPtr < instruction-0x7f) {
				ctx.StopReason = Exception.StackUndeflow;
				return;
			}
			ctx.GasLeft -= 3;
			_push(ctx, ctx.Stack[ctx.StackPtr-(instruction-0x7f)]);
			ctx.PC += 1;
			return;
		}
		if (0x90 <= instruction && instruction <= 0x9f) { // SWAPXX
			if (ctx.StackPtr < instruction-0x8f) {
				ctx.StopReason = Exception.StackUndeflow;
				return;
			}
			ctx.GasLeft -= 3;
			r1 = ctx.Stack[ctx.StackPtr-1];
			ctx.Stack[ctx.StackPtr-1] = ctx.Stack[ctx.StackPtr - (instruction-0x8f)];
			ctx.Stack[ctx.StackPtr - (instruction-0x8f)] = r1;
			ctx.PC += 1;
			return;
		}
		if (instruction == 0xf3) { // RETURN
			ctx.RetOffset = _pop(ctx);
			ctx.RetSize = _pop(ctx) - ctx.RetOffset;
			if (ctx.StopReason == Exception.NO_EXCEPTION) // Avoid rewriting exception
				ctx.StopReason = Exception.Halt;
			return;
		}
		if (instruction == 0xff) { // SELFDESTRUCT
			// r1 = _pop(ctx);  address for refund should be in us[0]
			if (ctx.StackPtr == 0) { // Avoid rewriting exception
				ctx.StopReason = Exception.StackUndeflow;
				return;
			}
			if (ctx.StopReason == Exception.NO_EXCEPTION) // Avoid rewriting exception
				ctx.StopReason = Exception.Halt;
			else
				ctx.StopReason = Exception.Suicide;
			return;
		}
		//SHA3
		//REVERT
		//0xaf
		//0x0d
		//0xb4
		//0x29
		//LOG

/*		//SDIV
		OpCodes[5].Gas = 5;
		//MOD
		OpCodes[6].Gas = 5;
		//SMOD
		OpCodes[7].Gas = 5;
		//ADDMOD
		OpCodes[8].Gas = 8;
		//MULMOD
		OpCodes[9].Gas = 8;
		//EXP
		OpCodes[10].Gas = 10;
		//SIGNEXTEND
		OpCodes[11].Gas = 5;
		//BYTE
		OpCodes[26].Gas = 3;
		//SHA3
		OpCodes[32].Gas = 30;
		//ADDRESS
		OpCodes[48].Gas = 2;
		//CALLDATACOPY
		OpCodes[55].Gas = 3;
		//MLOAD
		OpCodes[81].Gas = 3;
		//MSTORE
		OpCodes[82].Gas = 3;
		//MSTORE8
		OpCodes[83].Gas = 3;
		//MSIZE
		OpCodes[89].Gas = 2;
		//GAS
		OpCodes[90].Gas = 2;
		//LOG0
		OpCodes[160].Gas = 375;
		//LOG1
		OpCodes[161].Gas = 750;
		//LOG2
		OpCodes[162].Gas = 1125;
		//LOG3
		OpCodes[163].Gas = 1500;
		//LOG4
		OpCodes[164].Gas = 1875;
*/
		ctx.StopReason = Exception.InvalidOpcode;
	}

	/*
	* @dev data, is calldata
	*/

	//function runAtAddress(address account, bytes data) ...

	function memoryRun(address origin, address from, bytes code, uint value, bytes data) public returns (bytes) {
		return run(origin, from, code, value, data).Mem;
	}
	function stackRun(address origin, address from, bytes code, uint value, bytes data) public returns (uint[]) {
		return run(origin, from, code, value, data).Stack;
	}
	function stopReasonRun(address origin, address from, bytes code, uint value, bytes data) public returns (Exception) {
		return run(origin, from, code, value, data).StopReason;
	}

	function run(address origin, address from, bytes code, uint value, bytes data) public returns (Context) {
		Context storage ctx = _ctx;
		ctx.Code = code;
		ctx.Input = data;
		ctx.Value = value;
		ctx.From = from;
		ctx.Origin = origin;
		ctx.GasLeft = 0x80000; // TBD
		ctx.StopReason = Exception.NO_EXCEPTION;

		if (code.length == 0)
			ctx.StopReason = Exception.InvalidCode;

		while(ctx.StopReason == Exception.NO_EXCEPTION) {
			// check gas remaining
			eval(ctx, uint256(code[ctx.PC]));
			if (ctx.PC >= code.length){
				ctx.StopReason = Exception.InvalidDestination;
				break;
			}
		}
		return ctx;
	}

}
