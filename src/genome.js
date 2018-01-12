export const GENOME_LEN = 256;

export class GenomeMapper {
  constructor (genome, map) {
    this.genome = genome;
    this.map = map;
    this.bitList = this.genome.toString(2).padStart(GENOME_LEN, 0).split('')
      .map(c => Number.parseInt(c));
  }

  /**
   * Extracts a range of bits from the genome as a list.
   */
  slice (from, len) {
    if (from < 0 || from >= GENOME_LEN) {
      throw new Error(`from index ${from} is out of bounds`);
    }
    if (len < 0 || from + len >= GENOME_LEN) {
      throw new Error(`len ${len} starting at ${from} is out of bounds`);
    }

    return this.bitList.slice(from, from + len);
  }

  /**
   * Extracts a range of bits from the genome as a string.
   */
  sliceString (from, len) {
    return this.slice(from, len).join('');
  }

  /**
   * Extracts a range of bits from the genome as a number.
   */
  sliceNumber (from, len) {
    return Number.parseInt(this.sliceString(from, len), 2);
  }

  /**
   * Looks up the value of a particular genotype in this genome.
   */
  lookup (genotype) {
    const {map} = this;
    if (!Object.keys(map).includes(genotype)) {
      throw new Error(`Mapping does not contain an entry for ${genotype}`);
    }

    const mapping = map[genotype];
    if (mapping.type === 'number') {
      return this.sliceNumber(mapping._pos, mapping.len);
    }
    if (mapping.type === 'string') {
      return this.sliceString(mapping._pos, mapping.len);
    }
    return null;
  }

  /**
   * Augments a genome mapping with position values.
   */
  static createMap (data) {
    let ptr = 0;
    for (let k of Object.keys(data)) {
      const len = data[k].len;
      if (ptr + len >= GENOME_LEN) {
        throw new Error(`No more space in genome for key ${k}`);
      }
      data[k]._pos = ptr;
      ptr += len;
    }
    return data;
  }
}

export const DEMO_MAPPING = GenomeMapper.createMap({
  'size': {
    'type': 'number',
    'len': 4
  },
  'water': {
    'type': 'number',
    'len': 4
  },
  'atmoDensity': {
    'type': 'number',
    'len': 4
  },
  'cloudDensity': {
    'type': 'number',
    'len': 4
  },
  'baseColor': {
    'type': 'number',
    'len': 24
  },
  'accColor': {
    'type': 'number',
    'len': 24
  },
  'numTerrains': {
    'type': 'number',
    'len': 2
  }
});
