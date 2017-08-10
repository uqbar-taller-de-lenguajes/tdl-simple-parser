export const Bool = (value) => ({ type: 'bool', value })
export const If = (condition, thenExpression, elseExpression) => ({ type: 'if', condition, thenExpression, elseExpression })
export const And = (left, right) => ({ type: 'and', left, right })
export const Or = (left, right) => ({ type: 'or', left, right })

export const Zero = { type: 'zero' }
export const Succ = (value) => ({ type: 'succ', value })
export const Prev = (value) => ({ type: 'prev', value })
export const IsZero = (value) => ({ type: 'iszero', value })