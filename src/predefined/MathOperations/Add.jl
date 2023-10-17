export Add

struct AddBlockType <: AbstractBlockType end

function Add(name = :Add; signs::Vector{Symbol}, out = OutPort())
    b = SimpleBlock(name, AddBlockType)
    for (i,s) = enumerate(signs)
        set!(b, Symbol(:in, i), InPort())
    end
    set!(b, :out, out)
    b.env[:signs] = signs
    b
end

function expr(b::SimpleBlock, ::Type{AddBlockType})
    signs = b.env[:signs]
    expr = 0
    for (i,s) = enumerate(signs)
        expr = Expr(:call, s, expr, b.inports[i].name)
    end
    Expr(:(=), b.outports[1].name, expr...)
end

