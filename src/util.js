
export async function processGenome (id) {
  let genome = await getGenome(id);

  console.log('Genome: ' + genome.toString(16));

  return {
    title: 'Planet ' + id,
    traits: {
      'seed': genome.modulo(0x10000).toNumber(),
      'size': Math.random(),
      'water': Math.random(),
      'atmoDensity': Math.random(),
      'cloudDensity': Math.random(),
      'baseColor': genome.shift(10).modulo(0x1000000).toString(16),
      'accColor': genome.shift(4).modulo(0x1000000).toString(16),
      'numTerrains': Math.ceil(Math.random() * 4)
    },
    price: Math.random(),
    link: '/planet/' + id,
    id: id
  }
}

async function getGenome (id) {
  const coreInstance = await window.contracts.Core.deployed();
  let planetResult = await coreInstance.getPlanet.call(id);
  return planetResult[5];
}
