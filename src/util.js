
export async function processGenome (id) {
  let genome = await getGenome(id);

  console.log('Genome: ' + genome.toString(16));

  return {
    title: 'Planet ' + id,
    traits: {
      'seed': computeSeed(genome),
      'size': computeSize(genome),
      'water': computeWater(genome),
      'atmoDensity': computeAtmoDensity(genome),
      'cloudDensity': computeCloudDensity(genome),
      'baseColor': computeBaseColor(genome),
      'accColor': computeAccColor(genome),
      'numTerrains': computeNumTerrains(genome)
    },
    price: computePrice(),
    link: '/planet/' + id,
    id: id
  }
}

async function getGenome (id) {
  const coreInstance = await window.contracts.Core.deployed();
  let planetResult = await coreInstance.getPlanet.call(id);
  return planetResult[5];
}

function computeSeed (genome) {
  return genome.modulo(0x10000).toNumber();
}

function computeSize (genome) {
  let multiplier = genome.shift(10).modulo(0x10000).div(0x10000).toNumber();
  return (multiplier * 0.4) + 0.4;
}

function computeWater (genome) {
  return genome.shift(8).modulo(0x10000).div(0x10000).toNumber();
}

function computeAtmoDensity (genome) {
  return genome.shift(6).modulo(0x10000).div(0x10000).toNumber();
}

function computeCloudDensity (genome) {
  return genome.shift(4).modulo(0x10000).div(0x10000).toNumber();
}

function computeBaseColor (genome) {
  return genome.shift(10).modulo(0x1000000).toNumber();
}

function computeAccColor (genome) {
  return genome.shift(4).modulo(0x1000000).toNumber();
}

function computeNumTerrains (genome) {
  return Math.ceil(Math.random() * 4);
}

function computePrice () {
  return Math.ceil(Math.random() * 10000) / 10000;
}
