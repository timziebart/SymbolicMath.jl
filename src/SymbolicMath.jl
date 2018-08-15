module SymbolicMath

import Base: +, -, *, /, cos, sin, log, exp, abs, real, imag, promote_rule, convert

abstract type AbstractTerm end
struct ExprTerm <: AbstractTerm
    ex
end

macro ExprTerm(ex)
    ExprTerm(ex)
end

function createsymbol(s::Symbol)
    @eval $s = ExprTerm(Symbol($(string(s))))
end

macro symbols(args::Symbol...)
    createsymbol.(args)
end

for op in [:+, :-, :*, :/]
    @eval $op(t1::ExprTerm, t2::ExprTerm) = Expr(:call, Symbol($(string(op))), t1.ex, t2.ex) |> ExprTerm
    @eval $op(t::ExprTerm, n::Number) = Expr(:call, Symbol($(string(op))), t.ex, n) |> ExprTerm
    @eval $op(n::Number, t::ExprTerm) = $op(t, n)
end
for op in [:cos, :sin, :log, :exp, :abs, :real, :imag]
    @eval $op(t::ExprTerm) = Expr(:call, Meta.quot(op), t.ex) |> ExprTerm
end

export @symbols, @ExprTerm, ExprTerm

end # module SymbolicMath
