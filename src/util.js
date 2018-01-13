import {GenomeMapper, DEMO_MAPPING} from './genome.js';

export async function processGenome (id) {
  let planet = await getPlanet(id);
  let genome = planet.genome;

  console.log('Genome: ' + genome.toString(16));

  const mapper = new GenomeMapper(genome, DEMO_MAPPING);

  return {
    title: 'Planet ' + id,
    traits: {
      'seed': mapper.sliceNumber(0, 32),
      'size': mapper.lookup('size') / (2 ** 4 * 2) + 0.5,
      'water': mapper.lookup('water') / 2 ** 4,
      'atmoDensity': mapper.lookup('atmoDensity') / 2 ** 4,
      'cloudDensity': mapper.lookup('cloudDensity') / 2 ** 4,
      'baseColor': mapper.lookup('baseColor').toString(16),
      'accColor': mapper.lookup('accColor').toString(16),
      'numTerrains': mapper.lookup('numTerrains') + 2
    },
    price: computePrice(),
    link: '/planet/' + id,
    id: id
  }
}

async function getPlanet (id) {
  const coreInstance = await window.contracts.Core.deployed();
  let planetResult = await coreInstance.getPlanet.call(id);
  return {
    genome: planetResult[5]
  };
}

function computePrice () {
  return Math.ceil(Math.random() * 10000) / 10000;
}
