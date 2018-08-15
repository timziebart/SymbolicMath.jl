module SymbolicMath

import Base: +, -, *, /, cos, sin, log, exp, abs, real, imag

abstract type AbstractTerm end
struct ExprTerm <: AbstractTerm
    ex
end

macro ExprTerm(ex)
    ExprTerm(ex)
end

for op in [:+, :-, :*, :/]
    @eval $op(t1::ExprTerm, t2::ExprTerm) = Expr(:call, Symbol($(string(op))), t1.ex, t2.ex) |> ExprTerm
end
for op in [:cos, :sin, :log, :exp, :abs, :real, :imag]
    @eval $op(t::ExprTerm) = Expr(:call, Symbol($(string(op))), t.ex) |> ExprTerm
end

export @ExprTerm, ExprTerm

end # module SymbolicMath
