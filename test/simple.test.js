import { And, Bool, If, IsZero, Or, Prev, Succ, Zero } from '../src/langModel'
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

    it('should parse 0', () => {
      expect(parse('0')).to.deep.equal(Zero)
    })

    it('should parse succ', () => {
      expect(parse('succ(0)')).to.deep.equal(Succ(Zero))
    })

    it('should parse prev', () => {
      expect(parse('prev(0)')).to.deep.equal(Prev(Zero))
    })

    it('should parse isZero', () => {
      expect(parse('isZero(0)')).to.deep.equal(IsZero(Zero))
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

    it('should parse "and"', () => {
      const src = 'and(false, true)'
      const expected = And(Bool(false), Bool(true))

      expect(parse(src)).to.deep.equal(expected)
    })

    it('should parse "or"', () => {
      const src = 'or(false, true)'
      const expected = Or(Bool(false), Bool(true))

      expect(parse(src)).to.deep.equal(expected)
    })

  })

})