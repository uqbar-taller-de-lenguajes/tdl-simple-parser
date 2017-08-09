import { describe, it } from 'mocha'

import { expect } from 'chai'
import parser from '../src/parser'

// PARSER TESTING GOLDEN RULES:
// 1) Coverage!
// 2) Don't over do it: You have to maintain this thing... Test are programs too, threat them so.
// 3) Be clear about what each case is testing, don't just massively repeat scenarios you know should work.
// 4) Don't overlap tests (if it can be avoided).
// 5) If someone else does it, don't test it.
// 6) Test what should NOT be parsed too.
// 7) Invest in assertion and building logic for your model: The tests tells you how your model will likely be used.

describe('morse parser', () => {

  describe('bad testing approach', () => {

    it('works!', () => {
      const morse = '- .... .     --.- ..- .. -.-. -.-     -... .-. --- .-- -.     ..-. --- -..-     .--- ..- -- .--. ...     --- ...- . .-.     .-     .-.. .- --.. -.--     -.. --- --. .-.-.-'
      const translated = 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOG.'

      expect(parser(morse, { startRule: 'morse' })).to.deep.equal(translated)

      // Why this test approach is bad:
      // - It feels good to test a "real" use scenarios, but it is often very complex and repetitive.
      // - The test description is bulshit. If this starts to fail you have no idea what got broken.
      // - If the above test fails, it gets hard to track the issue: Is the morse phrase wrong or is there a problem with the parser?
      // - Even if it looks like it covers everything, numbers and symbols have been left out.
      // - If the representation of a letter (or a separator) changes, updating the test cases would be a nightmare.
      // - If the model changes (for example, if we represent letters in lowcase), updating the test cases would be a nightmare.
      // - We are only testing the top-level parser. Even if the user may only use this, it's harder to track errors on sub-components.
    })

    it('fails!', () => {
      //What? Why does this have to fail??? 
      expect(() => parser('...  ---  ...', { startRule: 'morse' })).to.throw()
    })

  })

  describe('a better approach', () => {

    // IMPROVEMENT: Testing each sub-component of the parser separately.
    describe('morse characters', () => {

      // IMPROVEMENT: Extracting common operations shortens the tests and makes them easier to read.
      const parse = text => parser(text, { startRule: 'morseChar' })

      // This could be read from a separate file to ease lecture.
      const fixture = {
        A: '.-',
        B: '-...',
        C: '-.-.',
        D: '-..',
        E: '.',
        F: '..-.',
        G: '--.',
        H: '....',
        I: '..',
        J: '.---',
        K: '-.-',
        L: '.-..',
        M: '--',
        N: '-.',
        O: '---',
        P: '.--.',
        Q: '--.-',
        R: '.-.',
        S: '...',
        T: '-',
        U: '..-',
        V: '...-',
        W: '.--',
        X: '-..-',
        Y: '-.--',
        Z: '--..',
        0: '-----',
        1: '.----',
        2: '..---',
        3: '...--',
        4: '....-',
        5: '.....',
        6: '-....',
        7: '--...',
        8: '---..',
        9: '----.',
        '.': '.-.-.-',
        ',': '--..--',
        '?': '..--..',
        '=': '-...-'
      }

      for (const key in fixture) {
        // IMPROVEMENTS:
        // - Now each test clearly describes what is testing: If it fails you know what is wrong.
        // - Now we are covering all cases, no need to think sentences with numbers and symbols.
        // - Testing only once each char reduces the overlap and speeds up the test execution.
        // - If either the syntax or the model changes, we only need to update one place.
        it(`the "${key}" character should be parsed from ${fixture[key]}`, () => expect(parse(fixture[key])).to.equal(key))
      }

      // We could also add some well known cases that should fail, but there is no point in adding test that fail for random shit.
    })

    describe('morse word', () => {
      const parse = text => parser(text, { startRule: 'morseWord' })

      it('parses a single character', () => {
        // No need to check all characters, that's what the character tests are for. Keep it short.
        expect(parse('...')).to.equal('S')
      })

      it('parses several characters separated by space', () => {
        expect(parse('... --- ...')).to.equal('SOS')
      })

      it('fails for empty input', () => {
        expect(() => parse('')).to.throw()
      })

      it('fails for 2 space separator', () => {
        // Ooh, so that was the problem...
        expect(() => parse('...  ---  ...')).to.throw()
      })
    })

    describe('morse phrase', () => {
      const parse = text => parser(text, { startRule: 'morsePhrase' })

      it('parses a single word', () => {
        // No need to use complex words, that's what the word tests are for. Keep it simple.
        expect(parse('... --- ...')).to.equal('SOS')
      })

      it('parses several words separated by 5 spaces', () => {
        expect(parse('...     ---     ...')).to.equal('S O S')
      })

      it('fails for empty input', () => {
        expect(() => parse('')).to.throw()
      })

      it('fails for 4 space separator', () => {
        expect(() => parse('...    ---    ...')).to.throw()
      })

    })

    // We should try to avoid massive tests that take too long to update after a model change.
    // Once the whole language pipeline is done we can add some bulkier integration tests, that go from parsing to execution,
    // to ensure each section yields what the previous expects.

    // Since morse is not a program language there is no point in storing much metadata in the model.
    // For a real PL we should be adding references to the start and end position of each node on the original source.
    // There is no point in testing that metadata if it is generated automatically (unless you are the one generating it...).
    // If you need to test that, it is convenient to do so in a separate set of tests, to avoid polluting the parse tests.

    // In the future, each time we detect a bug, we should:
    // - Add a test that reproduces the case with the smallest possible context and a clear description (NOT test for bug #145!).
    // - Let that test fail to make sure we got the scenario right.
    // - Fix the bug and leave the green test for the future.

  })

})