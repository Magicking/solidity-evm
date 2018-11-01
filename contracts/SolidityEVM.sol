pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract SolidityEVM {

	enum Exception {NO_EXCEPTION, Halt, OutOfGas, Throw, InvalidOpcode, InvalidCode, InvalidDestination, StackUndeflow, StackOverflow}

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
		uint256 RetOffset;
		uint256 RetSize;
		bytes Code;
		bytes Input;
		uint PC;
		int GasLeft;
		Exception StopReason;
	}

	Context public _ctx;
	OpCode[] public OpCodes;

	constructor() public {
		OpCodes.length = 256; // TBD Metropolis/Byzantium/Custom
		/* python
		Get Opcodes lists from https://github.com/CoinCulture/evm-tools/blob/master/analysis/guide.md and run
		for i in opcodes: print("\t//%s\n\tOpCodes[%d].Ins = %d;\n\tOpCodes[%d].Outs = %d;\n\tOpCodes[%d].Gas = %d;\n" % (opcodes[i][0],i,opcodes[i][1],i,opcodes[i][2],i,opcodes[i][3]))
		Some opcodes are missings (CREATE2, ...)
		   */
		//STOP
        
		OpCodes[0].Ins = 0;
		OpCodes[0].Outs = 0;
		OpCodes[0].Gas = 0;

		//ADD
		OpCodes[1].Ins = 2;
		OpCodes[1].Outs = 1;
		OpCodes[1].Gas = 3;
/*
		//MUL
		OpCodes[2].Ins = 2;
		OpCodes[2].Outs = 1;
		OpCodes[2].Gas = 5;

		//SUB
		OpCodes[3].Ins = 2;
		OpCodes[3].Outs = 1;
		OpCodes[3].Gas = 3;

		//DIV
		OpCodes[4].Ins = 2;
		OpCodes[4].Outs = 1;
		OpCodes[4].Gas = 5;

		//SDIV
		OpCodes[5].Ins = 2;
		OpCodes[5].Outs = 1;
		OpCodes[5].Gas = 5;

		//MOD
		OpCodes[6].Ins = 2;
		OpCodes[6].Outs = 1;
		OpCodes[6].Gas = 5;

		//SMOD
		OpCodes[7].Ins = 2;
		OpCodes[7].Outs = 1;
		OpCodes[7].Gas = 5;

		//ADDMOD
		OpCodes[8].Ins = 3;
		OpCodes[8].Outs = 1;
		OpCodes[8].Gas = 8;

		//MULMOD
		OpCodes[9].Ins = 3;
		OpCodes[9].Outs = 1;
		OpCodes[9].Gas = 8;

		//EXP
		OpCodes[10].Ins = 2;
		OpCodes[10].Outs = 1;
		OpCodes[10].Gas = 10;

		//SIGNEXTEND
		OpCodes[11].Ins = 2;
		OpCodes[11].Outs = 1;
		OpCodes[11].Gas = 5;

		//LT
		OpCodes[16].Ins = 2;
		OpCodes[16].Outs = 1;
		OpCodes[16].Gas = 3;

		//GT
		OpCodes[17].Ins = 2;
		OpCodes[17].Outs = 1;
		OpCodes[17].Gas = 3;

		//SLT
		OpCodes[18].Ins = 2;
		OpCodes[18].Outs = 1;
		OpCodes[18].Gas = 3;

		//SGT
		OpCodes[19].Ins = 2;
		OpCodes[19].Outs = 1;
		OpCodes[19].Gas = 3;

		//EQ
		OpCodes[20].Ins = 2;
		OpCodes[20].Outs = 1;
		OpCodes[20].Gas = 3;

		//ISZERO
		OpCodes[21].Ins = 1;
		OpCodes[21].Outs = 1;
		OpCodes[21].Gas = 3;

		//AND
		OpCodes[22].Ins = 2;
		OpCodes[22].Outs = 1;
		OpCodes[22].Gas = 3;

		//OR
		OpCodes[23].Ins = 2;
		OpCodes[23].Outs = 1;
		OpCodes[23].Gas = 3;

		//XOR
		OpCodes[24].Ins = 2;
		OpCodes[24].Outs = 1;
		OpCodes[24].Gas = 3;

		//NOT
		OpCodes[25].Ins = 1;
		OpCodes[25].Outs = 1;
		OpCodes[25].Gas = 3;

		//BYTE
		OpCodes[26].Ins = 2;
		OpCodes[26].Outs = 1;
		OpCodes[26].Gas = 3;

		//SHA3
		OpCodes[32].Ins = 2;
		OpCodes[32].Outs = 1;
		OpCodes[32].Gas = 30;

		//ADDRESS
		OpCodes[48].Ins = 0;
		OpCodes[48].Outs = 1;
		OpCodes[48].Gas = 2;

		//ORIGIN
		OpCodes[50].Ins = 0;
		OpCodes[50].Outs = 1;
		OpCodes[50].Gas = 2;

		//CALLER
		OpCodes[51].Ins = 0;
		OpCodes[51].Outs = 1;
		OpCodes[51].Gas = 2;

		//CALLVALUE
		OpCodes[52].Ins = 0;
		OpCodes[52].Outs = 1;
		OpCodes[52].Gas = 2;

		//CALLDATALOAD
		OpCodes[53].Ins = 1;
		OpCodes[53].Outs = 1;
		OpCodes[53].Gas = 3;

		//CALLDATASIZE
		OpCodes[54].Ins = 0;
		OpCodes[54].Outs = 1;
		OpCodes[54].Gas = 2;

		//CALLDATACOPY
		OpCodes[55].Ins = 3;
		OpCodes[55].Outs = 0;
		OpCodes[55].Gas = 3;

		//POP
		OpCodes[80].Ins = 1;
		OpCodes[80].Outs = 0;
		OpCodes[80].Gas = 2;

		//MLOAD
		OpCodes[81].Ins = 1;
		OpCodes[81].Outs = 1;
		OpCodes[81].Gas = 3;

		//MSTORE
		OpCodes[82].Ins = 2;
		OpCodes[82].Outs = 0;
		OpCodes[82].Gas = 3;

		//MSTORE8
		OpCodes[83].Ins = 2;
		OpCodes[83].Outs = 0;
		OpCodes[83].Gas = 3;

		//JUMP
		OpCodes[86].Ins = 1;
		OpCodes[86].Outs = 0;
		OpCodes[86].Gas = 8;

		//JUMPI
		OpCodes[87].Ins = 2;
		OpCodes[87].Outs = 0;
		OpCodes[87].Gas = 10;

		//PC
		OpCodes[88].Ins = 0;
		OpCodes[88].Outs = 1;
		OpCodes[88].Gas = 2;

		//MSIZE
		OpCodes[89].Ins = 0;
		OpCodes[89].Outs = 1;
		OpCodes[89].Gas = 2;

		//GAS
		OpCodes[90].Ins = 0;
		OpCodes[90].Outs = 1;
		OpCodes[90].Gas = 2;

		//JUMPDEST
		OpCodes[91].Ins = 0;
		OpCodes[91].Outs = 0;
		OpCodes[91].Gas = 1;

		//LOG0
		OpCodes[160].Ins = 2;
		OpCodes[160].Outs = 0;
		OpCodes[160].Gas = 375;

		//LOG1
		OpCodes[161].Ins = 3;
		OpCodes[161].Outs = 0;
		OpCodes[161].Gas = 750;

		//LOG2
		OpCodes[162].Ins = 4;
		OpCodes[162].Outs = 0;
		OpCodes[162].Gas = 1125;

		//LOG3
		OpCodes[163].Ins = 5;
		OpCodes[163].Outs = 0;
		OpCodes[163].Gas = 1500;

		//LOG4
		OpCodes[164].Ins = 6;
		OpCodes[164].Outs = 0;
		OpCodes[164].Gas = 1875;
*/
		//RETURN
		OpCodes[243].Ins = 2;
		OpCodes[243].Outs = 0;
		OpCodes[243].Gas = 0;

		//SUICIDE
		OpCodes[255].Ins = 1;
		OpCodes[255].Outs = 0;
		OpCodes[255].Gas = 0;

		//PUSH1
		OpCodes[96].Ins = 0;
		OpCodes[96].Outs = 1;
		OpCodes[96].Gas = 3;
/*
		//PUSH2
		OpCodes[97].Ins = 0;
		OpCodes[97].Outs = 1;
		OpCodes[97].Gas = 3;

		//PUSH3
		OpCodes[98].Ins = 0;
		OpCodes[98].Outs = 1;
		OpCodes[98].Gas = 3;

		//PUSH4
		OpCodes[99].Ins = 0;
		OpCodes[99].Outs = 1;
		OpCodes[99].Gas = 3;

		//PUSH5
		OpCodes[100].Ins = 0;
		OpCodes[100].Outs = 1;
		OpCodes[100].Gas = 3;

		//PUSH6
		OpCodes[101].Ins = 0;
		OpCodes[101].Outs = 1;
		OpCodes[101].Gas = 3;

		//PUSH7
		OpCodes[102].Ins = 0;
		OpCodes[102].Outs = 1;
		OpCodes[102].Gas = 3;

		//PUSH8
		OpCodes[103].Ins = 0;
		OpCodes[103].Outs = 1;
		OpCodes[103].Gas = 3;

		//PUSH9
		OpCodes[104].Ins = 0;
		OpCodes[104].Outs = 1;
		OpCodes[104].Gas = 3;

		//PUSH10
		OpCodes[105].Ins = 0;
		OpCodes[105].Outs = 1;
		OpCodes[105].Gas = 3;

		//PUSH11
		OpCodes[106].Ins = 0;
		OpCodes[106].Outs = 1;
		OpCodes[106].Gas = 3;

		//PUSH12
		OpCodes[107].Ins = 0;
		OpCodes[107].Outs = 1;
		OpCodes[107].Gas = 3;

		//PUSH13
		OpCodes[108].Ins = 0;
		OpCodes[108].Outs = 1;
		OpCodes[108].Gas = 3;

		//PUSH14
		OpCodes[109].Ins = 0;
		OpCodes[109].Outs = 1;
		OpCodes[109].Gas = 3;

		//PUSH15
		OpCodes[110].Ins = 0;
		OpCodes[110].Outs = 1;
		OpCodes[110].Gas = 3;

		//PUSH16
		OpCodes[111].Ins = 0;
		OpCodes[111].Outs = 1;
		OpCodes[111].Gas = 3;

		//PUSH17
		OpCodes[112].Ins = 0;
		OpCodes[112].Outs = 1;
		OpCodes[112].Gas = 3;

		//PUSH18
		OpCodes[113].Ins = 0;
		OpCodes[113].Outs = 1;
		OpCodes[113].Gas = 3;

		//PUSH19
		OpCodes[114].Ins = 0;
		OpCodes[114].Outs = 1;
		OpCodes[114].Gas = 3;

		//PUSH20
		OpCodes[115].Ins = 0;
		OpCodes[115].Outs = 1;
		OpCodes[115].Gas = 3;

		//PUSH21
		OpCodes[116].Ins = 0;
		OpCodes[116].Outs = 1;
		OpCodes[116].Gas = 3;

		//PUSH22
		OpCodes[117].Ins = 0;
		OpCodes[117].Outs = 1;
		OpCodes[117].Gas = 3;

		//PUSH23
		OpCodes[118].Ins = 0;
		OpCodes[118].Outs = 1;
		OpCodes[118].Gas = 3;

		//PUSH24
		OpCodes[119].Ins = 0;
		OpCodes[119].Outs = 1;
		OpCodes[119].Gas = 3;

		//PUSH25
		OpCodes[120].Ins = 0;
		OpCodes[120].Outs = 1;
		OpCodes[120].Gas = 3;

		//PUSH26
		OpCodes[121].Ins = 0;
		OpCodes[121].Outs = 1;
		OpCodes[121].Gas = 3;

		//PUSH27
		OpCodes[122].Ins = 0;
		OpCodes[122].Outs = 1;
		OpCodes[122].Gas = 3;

		//PUSH28
		OpCodes[123].Ins = 0;
		OpCodes[123].Outs = 1;
		OpCodes[123].Gas = 3;

		//PUSH29
		OpCodes[124].Ins = 0;
		OpCodes[124].Outs = 1;
		OpCodes[124].Gas = 3;

		//PUSH30
		OpCodes[125].Ins = 0;
		OpCodes[125].Outs = 1;
		OpCodes[125].Gas = 3;

		//PUSH31
		OpCodes[126].Ins = 0;
		OpCodes[126].Outs = 1;
		OpCodes[126].Gas = 3;

		//PUSH32
		OpCodes[127].Ins = 0;
		OpCodes[127].Outs = 1;
		OpCodes[127].Gas = 3;

		//DUP1
		OpCodes[128].Ins = 1;
		OpCodes[128].Outs = 2;
		OpCodes[128].Gas = 3;

		//SWAP1
		OpCodes[144].Ins = 2;
		OpCodes[144].Outs = 2;
		OpCodes[144].Gas = 3;

		//DUP2
		OpCodes[129].Ins = 2;
		OpCodes[129].Outs = 3;
		OpCodes[129].Gas = 3;

		//SWAP2
		OpCodes[145].Ins = 3;
		OpCodes[145].Outs = 3;
		OpCodes[145].Gas = 3;

		//DUP3
		OpCodes[130].Ins = 3;
		OpCodes[130].Outs = 4;
		OpCodes[130].Gas = 3;

		//SWAP3
		OpCodes[146].Ins = 4;
		OpCodes[146].Outs = 4;
		OpCodes[146].Gas = 3;

		//DUP4
		OpCodes[131].Ins = 4;
		OpCodes[131].Outs = 5;
		OpCodes[131].Gas = 3;

		//SWAP4
		OpCodes[147].Ins = 5;
		OpCodes[147].Outs = 5;
		OpCodes[147].Gas = 3;

		//DUP5
		OpCodes[132].Ins = 5;
		OpCodes[132].Outs = 6;
		OpCodes[132].Gas = 3;

		//SWAP5
		OpCodes[148].Ins = 6;
		OpCodes[148].Outs = 6;
		OpCodes[148].Gas = 3;

		//DUP6
		OpCodes[133].Ins = 6;
		OpCodes[133].Outs = 7;
		OpCodes[133].Gas = 3;

		//SWAP6
		OpCodes[149].Ins = 7;
		OpCodes[149].Outs = 7;
		OpCodes[149].Gas = 3;

		//DUP7
		OpCodes[134].Ins = 7;
		OpCodes[134].Outs = 8;
		OpCodes[134].Gas = 3;

		//SWAP7
		OpCodes[150].Ins = 8;
		OpCodes[150].Outs = 8;
		OpCodes[150].Gas = 3;

		//DUP8
		OpCodes[135].Ins = 8;
		OpCodes[135].Outs = 9;
		OpCodes[135].Gas = 3;

		//SWAP8
		OpCodes[151].Ins = 9;
		OpCodes[151].Outs = 9;
		OpCodes[151].Gas = 3;

		//DUP9
		OpCodes[136].Ins = 9;
		OpCodes[136].Outs = 10;
		OpCodes[136].Gas = 3;

		//SWAP9
		OpCodes[152].Ins = 10;
		OpCodes[152].Outs = 10;
		OpCodes[152].Gas = 3;

		//DUP10
		OpCodes[137].Ins = 10;
		OpCodes[137].Outs = 11;
		OpCodes[137].Gas = 3;

		//SWAP10
		OpCodes[153].Ins = 11;
		OpCodes[153].Outs = 11;
		OpCodes[153].Gas = 3;

		//DUP11
		OpCodes[138].Ins = 11;
		OpCodes[138].Outs = 12;
		OpCodes[138].Gas = 3;

		//SWAP11
		OpCodes[154].Ins = 12;
		OpCodes[154].Outs = 12;
		OpCodes[154].Gas = 3;

		//DUP12
		OpCodes[139].Ins = 12;
		OpCodes[139].Outs = 13;
		OpCodes[139].Gas = 3;

		//SWAP12
		OpCodes[155].Ins = 13;
		OpCodes[155].Outs = 13;
		OpCodes[155].Gas = 3;

		//DUP13
		OpCodes[140].Ins = 13;
		OpCodes[140].Outs = 14;
		OpCodes[140].Gas = 3;

		//SWAP13
		OpCodes[156].Ins = 14;
		OpCodes[156].Outs = 14;
		OpCodes[156].Gas = 3;

		//DUP14
		OpCodes[141].Ins = 14;
		OpCodes[141].Outs = 15;
		OpCodes[141].Gas = 3;

		//SWAP14
		OpCodes[157].Ins = 15;
		OpCodes[157].Outs = 15;
		OpCodes[157].Gas = 3;

		//DUP15
		OpCodes[142].Ins = 15;
		OpCodes[142].Outs = 16;
		OpCodes[142].Gas = 3;

		//SWAP15
		OpCodes[158].Ins = 16;
		OpCodes[158].Outs = 16;
		OpCodes[158].Gas = 3;

		//DUP16
		OpCodes[143].Ins = 16;
		OpCodes[143].Outs = 17;
		OpCodes[143].Gas = 3;

		//SWAP16
		OpCodes[159].Ins = 17;
		OpCodes[159].Outs = 17;
		OpCodes[159].Gas = 3;*/
	}

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
		uint256 r1; // us[] is stack, r1 stand for register
		if (instruction == 0x00) {
			if (ctx.Mem.length == 0)
				ctx.Mem.push(0);
			ctx.Mem[0] = byte(0);
			ctx.StopReason = Exception.Halt;
			return;
		}
		if (instruction == 0x01) { // ADD
			ctx.GasLeft -= OpCodes[instruction].Gas;
			_push(ctx, _pop(ctx) + _pop(ctx));
			ctx.PC++;
			return;
		}
		if (instruction == 0x02) { // MUL
			ctx.GasLeft -= OpCodes[instruction].Gas;
			_push(ctx, _pop(ctx) * _pop(ctx));
			ctx.PC++;
			return;
		}
		if (0x60 <= instruction && instruction <= 0x7f) { // PUSHXX
			uint256 out;
			ctx.GasLeft -= OpCodes[instruction].Gas;
			for (uint i = 0; i < (instruction-0x5f); i++)
				out |= uint256(ctx.Code[ctx.PC+i+1]) << (i * 8);
			_push(ctx, out);
			ctx.PC += instruction-0x5e;
			return;
		}
		if (instruction == 0x10) { // LT
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 > _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x11) { // GT
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 < _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x14) { // EQ
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx); //us[1]
			_push(ctx, r1 == _pop(ctx) ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x15) { // ISZERO
			ctx.GasLeft -= OpCodes[instruction].Gas;
			_push(ctx, _pop(ctx) == 0 ? 1 : 0);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x16) { // AND
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx);
			_push(ctx, r1 & _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x17) { // OR
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx);
			_push(ctx, r1 | _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x18) { // XOR
			ctx.GasLeft -= OpCodes[instruction].Gas;
			r1 = _pop(ctx);
			_push(ctx, r1 ^ _pop(ctx));
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x19) { // NOT
			ctx.GasLeft -= OpCodes[instruction].Gas;
			_push(ctx, _pop(ctx) ^ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
			ctx.PC += 1;
			return;
		}
		if (instruction == 0x50) { // POP
			ctx.GasLeft -= OpCodes[instruction].Gas;
			_pop(ctx);
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
		// ...
		ctx.StopReason = Exception.InvalidOpcode;
	}

	/*
	* @dev data, is calldata
	*/
	/*
	struct Context {
		uint[] Stack;
		uint StackPtr;
		bytes Mem;
		bytes Code;
		bytes Input;
		uint PC;
		int GasLeft;
	}
	 */

	//function runAtAddress(address account, bytes data) ...

	function stackRun(bytes code, bytes data) public returns (uint[]) {
		return run(code, data).Stack;
	}
	function stopReasonRun(bytes code, bytes data) public returns (Exception) {
		return run(code, data).StopReason;
	}

	function run(bytes code, bytes data) public returns (Context) {
		Context storage ctx = _ctx;
		ctx.Code = code;
		ctx.Input = data;
		ctx.GasLeft = 0x80000; // TBD

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
