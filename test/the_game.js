const TheGame = artifacts.require("TheGame");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TheGame", function ( accounts ) {
  it("should assert true", async function () {
    await TheGame.deployed();
    return assert.isTrue(true);
  });
  it("The GameStart is false", async () => {
    var instance = await TheGame.deployed();
    var hasGameStarted = await instance.GameStarts();
    assert.equal(hasGameStarted,false,`GameStart is equal to ${hasGameStarted}`);
  });
  it("The total amount of Losses minted should be 0", async () => {
    var instance = await TheGame.deployed();
    var amountOfLosses= await instance.mintedLosses();
    assert.equal(amountOfLosses,0,`amount of losses minted is ${amountOfLosses}`);
  });
  describe("Functionality", async () => {
    it ("Only owner can call firstLoser and game begins.", async () => {
      var instance = await TheGame.deployed();
      try {
        await instance.firstLoser({from:accounts[1], value: web3.utils.toWei(".0025")});
      } catch(err) {};

      await instance.firstLoser({from:accounts[0], value: web3.utils.toWei(".0025")});
      var hasGameStarted = await instance.GameStarts();
      var numOfLosses = await instance.lossFinder(accounts[0]);
      assert.equal(numOfLosses,10,"amount of losses minted should be 10");
      assert.equal(hasGameStarted,true,`GameStart is equal to ${hasGameStarted}`);
    });
    it ("Minted NFT's URI is baseURI",async () => {
      var instance = await TheGame.deployed();
      await instance.firstLoser({from:accounts[0], value: web3.utils.toWei(".0025")});
      for (var i =1; i<=10; i++) {
        assert(instance.tokenURI(i),instance.baseURI());
      }
    });
    it ("Owner withdraws amount needed to mint first 10 NFTs", async () => {
      var instance = await TheGame.deployed();
    
      let balance = await web3.eth.getBalance(instance.address);
      
      await instance.firstLoser({from:accounts[0], value: web3.utils.toWei(".0025")});
      balance = await web3.eth.getBalance(instance.address);
      await instance.withdraw({from:accounts[0]});
      balance = await web3.eth.getBalance(instance.address);
      assert.equal(balance,0,"There should be no money in the account");
    });
  });


});
