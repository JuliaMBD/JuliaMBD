export Constant

mutable struct Constant <: AbstractFunctionBlock
    value::Union{Value,SymbolicValue}
    outport::OutPort

    function Constant(;value::Union{Value,SymbolicValue}, outport::OutPort)
        blk = new()
        blk.value = value
        blk.outport = outport
        blk.outport.parent = blk
        blk
    end
end
    

function expr(blk::Constant)
    b = expr_setvalue(blk.outport.var, expr_refvalue(blk.value))
    o = [expr_setvalue(line.var, expr_refvalue(blk.outport.var)) for line = blk.outport.lines]
    Expr(:block, b, o...)
end

function next(blk::Constant)
    [line.dest.parent for line = blk.outport.lines]
end