const fs = require('fs')
const HDWalletProvider = require("truffle-hdwallet-provider")

const MNEMONIC = fs.readFileSync('./mnemonic.txt', 'utf8')
const INFURA_API_KEY = fs.readFileSync('./infura.txt', 'utf8')

/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider('tail mimic satisfy bicycle steak electric taxi marine electric frame canal seed', "https://ropsten.infura.io/v3/" + INFURA_API_KEY)
      },
      network_id: 4,
      gas: 8000000,
      gasPrice: 20e9
    }
  }
};
