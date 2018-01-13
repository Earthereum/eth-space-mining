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
    if (mapping.type === 'float') {
      const val = this.sliceNumber(mapping._pos, mapping.len) / 2 ** mapping.len;
      return mapping.min + val * (mapping.max - mapping.min);
    }
    if (mapping.type === 'int') {
      const val = this.sliceNumber(mapping._pos, mapping.len);
      return val;
    }
    if (mapping.type === 'string') {
      return this.sliceString(mapping._pos, mapping.len);
    }
    return null;
  }

  /**
   * Augments a genome mapping with position values, etc
   */
  static createMap (data) {
    let ptr = 0;
    for (let k of Object.keys(data)) {
      const item = data[k];

      // make sure there are more genome bits available
      if (ptr + item.len >= GENOME_LEN) {
        throw new Error(`No more space in genome for key ${k}`);
      }

      // normalize parameters
      if (item.type === 'float') {
        GenomeMapper._fixFloatMapping(item);
      }
      if (item.type === 'int') {
        GenomeMapper._fixIntMapping(item);
      }

      // allocate bits
      data[k]._pos = ptr;
      ptr += item.len;
    }
    return data;
  }

  static _fixFloatMapping (item) {
    if (item.hasOwnProperty('max')) {
      if (!item.hasOwnProperty('min')) {
        item.min = 0;
      }
    } else {
      item.max = 1;
      item.min = 0;
    }
  }

  static _fixIntMapping (item) {

  }
}

export const DEMO_MAPPING = GenomeMapper.createMap({
  'size': {
    'type': 'float',
    'len': 4,
    'min': 0.5,
    'max': 1.0
  },
  'water': {
    'type': 'float',
    'len': 4
  },
  'atmoDensity': {
    'type': 'float',
    'len': 4
  },
  'cloudDensity': {
    'type': 'float',
    'len': 4
  },
  'baseColor': {
    'type': 'int',
    'len': 24
  },
  'accColor': {
    'type': 'int',
    'len': 24
  },
  'numTerrains': {
    'type': 'float',
    'len': 2,
    'min': 2,
    'max': 6
  }
});
