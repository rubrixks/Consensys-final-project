var TheGame = artifacts.require("TheGame.sol");

module.exports =function(deployer) {
    deployer.deploy(TheGame);
}