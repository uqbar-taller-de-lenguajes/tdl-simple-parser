{
  const joinReplacingSeparator = (list, newSeparator) => list.map( ([,elem]) => newSeparator + elem ).join('')

  const { assign } = Object
  const { parseFloat } = Number

  const path = require('path')
  const { Bool, If, And, Or, Zero, Succ, Prev, IsZero } = require(path.resolve('src/langModel.js'))
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

_ = __?
__ = [ \t\r\n]+

json = jsonHash
jsonValue = jsonHash
          / jsonString
          / jsonNumber
          / jsonBool
          / jsonArray
jsonHash = '{' _ entries:( entry (_','_ entry)* )? _ '}' { return (entries ? [entries[0], ...entries[1].map(([,,,entry]) => entry )] : []).reduce((obj, [key,value]) => assign(obj,{[key]: value}), {}) }
entry = key:jsonString _ ':' _ value:jsonValue {return [key, value]}
jsonString = '"' chars:[^"]* '"' { return chars.join('') }
jsonNumber = negated:'-'? whole:[0-9]+ decimals:('.'[0-9]+)? { return parseFloat( (negated||'') + whole.join('') + (decimals ? '.' + decimals[1].join('') : '') ) }
jsonBool = value:('true' / 'false') { return value === 'true' }
jsonArray = '[' _ values:( jsonValue ( _ ',' _ jsonValue )* )? _ ']' { return values ? [values[0], ...values[1].map( ([,,,value]) => value )] : [] }

// ----------------------------------------------------------------------------------------------------------------------
// XML
// ----------------------------------------------------------------------------------------------------------------------

xml = xmlTag
xmlTag = '<' _ name:xmlId _ attributes:xmlAttribute* '/>' { return assign({type: name}, ...attributes) }
       / '<' _ name:xmlId _ attributes:xmlAttribute* '>' _ content: xmlContent* _ '</' _ closeName:xmlId _ '>' & { return name === closeName } { return assign({type: name, content }, ...attributes) }
xmlId = id:[^ !"#$%&'()*+,/;<=>?@[\]^`{|}~]+ { return id.join('') }
xmlAttribute = _ key:xmlId _ '=' _ '"' _ value:[^"<]* _ '"' _ {return {[key]: value.join('')}}
xmlContent = xmlTag
           / text:[^</>]+ { return text.join('') }

// ----------------------------------------------------------------------------------------------------------------------
// SIMPLE LANGUAGE
// ----------------------------------------------------------------------------------------------------------------------

lang = expression

expression = 'if ' _ condition:expression _ 'then' _ thenExpression:expression _ 'else' _ elseExpression:expression { return If(condition,thenExpression,elseExpression) }
           / 'isZero' _ value:expression { return IsZero(value) }
           / value

value = booleanValue
      / numericValue

booleanValue = value:('true' / 'false') { return Bool(value === 'true') }

numericValue = '0' { return Zero }
             / 'succ' _ value:expression { return Succ(value) }
             / 'prev' _ value:expression { return Prev(value) }