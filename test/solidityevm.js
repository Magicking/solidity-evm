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
  it("run 1025 push1 stop", function() {
    return SolidityEVM.deployed().then(function(instance) {
      var code = "6042".repeat(1025);
      return instance.stopReasonRun.call("0x"+code+"00","0x00", {gas: 34359738368});
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 8, "StackOverflow was not the exit opcode");
    });
  });
});
