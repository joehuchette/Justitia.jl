struct CSVRecord <: AbstractResultTable
    fp::IOStream

    function CSVRecord(
        filename::String,
        headers::Union{Nothing,Vector{String}} = nothing,
    )
        fp = open(filename, "w+")
        if headers !== nothing
            write(fp, join(headers, ","))
            flush(fp)
        end
        record = new(fp)
        finalizer(record, r -> close(r.fp))
        return record
    end
end
