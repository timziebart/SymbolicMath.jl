

using SymbolicMath
using Test

@time @testset "symbol creation and equality" begin
    @test @symbol(x) == :x
    @test @symbols(y,z) == (:y, :z)
    @test x == :x
    @test :x == x
    @test x == x
end

@time @testset "binary operators" begin
    @symbols x y z
    for op in SymbolicMath.binary_opeators
        @test eval(op)(x, y) == :($op(x, y))
        @test eval(op)(x, :y) == :($op(x, y))
        @test eval(op)(:x, y) == :($op(x, y))
        @test eval(op)(x + y, z) == :($op(x + y, z))
        @test eval(op)(x, y + z) == :($op(x, y + z))
    end
end

@time @testset "unary operators" begin
    @symbols x y
    for op in SymbolicMath.unary_operators
        @test eval(op)(x) == :($op(x))
        @test eval(op)(x+y) == :($op(x+y))
    end
end
