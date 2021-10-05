const Tether = artifacts.require('Tether')
const RWD = artifacts.require('RWD')
const DecentralBank = artifacts.require('DecentralBank')

//brought in the required library for testing
require('chai')
.use(require("chai-as-promised"))
.should()

contract('DecentralBank', ([owner, customer]) => {
    //All the code goes here for testing
    
    let tokens = number => web3.utils.toWei(number, 'ether')

    let tether, rwd, decentralBank
    //this function will be executed before all the tests/descriptions
    before(async () => {
        //Load Contracts
        tether = await Tether.new()
        rwd = await RWD.new()
        decentralBank = await DecentralBank.new(rwd.address, tether.address)

        //transfer all tokens to DecentralBank (1 million token)
        await rwd.transfer(decentralBank.address, tokens('1000000'))

        //Transfer 100 Tethers to Customer ... {from: } param is used to indicate the msg.sender account who is gonna execute transfer function
        await tether.transfer(customer, tokens('100'), {from: owner})
    })
    
    describe('Tether Token Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await tether.name()
            assert.equal(name, "Tether")
        })
    })
   
    describe('RWD Token Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await rwd.name()
            assert.equal(name, "Reward Token")
        })
    })

    describe('Decentral Bank Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await decentralBank.name()
            assert.equal(name, "Decentral Bank")
        })

        it('contract has tokens', async () => {
            let balance = await rwd.balanceOf(decentralBank.address)
            assert.equal(balance, tokens('1000000'))
        })
    })
 
})