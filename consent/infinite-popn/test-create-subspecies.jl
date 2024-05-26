include("helper_funcs.jl")

subspecies = create_all_subspecies(name2strategyOriginal("-r+,+g-|-r+,+g-"))
println("Number of subspecies: ", length(subspecies), "\n\n") #should be 486