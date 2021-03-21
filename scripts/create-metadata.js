const Farmernet = artifacts.require('FarmernetLand')
const fs = require('fs')

const metadataTemple = {
    "name": "",
    "description": "",
    "image": "",
    "attributes": [
        {
            "trait_type": "Longitude",
            "value": 0
        },
        {
            "trait_type": "Latitude",
            "value": 0
        },
        {
            "trait_type": "Carbon_emissions",
            "value": 0
        }
    ]
}
module.exports = async callback => {
    const dnd = await Farmernet.deployed()
    length = await dnd.getNumberOfLands()
    index = 0
    while (index < length) {
        console.log('Let\'s get the overview of your Land ' + index + ' of ' + length)
        let LandMetadata = metadataTemple
        let LandOverview = await dnd.Lands(index)
        index++
        LandMetadata['name'] = LandOverview['name']
        if (fs.existsSync('metadata/' + LandMetadata['name'].toLowerCase().replace(/\s/g, '-') + '.json')) {
            console.log('test')
            continue
        }
        console.log(LandMetadata['name'])
        LandMetadata['attributes'][0]['value'] = LandOverview['longitude']['words'][0]
        LandMetadata['attributes'][1]['value'] = LandOverview['latitude']['words'][0]
        LandMetadata['attributes'][2]['value'] = LandOverview['carbon_emission']['words'][0]
        filename = 'metadata/' + LandMetadata['name'].toLowerCase().replace(/\s/g, '-')
        let data = JSON.stringify(LandMetadata)
        fs.writeFileSync(filename + '.json', data)
    }
    callback(dnd)
}
