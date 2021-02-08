function Find_Unique_Solutions(filename1, filename2)

    s = open(filename1, "r") do file
        read(file, String)
    end

    solution_list = split(s, "--------------------------------------------------------------------------------------------------------------------------------------------")

    unique_solution_list = []
    unique_solution_tuple_list = []
    for solution in solution_list
        if !(solution in unique_solution_list)
            push!(unique_solution_list, solution)
            push!(unique_solution_tuple_list, (length(solution), solution))
        end
    end

    unique_solution_tuple_list = sort!(unique_solution_tuple_list)

    number_of_solutions = length(unique_solution_tuple_list) - 1

    open(filename2, "w+") do file
        for entry in unique_solution_tuple_list
            if entry[2] == "\n"
                write(file, "Number of Solutions: $number_of_solutions" * entry[2])
            else
                solution = "--------------------------------------------------------------------------------------------------------------------------------------------" * entry[2]
                write(file, solution)
            end
        end
    end
    return unique_solution_tuple_list
end

Find_Unique_Solutions(joinpath(@__DIR__,"solutions_monkey_no_kotake.txt"), joinpath(@__DIR__,"unique_solutions_monkey_no_kotake.txt"))
Find_Unique_Solutions(joinpath(@__DIR__,"solutions_monkey_kotake.txt"), joinpath(@__DIR__,"unique_solutions_monkey_kotake.txt"))
Find_Unique_Solutions(joinpath(@__DIR__,"solutions_no_monkey_no_kotake.txt"), joinpath(@__DIR__,"unique_solutions_no_monkey_no_kotake.txt"))
