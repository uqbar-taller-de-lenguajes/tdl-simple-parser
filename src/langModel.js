export const Bool = (value) => ({ type: 'bool', value })
export const If = (condition, thenExpression, elseExpression) => ({ type: 'if', condition, thenExpression, elseExpression })