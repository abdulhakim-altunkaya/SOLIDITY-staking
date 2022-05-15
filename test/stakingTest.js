const StakingTKN = artifacts.require("StakingTKN.sol");

contract("StakingTKN", () => {

    let staking = null;

    before(async () => {
        staking = await StakingTKN.new(500);
    });

    it("should deploy contract properly", async () => {
        console.log(staking.address);
        assert(staking.address !== "");
    });

    it("should return total stakes: 500", async () => {
        const data = await staking.getTotalStakeData();
        assert(data.toString() === "500");
    });

    it("owner is the first stakeholder", async () => {
        const data_owner = await staking.owner();
        const data_firstStakeholder = await staking.getAddress(0);
        assert(data_owner === data_firstStakeholder);
    });

    /*Owner will first deposit 500 as initial token using "constructor". 
    Then Owner will deposit 100 more by using "stake" function.
    In total, owner will have 600 tokens as his/her stake amount. Owner can read this from
    getPersonalStakeData function. */
    it("should stake 500+100", async () => {
        await staking.stake(100);
        const data = await staking.getPersonalStakeData();
        assert(data.toString() === "600");
    });

});

contract("StakingTKN_2", () => {
    /*Owner/First Stakeholder will first deposit 500 as initial token using "constructor". 
    Then Owner will withdraw 100 by using "withdrawStake" function.
    In total, owner will have 400 tokens as his/her stake amount. Owner can read this from
    getPersonalStakeData function. */
    it("should stake 500, withdraw 100", async () => {
        const staking = await StakingTKN.new(500);
        await staking.withdrawStake(100);
        const data = await staking.getPersonalStakeData();
        assert(data.toString() === "400");
    });
});

