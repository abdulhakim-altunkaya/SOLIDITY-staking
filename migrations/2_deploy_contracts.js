const StakingTKN = artifacts.require("StakingTKN");

module.exports = function (deployer) {
  deployer.deploy(StakingTKN, 500);
};
