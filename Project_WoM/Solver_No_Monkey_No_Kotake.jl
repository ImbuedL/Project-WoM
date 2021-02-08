include("WoM_Heap_Structs.jl")
include("WoM_Heap_Functions.jl")
include("WoM_Rooms_No_Monkey_No_Kotake.jl")
include("WoM_Overlay_Dict.jl")

#=
  This file is used for finding solutions for the "No Monkey No Kotake" case
=#

#=
Allocation_List_Dict = Dict(
    1 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    2 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    5 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    8 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    7 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    4 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ]
)
=#


#=
Allocation_List_Dict = Dict(
    1 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    2 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    5 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    8 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    7 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    4 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Zora Fins",
    "Zora Fins",
    "Hookshot OR Charged Spin Attack"
    ]
)
=#

#=
Allocation_List_Dict = Dict(
    1 => ["Smoke"
    ],
    2 => ["Smoke"
    ],
    5 => ["Smoke"
    ],
    8 => ["Smoke"
    ],
    7 => ["Smoke"
    ],
    4 => ["Smoke"
    ],
    3 => ["Smoke",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    ]
)
=#

#=
Allocation_List_Dict = Dict(
    1 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    2 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    5 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    8 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    7 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    4 => [
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Arrow",
    "Arrow",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ]
)
=#


Allocation_List_Dict = Dict(
    1 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    2 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    5 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    8 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    7 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    4 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ]
)


#=
Allocation_List_Dict = Dict(
    1 => [
    "Hookshot OR Charged Spin Attack"
    ],
    2 => [
    "Hookshot OR Charged Spin Attack"
    ],
    5 => [
    "Hookshot OR Charged Spin Attack"
    ],
    8 => [
    "Hookshot OR Charged Spin Attack"
    ],
    7 => [
    "Hookshot OR Charged Spin Attack"
    ],
    4 => [
    "Hookshot OR Charged Spin Attack"
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign"
    ]
)
=#

#=
Allocation_List_Dict = Dict(
    1 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    2 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    5 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    8 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    7 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    4 => [
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ]
)
=#

#=
Allocation_List_Dict = Dict(
    1 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    2 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    5 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    8 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    7 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    4 => [
    "Bomb",
    "Bomb",
    "Bomb",
    ],
    3 => [
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Square Sign",
    "Smoke",
    "Bomb",
    "Bomb",
    "Bomb",
    "Hookshot OR Charged Spin Attack"
    ]
)
=#

Naive_Grotto_Solver_Loop(
    3,
    Room_Dict,
    Allocation_List_Dict,
    Overlay_Dict,
    joinpath(@__DIR__,"solutions_no_monkey_no_kotake.txt"),
    Initial_Room_Number=1,
    Initial_Heap=Any[Node(address=0x40B140, size=0x10), Node(address=0x5FFFFF, size=0x10)]
    )
