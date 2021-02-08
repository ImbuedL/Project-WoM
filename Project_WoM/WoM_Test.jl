include("WoM_Heap_Structs.jl")
include("WoM_Heap_Functions.jl")
include("WoM_Rooms_Monkey_No_Kotake.jl")
include("WoM_Overlay_Dict.jl")

Heap = Any[Node(address=0x40B140, size=0x10), Node(address=0x5FFFFF, size=0x10)]

println("This won't print because Atom is bad")

#Display_Heap(Heap)

Load_Scene!(Heap, Room2, Overlay_Dict)
Load_Room!(Heap, Room1, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=false)
Load_Room!(Heap, Room2, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=true)
Load_Room!(Heap, Room1, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=true)
Display_Heap(Heap)


#=
Load_Scene!(Heap, Room1, Overlay_Dict)
Load_Room!(Heap, Room2, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=true)
#Load_Room!(Heap, Room1, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=true)
Load_Room!(Heap, Room5, Room2.transition_list[2], Overlay_Dict, Entered_Room_1=true)
Load_Room!(Heap, Room2, Room2.transition_list[2], Overlay_Dict, Entered_Room_1=true)
Load_Room!(Heap, Room1, Room1.transition_list[1], Overlay_Dict, Entered_Room_1=true)
Display_Heap(Heap)
=#

#=

I cannot understand what is happening when I enter room 1 (loaded scene from room 1,
entered room 2, and returning to room 1). It seems that after the 2nd dummy loading plane
gets allocated, something else that has a size between 0x2B0 and 0x3F0 inclusively must
be getting allocated, but then deallocates right away after all the stuff from room 1
gets loaded, however it never shows up on spectrum

SOLUTION: the monkey is size 0x3F0 so it must load right after the 2nd plane copy and
then deallocate once everything else loads in.

=#
