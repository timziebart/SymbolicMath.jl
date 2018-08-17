module SymbolicMath

import Base: +, -, *, /, ^, cos, sin, log, exp, abs, real, imag, convert
import Base.==

abstract type AbstractTerm end
struct ExprTerm <: AbstractTerm
    ex
end
convert(::Type{ExprTerm}, ex) = ExprTerm(ex)

macro ExprTerm(ex)
    ExprTerm(ex)
end

function createsymbol(s::Symbol, m::Module)
    @eval m $s = $(Meta.quot(s)) |> ExprTerm
end
function createsymbol(s::Symbol)
    createsymbol(s, Main)
end

macro symbols(args::Symbol...)
    createsymbol.(args, Ref(__module__))
end
macro symbol(s::Symbol)
    createsymbol(s, __module__)
end


# euqality comparison
==(t1::ExprTerm, t2::ExprTerm) = (t1.ex == t2.ex)
==(t::ExprTerm, other) = (t.ex == other)
==(other, t::ExprTerm) = (t == other)

# operator definitions
binary_opeators = [:+, :-, :*, :/, :^]
unary_operators = [:cos, :sin, :log, :exp, :abs, :real, :imag]

for op in binary_opeators
    @eval $op(t1::ExprTerm, t2::ExprTerm) = Expr(:call, $(Meta.quot(op)), t1.ex, t2.ex) |> ExprTerm
    @eval $op(t::ExprTerm, other) = Expr(:call, $(Meta.quot(op)), t.ex, other) |> ExprTerm
    @eval $op(other, t::ExprTerm) = Expr(:call, $(Meta.quot(op)), other, t.ex) |> ExprTerm
end
for op in unary_operators
    @eval $op(t::ExprTerm) = Expr(:call, $(Meta.quot(op)), t.ex) |> ExprTerm
end

export @symbol, @symbols, @ExprTerm, ExprTerm

end # module SymbolicMath
