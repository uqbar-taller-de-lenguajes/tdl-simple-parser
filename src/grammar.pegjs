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

// DISCUSSION: Lexer, spaces and tests
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

// // EXERCISE: Extend the parser and model to include {0, isZero, succ, prev}