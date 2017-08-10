import { describe, it } from 'mocha'

import { expect } from 'chai'
import parser from '../src/parser'

describe('xml parser', () => {

  describe('tag', () => {

    const parse = text => parser(text, { startRule: 'xmlTag' })

    it('should parse contentless tags with no attributes', () => {
      expect(parse('<foo/>')).to.deep.equal({ type: 'foo' })
    })

    it('should parse contentless tags with attributes', () => {
      expect(parse('<foo bar="5"/>')).to.deep.equal({ type: 'foo', bar: '5' })
    })

    it('should parse contentfull empty tags with no attributes', () => {
      expect(parse('<foo></foo>')).to.deep.equal({ type: 'foo', content: [] })
    })

    it('should parse contentfull empty tags with attributes', () => {
      expect(parse('<foo bar="5"></foo>')).to.deep.equal({ type: 'foo', bar: '5', content: [] })
    })

    it('should parse contentfull tags with text content', () => {
      expect(parse('<foo>bar</foo>')).to.deep.equal({ type: 'foo', content: ['bar'] })
    })

    it('should parse contentfull tags with nested tag content', () => {
      expect(parse('<foo><bar/><bar/></foo>')).to.deep.equal({ type: 'foo', content: [{ type: 'bar' }, { type: 'bar' }] })
    })

    it('should fail for unclosed contentfull tags', () => {
      expect(() => parse('<foo>')).to.throw()
    })

    it('should fail for unopened contentfull tags', () => {
      expect(() => parse('</foo>')).to.throw()
    })

    it('should fail for wrongly closed contentfull tags', () => {
      expect(() => parse('<foo><foo/>')).to.throw()
      expect(() => parse('<foo></bar>')).to.throw()
      expect(() => parse('<foo><bar></foo></bar>')).to.throw()
    })

  })

})