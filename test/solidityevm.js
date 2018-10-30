var SolidityEVM = artifacts.require("./SolidityEVM.sol");

// Enum EIP https://github.com/ethereum/EIPs/issues/47

contract('SolidityEVM', function(accounts) {
  it("run stop 2 suicide", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call("0x00ffff","0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
  it("run push1 stop", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call("0x604200","0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
  it("run pop push1", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call("0x806042","0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 7, "StackUnderflow was not the exit opcode");
    });
  });
 it("run push1 0x00 push1 0xff lt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600060ff10";
      return instance.stackRun.call("0x"+code,"0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "LT failed");
    });
  });
 it("run push1 0x88 push1 0x77 lt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6088607710";
      return instance.stackRun.call("0x"+code,"0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "LT failed");
    });
  });
 it("run push1 0xff push1 0x0f gt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "60ff600f11";
      return instance.stackRun.call("0x"+code,"0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 1, "LT failed");
    });
  });
 it("run push1 0x00 push1 0xff gt", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "600060ff11";
      return instance.stackRun.call("0x"+code,"0x00");
    }).then(function(ret) {
      assert.equal(ret[0].valueOf(), 0, "LT failed");
    });
  });
  it("run 1025 push1 stop", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6042".repeat(1025);
      return instance.stopReasonRun.call("0x"+code+"00","0x00", {gas: 34359738368});
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 8, "StackOverflow was not the exit opcode");
    });
  });
});
