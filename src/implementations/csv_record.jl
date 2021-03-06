"""
A simple `AbstractResultTable` that uses a .csv file as a backend.

    CSVRecord(filename::String, headers::Union{Nothing,Vector{String}}=nothing)

Creates a `CSVRecord` table which writes the results to a .csv file at the
location `filename` in the file system. Optionally, pass `headers` specifying
the names of the fields to be recorded and the first line of the created .csv
will include this header information.
"""
mutable struct CSVRecord <: AbstractResultTable
    fp::IOStream

    function CSVRecord(
        filename::String,
        headers::Union{Nothing,Vector{String}} = nothing,
    )
        fp = open(filename, "w+")
        if headers !== nothing
            println(fp, join(headers, ","))
            flush(fp)
        end
        record = new(fp)
        finalizer(r -> close(r.fp), record)
        return record
    end
end
