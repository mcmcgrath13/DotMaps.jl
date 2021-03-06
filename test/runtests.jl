using DotMaps
using Test

@testset "DotMaps.jl" begin

    dict = Dict("a"=>1, "b"=>2, "c" => Dict("d"=>3))
    DM = DotMap(dict)

    @test DM.a == 1
    @test DM.c.d == 3

    DM.c.e = 4
    @test DM.c.e == 4

    delete!(DM.c, "e")
    @test !("e" in keys(DM.c))

    @test get!(DM.c, "e", 5) == 5
    @test DM.c.e == 5
    @test DM["c"].e == 5

    DM.c.f = Dict("g" => 6)
    @test DM.c.f.g == 6

    for (k, v) in DM
        @test isa(k, Symbol)
    end

    @test length(DM) == 3
    @test 3 in collect(values(DM.c))

    @test pop!(DM.c, "e") == 5

    filtered = filter(x -> isa(last(x), Int), DM)
    @test !("c" in keys(filtered))
    @test filtered.a == 1

    filter!(x -> isa(last(x), Int), DM)
    @test !("c" in keys(DM))
    @test haskey(DM, "a")
    @test DM.a == 1
    @test :a in propertynames(DM)

    @test isempty(DotMap())

    d = DotMap()
    d.a = Dict("b" => 2)
    dd = DotMaps.todict(d, keys_as_strings=true)
    @test dd == Dict("a" => Dict("b" => 2))
    dds = DotMaps.todict(d)
    @test dds == Dict(:a => Dict(:b => 2))
end
