import { Bool, If } from '../src/langModel'
import { describe, it } from 'mocha'

import { expect } from 'chai'
import parser from '../src/parser'

describe('simple language parser', () => {

  describe('expression', () => {

    const parse = text => parser(text, { startRule: 'expression' })

    it('should parse booleans as a boolean values', () => {
      expect(parse('true')).to.deep.equal(Bool(true))
      expect(parse('false')).to.deep.equal(Bool(false))
    })

    it('should parse if-then-else', () => {
      const src = 'if true then true else false'
      const expected = If(Bool(true), Bool(true), Bool(false))

      expect(parse(src)).to.deep.equal(expected)
    })

    it('should parse nested if-then-else', () => {
      const src = 'if if true then true else true then if true then true else false else if false then false else true'
      const expected = If(
        If(Bool(true), Bool(true), Bool(true)),
        If(Bool(true), Bool(true), Bool(false)),
        If(Bool(false), Bool(false), Bool(true)),
      )

      expect(parse(src)).to.deep.equal(expected)
    })

  })

})