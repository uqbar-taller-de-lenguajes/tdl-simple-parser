{
  const joinReplacingSeparator = (list, newSeparator) => list.map( ([,elem]) => newSeparator + elem ).join('')

  const { assign } = Object
  const { parseFloat } = Number

  const path = require('path')
  const { Bool, If } = require(path.resolve('src/langModel.js'))
}


// ----------------------------------------------------------------------------------------------------------------------
// MORSE CODE
// ----------------------------------------------------------------------------------------------------------------------

morse = morsePhrase

morsePhrase = head:morseWord tail:('     ' morseWord)* { return head + joinReplacingSeparator(tail, ' ') }

morseWord = head:morseChar tail:(' ' morseChar)* { return head + joinReplacingSeparator(tail, '') }

morseChar = '.....'  { return '5' }
          / '....-'  { return '4' }
          / '....'   { return 'H' }
          / '...--'  { return '3' }
          / '...-'   { return 'V' }
          / '...'    { return 'S' }
          / '..---'  { return '2' }	
          / '..-.'   { return 'F' }
          / '..--..' { return '?' }
          / '..-'    { return 'U' }
          / '..'     { return 'I' }	
          / '.----'  { return '1' }
          / '.---'   { return 'J' }
          / '.-..'   { return 'L' }
          / '.-.-.-' { return '.' }
          / '.-.'    { return 'R' }
          / '.--.'   { return 'P' }
          / '.--'    { return 'W' }
          / '.-'     { return 'A' }
          / '.'      { return 'E' }
          / '-....'  { return '6' }
          / '-...-'  { return '=' }
          / '-...'   { return 'B' }
          / '-..-'   { return 'X' }
          / '-..'    { return 'D' }
          / '-.-.'   { return 'C' }
          / '-.--'   { return 'Y' }
          / '-.-'    { return 'K' }	
          / '-.'     { return 'N' }
          / '-----'  { return '0' }
          / '----.'  { return '9' }
          / '---..'  { return '8' }
          / '---'    { return 'O' }	
          / '--...'  { return '7' }
          / '--..--' { return ',' }
          / '--..'   { return 'Z' }
          / '--.-'   { return 'Q' }
          / '--.'    { return 'G' }	
          / '--'     { return 'M' }	
          / '-'      { return 'T' }

morseCharV2 = cs:[.-]+ {
  switch(cs.join('')) {
    case '.-'     : return 'A'
    case '-...'   : return 'B'
    case '-.-.'   : return 'C'
    case '-..'    : return 'D'
    case '.'      : return 'E'
    case '..-.'   : return 'F'
    case '--.'    : return 'G'	
    case '....'   : return 'H'
    case '..'     : return 'I'	
    case '.---'   : return 'J'
    case '-.-'    : return 'K'	
    case '.-..'   : return 'L'
    case '--'     : return 'M'	
    case '-.'     : return 'N'
    case '---'    : return 'O'	
    case '.--.'   : return 'P'
    case '--.-'   : return 'Q'
    case '.-.'    : return 'R'
    case '...'    : return 'S'
    case '-'      : return 'T'
    case '..-'    : return 'U'
    case '...-'   : return 'V'
    case '.--'    : return 'W'
    case '-..-'   : return 'X'
    case '-.--'   : return 'Y'
    case '--..'   : return 'Z'
    case '-----'  : return '0'
    case '.----'  : return '1'
    case '..---'  : return '2'	
    case '...--'  : return '3'
    case '....-'  : return '4'
    case '.....'  : return '5'
    case '-....'  : return '6'
    case '--...'  : return '7'
    case '---..'  : return '8'
    case '----.'  : return '9'
    case '..--..' : return '?'
    case '.-.-.-' : return '.'
    case '--..--' : return ','
    case '-...-'  : return '='
    default: throw new Error(`bulshit character: ${cs}`) // Having to fail the parse here is not really a good idea...
  }
}

// ----------------------------------------------------------------------------------------------------------------------
// JSON
// ----------------------------------------------------------------------------------------------------------------------

json = jsonHash
jsonValue = jsonHash
          / jsonString
          / jsonNumber
jsonHash = '{' entries:(jsonString ': ' jsonValue)* '}' { return entries.reduce((obj, [key,,value]) => assign(obj,{[key]: value}), {}) }
jsonString = '"' chars:[^"]* '"' { return chars.join('') }
jsonNumber = negated:'-'? whole:[0-9]+ decimals:('.'[0-9]+)? { return parseFloat( (negated||'') + whole.join('') + (decimals ? '.' + decimals[1].join('') : '') ) }

// DISCUSSION: Testing: Check the json.test.js file.
// DISCUSSION: Lexer & spaces: Does this grammar properly describe the sintax? (think about enters and spaces) Should this be reflected on the tests?
// DISCUSSION: Hash definition and commas: This grammar is not completely well formed. What's missing? How do we cover this on the tests?

// TODO: Add Booleans and Arrays

// EXERCISE: Make a parser for XML that parses to the same model.

// // ----------------------------------------------------------------------------------------------------------------------
// // SIMPLE LANGUAGE
// // ----------------------------------------------------------------------------------------------------------------------

lang = expression
expression = 'true'  { return Bool(true) }
           / 'false' { return Bool(false) }
           / 'if ' condition:expression ' then ' thenExpression:expression ' else ' elseExpression:expression { return If(condition,thenExpression,elseExpression) }

// // TODO: Add {or, and, not}

// // TODO: Extend the parser and model to include {0, isZero, succ, prev}