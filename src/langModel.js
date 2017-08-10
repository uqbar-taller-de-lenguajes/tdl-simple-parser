export const Bool = (value) => ({ type: 'bool', value })
export const If = (condition, thenExpression, elseExpression) => ({ type: 'if', condition, thenExpression, elseExpression })
export const And = (left, right) => ({ type: 'and', left, right })
export const Or = (left, right) => ({ type: 'or', left, right })