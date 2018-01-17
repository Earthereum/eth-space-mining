import {GenomeMapper, DEMO_MAPPING} from './genome.js';

export async function processGenome (id) {
  let planet = await getPlanet(id);
  let genome = planet.genome;

  console.log('Genome: ' + genome.toString(16));

  const mapper = new GenomeMapper(genome, DEMO_MAPPING);

  return {
    title: `${computeTitle(genome)} ${id}`,
    traits: {
      'seed': mapper.sliceNumber(0, 32),
      'size': mapper.lookup('size'),
      'water': mapper.lookup('water'),
      'atmoDensity': mapper.lookup('atmoDensity'),
      'cloudDensity': mapper.lookup('cloudDensity'),
      'baseColor': mapper.lookup('baseColor').toString(16).padStart(6, '0'),
      'accColor': mapper.lookup('accColor').toString(16).padStart(6, '0'),
      'numTerrains': mapper.lookup('numTerrains'),
      'ring': mapper.lookup('ring')
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

function computeTitle (genome) {
  const consonants = 'bcdfghjklmnpqrstvwxz'.split('');
  const vowels = 'aeiouy'.split('');

  const mapping = {
    'n': {
      'type': 'fixed',
      'bits': 2,
      'range': [2, 6]
    }
  };
  for (let i = 0; i < 6; i++) {
    mapping['c' + i] = {
      'type': 'fixed',
      'bits': 6
    };
    mapping['v' + i] = {
      'type': 'fixed',
      'bits': 3
    };
  }

  const mapper = new GenomeMapper(genome, GenomeMapper.createMap(mapping));

  let title = [];
  for (let i = 0, max = mapper.lookup('n'); i < max; i++) {
    const c = consonants[Math.floor(mapper.lookup('c' + i) * consonants.length)];
    const v = vowels[Math.floor(mapper.lookup('v' + i) * vowels.length)];
    title.push(c);
    title.push(v);
  }
  let str = title[0].toUpperCase() + title.slice(1).join('');
  return str;
}
