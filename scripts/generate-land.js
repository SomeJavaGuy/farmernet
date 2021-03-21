const Farmernet = artifacts.require('FarmernetLand')

module.exports = async callback => {
  const dnd = await Farmernet.deployed()
  console.log('Creating requests on contract:', dnd.address)
  const tx = await dnd.requestNewRandomLand(77, "farmland1")
  const tx2 = await dnd.requestNewRandomLand(7777777, "farmland2")
  const tx3 = await dnd.requestNewRandomLand(7, "farmland3")
  callback(tx.tx)
}
