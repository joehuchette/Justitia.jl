```@meta
CurrentModule = Justitia
```

# Justitia

Justitia is a simple, flexible framework for benchmarking optimization algorithms.

The basic building blocks in Justicia are `Approach`s (an algorithm configured in a particular way) and `Instance`s (a concrete realization of an optimization problem). A `Model` couples together a single `Approach` with a single `Instance`.

`Model`s are treated as black boxes: you can build them, optimize them, and query the results, but otherwise do not interact with them. Given a `Result` from a solved model, you can pack them into a `ResultTable` for later analysis.

The main entrypoint of Justitia asks you to specify a vector of $M$ `Approach`s and $N$ `Instance`s. It builds the $M \times N$ `Model`s coupling each pair, optimizes each, and records the results of each in a centralized table for later analysis. Easy, right?

