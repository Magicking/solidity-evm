var SolidityEVM = artifacts.require("./SolidityEVM.sol");

contract('SolidityEVM', function(accounts) {
  it("run stop opcode", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call("0x006042","0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
  it("run push1 opcode", function() {
    return SolidityEVM.deployed().then(function(instance) {
      return instance.stopReasonRun.call("0x006042","0x00");
    }).then(function(ret) {
      assert.equal(ret.valueOf(), 1, "Halt was not the exit opcode");
    });
  });
});
