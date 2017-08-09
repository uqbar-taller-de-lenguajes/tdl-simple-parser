import { describe, it } from 'mocha'

import { expect } from 'chai'
import parser from '../src/parser'

describe('json parser', () => {

  describe('number', () => {

    const parse = text => parser(text, { startRule: 'jsonNumber' })

    it('should parse round numbers', () => {
      expect(parse('5')).to.equal(5)
    })

    it('should parse non-round numbers', () => {
      expect(parse('5.1')).to.equal(5.1)
    })

    it('should fail for non-round numbers without decimal part', () => {
      expect(() => parse('5.')).to.throw()
    })

  })

  describe('string', () => {

    const parse = text => parser(text, { startRule: 'jsonString' })

    it('should parse empty strings', () => {
      expect(parse('""')).to.equal('')
    })

    it('should parse non-empty strings', () => {
      expect(parse('"foo"')).to.equal('foo')
    })

    // DISCUSSION: Are these next two tests necessary?
    it('should fail for unclosed strings', () => {
      expect(() => parse('"foo')).to.throw()
    })

    it('should fail for unopened strings', () => {
      expect(() => parse('foo"')).to.throw()
    })

  })

  describe('hash', () => {

    const parse = text => parser(text, { startRule: 'jsonHash' })

    it('should parse empty hashes', () => {
      expect(parse('{}')).to.deep.equal({})
    })

    it('should parse non-empty hashes', () => {
      expect(parse('{"foo": "bar"}')).to.deep.equal({ foo: 'bar' })
    })

    it('should parse nested hashes', () => {
      expect(parse('{"foo": {"bar": 5}}')).to.deep.equal({ foo: { bar: 5 } })
    })

    it('should fail for unclosed hashes', () => {
      expect(() => parse('{"foo": "bar"')).to.throw()
    })

    it('should fail for unopened hashes', () => {
      expect(() => parse('"foo": "bar"}')).to.throw()
    })

    it('should fail for non-string keys', () => {
      expect(() => parse('foo: "bar"}')).to.throw()
    })

  })

})