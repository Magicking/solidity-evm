var SolidityEVM = artifacts.require("./SolidityEVM.sol");

module.exports = function(deployer) {
  deployer.deploy(SolidityEVM);
};
