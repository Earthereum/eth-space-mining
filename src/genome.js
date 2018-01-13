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
   * @param from start index in bits
   * @param len length in bits
   * @return a list of bits (as 0/1 ints)
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
   * @param from start index in bits
   * @param len length in bits
   * @return a string of bits
   */
  sliceString (from, len) {
    return this.slice(from, len).join('');
  }

  /**
   * Extracts a range of bits from the genome as a number.
   * @param from start index in bits
   * @param len length in bits
   * @return an int
   */
  sliceNumber (from, len) {
    return Number.parseInt(this.sliceString(from, len), 2);
  }

  /**
   * Looks up the value of a particular genotype in this genome.
   * @param genotype the name of the genotype
   * @return the value of the genotype
   */
  lookup (genotype) {
    const {map} = this;
    if (!Object.keys(map).includes(genotype)) {
      throw new Error(`Mapping does not contain an entry for ${genotype}`);
    }

    const mapping = map[genotype];
    if (mapping.type === 'fixed') {
      const [min, max] = mapping.range;
      const val = this.sliceNumber(mapping._pos, mapping.bits) / 2 ** mapping.bits;
      return min + val * (max - min);
    }
    if (mapping.type === 'int') {
      const val = this.sliceNumber(mapping._pos, mapping.bits);
      return val;
    }
    if (mapping.type === 'bool') {
      const val = this.sliceNumber(mapping._pos, mapping.bits);
      return !!val;
    }
    if (mapping.type === 'string') {
      return this.sliceString(mapping._pos, mapping.bits);
    }
    return null;
  }

  /**
   * Prepares a raw genome mapping for use with a GenomeMapper.
   * A mapping is a dictionary of genotype names and their formats.
   * A genome can have one of several types:
   *  * bool - a single bit indicating a boolean value
   *  * int - an arbitrarily-sized int
   *      bits: the size of this int in bits
   *  * fixed - an int that will be mapped to a float over a given range
   *      bits: the size of this fixed number in bits
   *      range: a 2-tuple in the form [min, max]. Defaults to [0,1]
   *  * string - a bitstring
   *      bits: the size of the bitstring
   */
  static createMap (data) {
    let ptr = 0;
    for (let k of Object.keys(data)) {
      const item = data[k];

      // normalize parameters
      if (item.type === 'fixed') {
        if (!item.hasOwnProperty('range')) {
          item.range = [0, 1];
        }
      }
      if (item.type === 'bool') {
        item.bits = 1;
      }

      // make sure there are more genome bits available
      if (ptr + item.bits >= GENOME_LEN) {
        throw new Error(`No more space in genome for key ${k}`);
      }

      // allocate bits
      data[k]._pos = ptr;
      ptr += item.bits;
    }
    return data;
  }
}

export const DEMO_MAPPING = GenomeMapper.createMap({
  'size': {
    'type': 'fixed',
    'bits': 4,
    'range': [0.5, 1]
  },
  'water': {
    'type': 'fixed',
    'bits': 4
  },
  'atmoDensity': {
    'type': 'fixed',
    'bits': 4
  },
  'cloudDensity': {
    'type': 'fixed',
    'bits': 4
  },
  'baseColor': {
    'type': 'int',
    'bits': 24
  },
  'accColor': {
    'type': 'int',
    'bits': 24
  },
  'numTerrains': {
    'type': 'fixed',
    'bits': 2,
    'range': [2, 6]
  },
  'ring': {
    'type': 'bool'
  }
});
