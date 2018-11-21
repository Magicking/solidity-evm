var SolidityEVM = artifacts.require("./SolidityEVM.sol");

// Enum EIP https://github.com/ethereum/EIPs/issues/47

contract('SolidityEVM', function(accounts) {
  it("run stop 2 suicide", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call(0, 0, "0x00ffff", 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
  it("run push1 stop", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call(0, 0, "0x604200", 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
  it("run pop push1", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call(0, 0, "0x506042", 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 7, "StackUnderflow was not the exit opcode");
    });
  });
 it("run push1 0x00 push1 0xff lt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600060ff10";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "LT failed");
    });
  });
 it("run push1 0x88 push1 0x77 lt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6088607710";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "LT failed");
    });
  });
 it("run push1 0xff push1 0x0f gt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60ff600f11";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "LT failed");
    });
  });
 it("run push1 0x00 push1 0xff gt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600060ff11";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "LT failed");
    });
  });
 it("run push1 0xff push1 0xff eq", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60ff60ff14";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "eq failed");
    });
  });
 it("run push1 0x02 push1 0x04 div", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6002600404";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 2, "div failed");
    });
  });
 it("run push1 0x02 push1 0x04 sub", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6002600403";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 2, "div failed");
    });
  });
 it("run push1 0x00 iszero", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600015";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "eq failed");
    });
  });
 it("run push1 0xff iszero", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60ff15";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "eq failed");
    });
  });
 it("run push1 0x02 push1 0x02 mul push 0x04 eq", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6002600202600414";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "eq failed");
    });
  });
 it("run push1 0x00 push1 0xff eq", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600060ff14";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "eq failed");
    });
  });
 it("run push32 ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff not", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff19";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "push32 not");
    });
  });
 it("run callvalue", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "34";
      return instance.stackRun.call(0, 0, "0x"+code, 42, "0xdeadbeef");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 42, "callvalue");
    });
  });
 it("run calldatasize", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "36";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0xdeadbeef");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 4, "callvalue");
    });
  });
 it("run calldataload", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "35";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x77000000000000000000000000000000000000000000000000000000000000ff");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0x77000000000000000000000000000000000000000000000000000000000000ff, "calldataload");
    });
  });
 it("run calldataload sha3", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "3520";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x77000000000000000000000000000000000000000000000000000000000000ff");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0xece192811671baad79f5d46fd949c4b7ca5ae2010a9107bccfa9a14baf710632, "calldataload");
    });
  });
/* it("run calldatacopy", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "37";
      return instance.memoryRun.call(0, 0, "0x"+code, 0, "0xdeadbeef");
    }).then(function(ret) {
      assert.equal(ret, [0xef,0xbe,0xad,0xde], "calldatacopy");
    });
  });*/
 it("run push1 0xaa push1 0xbb push1 0xcc push1 0xdd push1 0xee push1 0xff dup6", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60aa60bb60cc60dd60ee60ff85";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[ret.length-1].valueOf(), 0xaa, "dup6 failed");
    });
  });
 it("run push1 0xff dup1", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60ff85";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[ret.length-1].valueOf(), 0xff, "dup6 failed");
    });
  });
 it("run push2 0x6120 suicide", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "616120ff";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0x6120, "suicide failed");
    });
  });
 it("run push20 0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165 suicide", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "736120a7e00f3b2937362dfdac9f80b79f5b55f165ff";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165, "suicide failed");
    });
  });
 it("run push1 0xaa push1 0xbb push1 0xcc push1 0xdd push1 0xee push1 0xff swap6", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60aa60bb60cc60dd60ee60ff95";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0xff, "swap1 failed");
    });
  });
 it("run push1 0xaa pc", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60aa58";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[ret.length-1].valueOf(), 2, "pc failed");
    });
  });
 it("run push 0x05 jumpdest push 0x01 swap1 sub dup1 push1 0x02 jumpi push 0x42", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60015b60019003806002576042";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[1].valueOf(), 0x42, "jump failed");
    });
  });
  it("run push 0x00 jump", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600056";
      return instance.stopReasonRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 6, "InvalidDestination was not the exception reason");
    });
  });
 it("run push1 0xaa push1 0xbb swap1", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60aa60bb90";
      return instance.stackRun.call(0, 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0xaa, "swap1 failed");
    });
  });
 it("run caller", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "33";
      return instance.stackRun.call(0, "0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165", "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165, "origin failed");
    });
  });
 it("run origin", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "32";
      return instance.stackRun.call("0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165", 0, "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165, "origin failed");
    });
  });
/* it("run README example", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "608060405260043610603f576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632be5e0b2146044575b600080fd5b348015604f57600080fd5b5060566058565b005b736120a7e00f3b2937362dfdac9f80b79f5b55f16573ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614151560a557600080fd5b736120a7e00f3b2937362dfdac9f80b79f5b55f16573ffffffffffffffffffffffffffffffffffffffff16ff00a165627a7a723058200d64708a13d80a67474d68eb61b986ff89af6973a20e3902b6e468f3380db4570029";
      return instance.stopReasonRun.call(0, "0x6120A7E00f3B2937362DFdAc9f80b79f5b55f165", "0x"+code, 0, "0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 9, "Suicide ending failed");
    });
  });*/
  it("run 1025 push1 stop", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6042".repeat(1025)+"00";
      return instance.stopReasonRun.call(0, 0, "0x"+code, 0, "0x00", {gas: 34359738368});
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 8, "StackOverflow was not the exit opcode");
    });
  });
});
