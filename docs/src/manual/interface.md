```@meta
CurrentModule = Justitia
```

# [The Justitia interface: 5 types and 5 functions](@id interface)

Justitia asks that you implement 5 types and 5 interface functions to run your experiments. Some useful starting points are included in the library, and are documented in the [Implementations section](@ref implementations).

## Abstract types

```@docs
AbstractInstance
AbstractApproach
AbstractModel
AbstractResult
AbstractResultTable
```

## [Functional interface](@id functional_interface)

```@docs
prep_instance!
build_model
optimize!
tear_down
record_result!
```
