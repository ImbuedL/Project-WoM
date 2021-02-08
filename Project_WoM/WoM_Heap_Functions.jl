include("WoM_Heap_Structs.jl")

################################################################################

function Overlay_In_Heap(Heap, overlay)

    #=
    Overlay is the overlay that we want to check whether or not it is in the Heap

    This function will return True if Overlay is in the Heap and False otherwise
    =#

    overlay_in_heap = false

    for entry in Heap

        if typeof(entry) == Overlay && entry.id == overlay.id
            overlay_in_heap = true
        end
    end
    return overlay_in_heap
end

################################################################################

function Actor_Id_In_Heap(Heap, actor_id)

    #=

    actor_id is the Id that we want to check for

    This function will return True if there exists an Actor in the Heap that
    has actor_id as its Id and it will return False otherwise

    =#

    actor_id_in_heap = false

    for entry in Heap
        if typeof(entry) == Actor && entry.id == actor_id
            actor_id_in_heap = true
        end
    end
    return actor_id_in_heap
end

################################################################################

function Find_Gaps(Heap)

    #=
    This function will find all consecutive nodes and output a list of 4-tuples
    where the first two entries correspond to the indices of each node in the list
    and the last two entries correspond to the addresses of each node

    The list should be in order, from the start of the Heap to the end of the Heap
    =#

    consecutive_node_count = 0

    node_1_address = 0
    node_2_address = 0
    node_1_index = 0
    node_2_index = 0

    consecutive_node_list = []
    for i=1:length(Heap)

        entry = Heap[i]

        if typeof(entry) == Node && consecutive_node_count == 0
            node_1_address = entry.address
            node_1_index = i
            consecutive_node_count += 1
        elseif typeof(entry) == Node && consecutive_node_count == 1
            node_2_address = entry.address
            node_2_index = i
            push!(consecutive_node_list, (node_1_index, node_2_index, node_1_address, node_2_address))
            consecutive_node_count += 1
        elseif typeof(entry) != Node
            consecutive_node_count = 0
        elseif type(entry) == Node && consecutive_node_count > 1
            consecutive_node_count += 1
            println("ERROR: More than 2 consecutive nodes!! (Find_Gaps() Error Message)")
        end
    end
    return consecutive_node_list
end

################################################################################

function Allocate!(Heap, actor, Overlay_Dict; node_size=0x10)

    #=

    actor is the actor that we want to allocate into the Heap

    Overlay_Dict is a dictionary where the keys are the actor ids which point to the corresponding Overlays

    This function will account for placing nodes and overlays

    node_size will default to 0x10

    =#

    Actor_Allocated = false

    gap_list = Find_Gaps(Heap)

    # Because we initialize the Heap with 2 nodes, there should always be at least one gap
    if length(gap_list) < 1
        println("ERROR: len(gap_list) < 1 in Allocate() function")
    end

    # If the Overlay is type A and the Overlay is not already in the Heap, then we want to allocate the overlay first
    if actor.overlay_type == "A"

        ##### We only define Overlay for Type A overlays because Overlay_Dict only has Type A overlays
        Overlay = Overlay_Dict[actor.id]
        Overlay_Allocated = false

        if Overlay_In_Heap(Heap, Overlay) == true
            Overlay_Allocated = true
        end

        if Overlay_In_Heap(Heap, Overlay) == false

            for gap in gap_list

                if Overlay_Allocated == true
                    break ##### This ensures we don't add in the same Overlay multiple times
                end

                node_2_index = gap[2]
                node_1_address = gap[3]
                node_2_address = gap[4]

                gap_size = node_2_address - node_1_address - node_size

                ##### Case 1: the Overlay can fit, but there is NOT enough space for an extra node
                # Note that gap_size is always a multiple of 16

                if Overlay.size <= gap_size && Overlay.size > gap_size - 2*node_size

                    Overlay.address = node_1_address + node_size
                    insert!(Heap, node_2_index, Overlay)
                    Overlay_Allocated = true


                ##### Case 2: the Overlay can fit and a new node can also fit

                elseif Overlay.size <= gap_size && Overlay.size <= gap_size - 2*node_size

                    Overlay.address = node_1_address + node_size
                    insert!(Heap, node_2_index, Overlay)

                    ########### ADD IN THE NODE HERE
                    if Overlay.size%16 > 0
                        insert!(Heap, node_2_index + 1, Node(address=Overlay.address + Overlay.size + (16 - Overlay.size%16), size=node_size))
                    elseif Overlay.size%16 == 0
                        insert!(Heap, node_2_index + 1, Node(address=Overlay.address + Overlay.size, size=node_size))
                    end

                    Overlay_Allocated = true
                end
            end
        end
    end
    ############ Now the overlay (if applicable) has been allocated. Now we need to allocate the actor.

    ##### We need to update the gaps_list to account for the overlay being allocated in the Heap already
    gap_list = Find_Gaps(Heap)

    for gap in gap_list

        if Actor_Allocated == true
            break ##### This ensures we don't add in the same Actor multiple times
        end

        node_2_index = gap[2]
        node_1_address = gap[3]
        node_2_address = gap[4]

        gap_size = node_2_address - node_1_address - node_size

        ##### Case 1: the Actor can fit, but there is NOT enough space for an extra node
        # Note that gap_size is always a multiple of 16

        if actor.size <= gap_size && actor.size > gap_size - 2*node_size

            actor.address = node_1_address + node_size
            insert!(Heap, node_2_index, actor)
            Actor_Allocated = true

        ##### Case 2: the Actor can fit and a new node can also fit

        elseif actor.size <= gap_size && actor.size <= gap_size - 2*node_size

            actor.address = node_1_address + node_size
            insert!(Heap, node_2_index, actor)

            ########### ADD IN THE NODE HERE
            if actor.size%16 > 0
                insert!(Heap, node_2_index + 1, Node(address=actor.address + actor.size + (16 - actor.size%16), size=node_size))
            elseif actor.size%16 == 0
                insert!(Heap, node_2_index + 1, Node(address=actor.address + actor.size, size=node_size))
            end

            Actor_Allocated = true
        end
    end
end

################################################################################

function Borders_Node(Heap, entry)

    #=

    This function takes an entry of the Heap as input and determines whether or
    not this entry is adjacent to a node in the heap (the purpose of this is to
    check if a node is bordering another node since actors and overlays should
    be bordering two nodes under every circumstance)

    Returns True if the entry is bordering a node, returns False otherwise

    =#

    borders_node = false

    # Note that since everything in the Heap is a mutable struct (i.e. are considered different from eachother due to where they are in memory), findfirst() is sufficient since each entry of the Heap is unique
    entry_index = findfirst(x -> x == entry, Heap)

    border_1_is_node = false
    border_2_is_node = false

    if entry_index != 1
        border_1 = Heap[entry_index - 1]
        if typeof(border_1) == Node
            border_1_is_node = true
        end
    end

    if entry_index != length(Heap)
        border_2 = Heap[entry_index + 1]
        if typeof(border_2) == Node
            border_2_is_node = true
        end
    end

    if border_1_is_node == true || border_2_is_node == true
        borders_node = true
    end

    return borders_node
end

################################################################################

function Clear_Instance!(actor)

    if actor.clearable == true
        actor.cleared = true
    end
end

################################################################################

function Deallocate!(Heap, actor, Overlay_Dict)


    #=

    This function will NOT account for clearing Actors even if Actor.clearable = true

    actor is the actor that we want to be deallocated from the Heap

    This function will account for removing nodes and overlays

    ##### Remove the actor AND node if applicable
    ##### Check if any actors with the same Id are still in the Heap
    ##### if not (and the actor has overlay Type A), then remove the overlay

    We only remove a node if it is part of a gap before deallocating the actor
    That is, we only remove a node if it borders another node before the actor is deallocated

    =#

    if typeof(actor) != Actor
        println("ERROR: Attempted to deallocate something other than an Actor (Deallocate() function error message)")
    end

    # The index of where the actor is in the Heap before being deallocated; this will change after we remove the first node
    actor_index = findfirst(x -> x == actor, Heap)

    ##### First check the node above the actor in the Heap
    node_1 = Heap[actor_index - 1]
    if typeof(node_1) != Node
        println("ERROR: One of the nodes is not actually a node! (Deallocate() function error message)")
    end

    if Borders_Node(Heap, node_1) == true
        deleteat!(Heap, actor_index - 1) # Removes the node from the heap
    end

    ########## Now the first node has been removed and the indices of the Heap shift

    ##### Now we check the node below the actor in the Heap

    # The index of where the actor is in the Heap before being deallocated; this will change after we remove the first node
    actor_index = findfirst(x -> x == actor, Heap)

    node_2 = Heap[actor_index + 1]
    if typeof(node_2) != Node
        println("ERROR: One of the nodes is not actually a node! (Deallocate() function error message)")
    end

    if Borders_Node(Heap, node_2) == true
        deleteat!(Heap, actor_index + 1)
    end

    ###########################################################################
    ##### Now we have removed both of the nodes, if applicable and we must remove the actor itself

    deleteat!(Heap, actor_index) # actor_index should be unchanged from when we removed the node after the actor

    #=

    Now if the actor has a Type A overlay, then we must check if the Heap contains
    any other actors that have the same Id as actor and if not, then we must also
    remove its overlay from the Heap

    We must also account for removing the nodes around the overlay, if applicable

    =#

    if actor.overlay_type == "A" && Actor_Id_In_Heap(Heap, actor.id) == false

        ##### First check the node above the overlay
        #overlay_index = findfirst(x -> x == typeof(x) == Overlay && Overlay_Dict[actor.id].id, Heap)
        overlay_index = findfirst(x -> typeof(x) == Overlay && Overlay_Dict[actor.id].id == x.id, Heap)
        node1 = Heap[overlay_index - 1]

        if typeof(node1) != Node
            println("ERROR: One of the nodes is not actually a node! (Deallocate() function error message)")
        end

        if Borders_Node(Heap, node1) == true
            deleteat!(Heap, overlay_index - 1)
        end

        ##### Now we check the node below the overlay
        #overlay_index = findfirst(x -> x == typeof(x) == Overlay && Overlay_Dict[actor.id].id, Heap)
        overlay_index = findfirst(x -> typeof(x) == Overlay && Overlay_Dict[actor.id].id == x.id, Heap)
        node2 = Heap[overlay_index + 1]

        if typeof(node2) != Node
            println("ERROR: One of the nodes is not actually a node! (Deallocate() function error message)")
        end

        if Borders_Node(Heap, node2) == true
            deleteat!(Heap, overlay_index + 1)
        end

        ###########################################################################
        ##### Now we have removed both of the nodes (if applicable), and we must remove the overlay itself
        overlay_index = findfirst(x -> typeof(x) == Overlay && Overlay_Dict[actor.id].id == x.id, Heap)
        deleteat!(Heap, overlay_index)
    end
end

################################################################################

function Load_Scene!(Heap, room, Overlay_Dict)

    if length(Heap) != 2
        println("ERROR: Attempted to use Load_Scene() with an inappropriate Heap")
    end

    Cleared_Actors = []
    Plane_Copy_List = []
    for entry in room.scene_load_actor_list
        Allocate!(Heap, entry, Overlay_Dict)
        if entry.cleared == true && entry.plane_copy == false
            push!(Cleared_Actors, entry)
        elseif entry.plane_copy == true
            push!(Plane_Copy_List, entry)
        end
    end

    #=
    NOTE: WoM Does not have any spawners, so they are not handled

    We want to deallocate all cleared actors before we deallocate the loading plane copies (doesn't really matter...)
    =#

    for cleared_actor in Cleared_Actors
        Deallocate!(Heap, cleared_actor, Overlay_Dict)
    end

    # deallocate the plane copies
    for plane_copy in Plane_Copy_List
        Deallocate!(Heap, plane_copy, Overlay_Dict)
    end
end

################################################################################

function Load_Room!(Heap, room, transition, Overlay_Dict; Entered_Room_1)


    #=

    This function updates the Heap after you enter room through transition
    For example, you might enter Room0 through Plane1 or Door3

    Before executing the script, should probably define Plane1, Plane2, ...
    Door1, Door2, ..., etc. as the corresponding entries from the room queues.
    This will make the code more readable when looking for solutions


    * First we load all of the actors from the new room
    * Next, we deallocate everything (well, not literally everything...) from the previous room


    Things that this function needs to handle:

        - make sure that you check if each actor was cleared or not (if clearable == True, otherwise it isn't applicable)
        and then check if it is Category 5 to determine if it loads and immediately deallocates or not

        - checking which clock to deallocate (i.e. deallocate the one that comes later
        on in the Heap if there are more than one). Maybe define a Find_Clocks function

        - make sure transition never deallocates and never attempts to allocate

        - make sure that the other Transitions unload and then reload (if applicable) after all of
        the stuff from the previous room deallocated

        - when deallocating stuff from the room that isn't the room you're entering, be sure
        not to deallocate the clock. Also be careful of relevant Transitions as they don't have
        actual room numbers (replaced with False)

        - allocate stuff from spawners after the fact (even after planes)


    Adding an Entered_Room_1 argument. This is true if you have been in Room 1 (either by loading the scene there
    or by entering it normally from another room); false otherwise. This is important because if you have ever been in Room 1, then
    the monkey from Room 1 is loaded in the heap and never loads again. Thus, if Enter_Room_1 is true, then whenever
    you enter Room 1, skip loading the monkey in Room 1


    =#

    if !(transition in Heap)
        println("2222222222")
        println(transition.transition[1])
        println(transition.transition[2])
        println(room.number)
        println("DROSE")
    end

    #=
    if !(transition in room.actor_list)
        println("44444444")
    end

    if !(transition in Heap) || !(transition in room.actor_list)
        println("ERROR: Attempted to use Load_Room() with an invalid transition")
    end
    =#

    current_room_number = -1
    new_room_number = room.number

    if transition.transition[1] == room.number
        current_room_number = transition.transition[2]
    elseif transition.transition[2] == room.number
        current_room_number = transition.transition[1]
    else
        println("ERROR: Error with transition list (Load_Room() error message)")
    end

    #=
    First we load all of the actors from the new room,
    EXCEPT for:
                - the plane/door we pass through AND
                - any other shared transitions AND
                - any actors with both cleared == True and Category == 5 (these ones never attempt to load) #### instead, cleared == true && attempts_to_allocate_if_cleared == false

    Since this heap sim is specialized for WoM Day 2, the Room struct will not use Room.actor_list and instead
    will use Room.actor_list_prev and Room.actor_list_next

    =#

    #=

    First we need to determine if the Room that we're entering is the "next" room or the "previous" room in the room list: 1, 2, 5, 8, 7, 4, 3

    =#

    use_next_actor_list = false
    use_prev_actor_list = false
    # Just hardcode it...
    if current_room_number == 1 && new_room_number == 2
        use_next_actor_list = true
    elseif current_room_number == 1 && new_room_number != 2
        println("ERROR[1]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 2 && new_room_number == 1
        use_prev_actor_list = true
    elseif current_room_number == 2 && new_room_number == 5
        use_next_actor_list = true
    elseif current_room_number == 2 && new_room_number != 1 && new_room_number != 5
        println("ERROR[2]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 5 && new_room_number == 2
        use_prev_actor_list = true
    elseif current_room_number == 5 && new_room_number == 8
        use_next_actor_list = true
    elseif current_room_number == 5 && new_room_number != 2 && new_room_number != 8
        println("ERROR[5]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 8 && new_room_number == 5
        use_prev_actor_list = true
    elseif current_room_number == 8 && new_room_number == 7
        use_next_actor_list = true
    elseif current_room_number == 8 && new_room_number != 5 && new_room_number != 7
        println("ERROR[8]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 7 && new_room_number == 8
        use_prev_actor_list = true
    elseif current_room_number == 7 && new_room_number == 4
        use_next_actor_list = true
    elseif current_room_number == 7 && new_room_number != 8 && new_room_number != 4
        println("ERROR[7]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 4 && new_room_number == 7
        use_prev_actor_list = true
    elseif current_room_number == 4 && new_room_number == 3
        use_next_actor_list = true
    elseif current_room_number == 4 && new_room_number != 7 && new_room_number != 3
        println("ERROR[4]: Invalid new_room_number in Load_Room() function")
    end

    if current_room_number == 3 && new_room_number == 4
        use_prev_actor_list = true
    elseif current_room_number == 3 && new_room_number != 4
        println("ERROR[3]: Invalid new_room_number in Load_Room() function")
    end

    if use_prev_actor_list == true && use_next_actor_list == true
        println("ERROR: both use_prev_actor_list and use_next_actor_list are true in Room_Load() function")
    end


    if use_prev_actor_list == true

        for actor in room.actor_list_prev

            ### If the actor is not a Transition OR if the actor is a transition but doesn't connect to the current room [nevermind my Nevermind] <- [Nevermind, this is bad logic for this case since WoM simplifications removed logic for multiple connecting planes]
            if (actor.transition == false) || (actor.transition != false && actor.transition[1] != current_room_number && actor.transition[2] != current_room_number)
            #if (actor.transition == false) || (actor.transition != false && actor != transition)

                ### If the actor is """Category 5""", then only attempt to load it if it has not been cleared
                if (actor.attempts_to_allocate_if_cleared == true || actor.cleared == false) && actor.id != "019E"

                    Allocate!(Heap, actor, Overlay_Dict)

                elseif actor.id == "019E"

                    if room.number != 1

                        Allocate!(Heap, actor, Overlay_Dict)

                    elseif room.number == 1 && Entered_Room_1 == false

                        Allocate!(Heap, actor, Overlay_Dict)

                    # if this causes issues for other Room lists, can add other checks here
                    elseif room.number == 1 && Entered_Room_1 == true

                        # allocate this, then deallocate it later once everything else from Room 1 is allocated

                        monkey_copy = Actor(
                            name="Monkey Copy",
                            id="019E",
                            size=0x3EC,
                            overlay_type="A",
                            address=0,
                            room_number=false,
                            priority=1,
                            unloadable=false,
                            clearable=false,
                            cleared=false,
                            attempts_to_allocate_if_cleared=false,
                            transition=false,
                            plane_copy=false,
                            grabbable_actor=false,
                            valid_superslide_list=false
                            )

                            Allocate!(Heap, monkey_copy, Overlay_Dict)

                    end
                end
            end
        end
    elseif use_next_actor_list == true
        for actor in room.actor_list_next

            ### If the actor is not a Transition OR if the actor is a transition but doesn't connect to the current room
            if (actor.transition == false) || (actor.transition != false && actor.transition[1] != current_room_number && actor.transition[2] != current_room_number)
            #if (actor.transition == false) || (actor.transition != false && actor != transition)
                if (actor.attempts_to_allocate_if_cleared == true || actor.cleared == false) && actor.id != "019E"

                    Allocate!(Heap, actor, Overlay_Dict)

                elseif actor.id == "019E"

                    if room.number != 1

                        Allocate!(Heap, actor, Overlay_Dict)

                    elseif room.number == 1 && Entered_Room_1 == false

                        Allocate!(Heap, actor, Overlay_Dict)

                    #=# this should never be used technically, since Room 1 isn't ever "next"
                    elseif room.number == 1 && Entered_Room_1 == true

                        # allocate this, then deallocate it later once everything else from Room 1 is allocated

                        monkey_copy = Actor(
                            name="Monkey Copy",
                            id="019E",
                            size=0x3EC,
                            overlay_type="A",
                            address=0,
                            room_number=false,
                            priority=1,
                            unloadable=false,
                            clearable=false,
                            cleared=false,
                            attempts_to_allocate_if_cleared=false,
                            transition=false,
                            plane_copy=false,
                            grabbable_actor=false,
                            valid_superslide_list=false
                            )

                            Allocate!(Heap, monkey_copy, Overlay_Dict)
=#
                    end
                end
            end
        end
    end

    #=
    - Now all of the relevant actors from the new room have been allocated
    - we also need to deallocate all actors from current_room (i.e. the room we just left)
    # Now we need to immediately deallocate any actors with Clearable == True and Cleared == True
    # We also need to deallocate any transitions which are shared between the current room and the new room ###### NONE OF THESE EXIST IN WoM
      EXCEPT for transition itself (the transition that we passed through to get to the new room)  ###############
    # We also need to deallocate the second clock actor in the Heap if it exists (do this after everything else for simplicity) ####### NOT APPLICATION TO WoM
    - We need to deallocate all plane copies; do this before deallocating the cleared actors

      Note that "current_room_number" is the room number of the room we were in before loading the new room
    =#

    # collect a list of actors to account for the heap changing size as actors/nodes get deallocated
    actors_in_heap = []
    for entry in Heap
        if typeof(entry) == Actor
            push!(actors_in_heap, entry)
        end
    end

    # ADDED a "Monkey Copy" check here
    for entry in actors_in_heap
        if (typeof(entry) == Actor) && ((entry.room_number == current_room_number && typeof(entry.room_number) == typeof(current_room_number)) || entry.cleared == true || entry.plane_copy == true || (entry.transition != false && entry.transition[1] != room.number && entry.transition[2] != room.number) || entry.name == "Monkey Copy")
            Deallocate!(Heap, entry, Overlay_Dict)
        end
    end

end

################################################################################

function Display_Heap(Heap)

    for entry in Heap

        if typeof(entry) == Node

            println("0x" * string(entry.address, base=16) * "-----" * "NODE-----------------")

        elseif typeof(entry) == Overlay

            println("0x" * string(entry.address, base=16) * "     " * entry.id * "     " * "OVERLAY")

        elseif typeof(entry) == Actor

            println("0x" * string(entry.address, base=16) * "     " * entry.id * "     " * "INSTANCE")

        else
            println("ERROR!!! Unexpected Entry Type in Heap!!!!!!!!!")
        end
    end
end

#=

TODO:
- functions for allocating specific actors (bomb, fins, spin attack, etc.)
- Allocation_Step() function
- Deallocation_Step() function
- SRM_Solver() function [use above functions to make it clean]

=#

function Allocate_Bomb!(Heap, Room_Number, Overlay_Dict)

    Bomb = Actor(
        name="Bomb",
        id="0009",
        size=0x204,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Bomb, Overlay_Dict)

end

################################################################################

function Allocate_Smoke!(Heap, Room_Number, Overlay_Dict)

    Bomb = Actor(
        name="Bomb",
        id="0009",
        size=0x204,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Bomb, Overlay_Dict)

    Smoke = Actor(
        name="Smoke",
        id="00A2",
        size=0x2E84,
        overlay_type="A",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Smoke, Overlay_Dict)

    Deallocate!(Heap, Bomb, Overlay_Dict)

end

################################################################################

function Allocate_Arrow!(Heap, Room_Number, Overlay_Dict)

    Arrow = Actor(
        name="Arrow",
        id="000F",
        size=0x278,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Arrow, Overlay_Dict)

end

################################################################################

function Allocate_Hookshot!(Heap, Room_Number, Overlay_Dict)

    Hookshot = Actor(
        name="Hookshot",
        id="003D",
        size=0x210,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Hookshot, Overlay_Dict)

end

################################################################################

function Allocate_Chu!(Heap, Room_Number, Overlay_Dict)

    Chu = Actor(
        name="Chu",
        id="006A",
        size=0x1E0,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Chu, Overlay_Dict)

end

################################################################################

function Allocate_Square_Sign!(Heap, Room_Number, Overlay_Dict)

    Sign = Actor(
        name="Square Sign",
        id="00A8",
        size=0x1F0,
        overlay_type="A",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Sign, Overlay_Dict)

end

################################################################################

function Allocate_Zora_Fins!(Heap, Room_Number, Overlay_Dict)

    #=
    This function allocates 2 Zora Fin actor instances
    =#

    for i=1:2
        Zora_Fin = Actor(
            name="Zora Fin",
            id="0020",
            size=0x1F4,
            overlay_type="B",
            address=0,
            room_number=Room_Number,
            priority=0,
            unloadable=true, # don't think this really matters if allocation step is always after deallocation step
            clearable=false,
            cleared=false,
            attempts_to_allocate_if_cleared=false,
            transition=false,
            plane_copy=false,
            grabbable_actor=false,
            valid_superslide_list=false
        )

        Allocate!(Heap, Zora_Fin, Overlay_Dict)
    end

end

################################################################################

function Allocate_Charged_Spin_Attack!(Heap, Room_Number, Overlay_Dict)

    Spin_Attack_and_Sword_Beam_Effects = Actor(
        name="Spin Attack & Sword Beam Effects",
        id="0035",
        size=0x1C4,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Spin_Attack_and_Sword_Beam_Effects, Overlay_Dict)

    Spin_Attack_Charge_Particles = Actor(
        name="Spin Attack Charge Particles",
        id="007B",
        size=0x560,
        overlay_type="A",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Spin_Attack_Charge_Particles, Overlay_Dict)

end

################################################################################

function Superslide_With_Bomb_And_Smoke!(Heap, Room_Number, Overlay_Dict)

    #=
    This function allocates a bomb and then allocates smoke, without deallocating the bomb
    =#

    Bomb = Actor(
        name="Bomb",
        id="0009",
        size=0x204,
        overlay_type="B",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Bomb, Overlay_Dict)

    Smoke = Actor(
        name="Smoke",
        id="00A2",
        size=0x2E84,
        overlay_type="A",
        address=0,
        room_number=Room_Number,
        priority=0,
        unloadable=true, # don't think this really matters if allocation step is always after deallocation step
        clearable=false,
        cleared=false,
        attempts_to_allocate_if_cleared=false,
        transition=false,
        plane_copy=false,
        grabbable_actor=false,
        valid_superslide_list=false
    )

    Allocate!(Heap, Smoke, Overlay_Dict)

end

################################################################################

function Allocation_Step!(Heap, Room_Number, Overlay_Dict, Allocation_List_Dict)

    #=

    Allocation_List_Dict is a dictionary where the keys are room numbers and the
    values are lists of strings

    Room_Number is the number of the Room that you are currently in

    =#

    allocation_list = Allocation_List_Dict[Room_Number]

    # store a string to report what the actions in the allocation step are
    report = ""

    explosive_count = 0
    for action in allocation_list

        # uniform random number in [0,1]
        coin_flip = rand()

        if action == "Smoke" && coin_flip > .5
            Allocate_Smoke!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Smoke (let Bomb deallocate)\n"

        elseif action == "Square Sign" && coin_flip > .5
            Allocate_Square_Sign!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Square Sign\n"

        elseif action == "Chu" && coin_flip > .5 && explosive_count < 3
            Allocate_Chu!(Heap, Room_Number, Overlay_Dict)
            explosive_count += 1
            report = report * "    Allocate: Chu\n"

        elseif action == "Bomb" && coin_flip > .5 && explosive_count < 3
            Allocate_Bomb!(Heap, Room_Number, Overlay_Dict)
            explosive_count += 1
            report = report * "    Allocate: Bomb\n"

        elseif action == "Arrow" && coin_flip > .5
            Allocate_Arrow!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Arrow\n"

        elseif action == "Zora Fins" && coin_flip > .5
            Allocate_Zora_Fins!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Zora Fins (2 Zora Fins)\n"

        elseif action == "Hookshot" && coin_flip > .5
            Allocate_Hookshot!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Hookshot\n"

        elseif action == "Charged Spin Attack" && coin_flip > .5
            Allocate_Charged_Spin_Attack!(Heap, Room_Number, Overlay_Dict)
            report = report * "    Allocate: Charged Spin Attack (with magic)\n"

        elseif action == "Hookshot OR Charged Spin Attack" && coin_flip > .5

            # Always do hookshot or charged spin attack last, if you do them at all
            end_action_coin_flip = rand()

            if end_action_coin_flip > .5
                Allocate_Hookshot!(Heap, Room_Number, Overlay_Dict)
                report = report * "    Allocate: Hookshot\n"
            else
                Allocate_Charged_Spin_Attack!(Heap, Room_Number, Overlay_Dict)
                report = report * "    Allocate: Charged Spin Attack (with magic)\n"
            end
        end
    end

    if report == ""
        report = report * "    (Nothing in Allocation Step)\n"
    end

    report = "----- ALLOCATION STEP:\n" * report

    return report
end

################################################################################

function Deallocation_Step!(Heap, Overlay_Dict)

    deallocation_list = []

    report = ""

    for entry in Heap

        # uniform([0,1])
        coin_flip = rand()

        if typeof(entry) == Actor && entry.unloadable == true && coin_flip > .5
            push!(deallocation_list, entry)
        end
    end

    for actor in deallocation_list

        if actor.clearable == true
            Clear_Instance!(actor)
        end

        Deallocate!(Heap, actor, Overlay_Dict)

        actor_name = actor.name
        actor_priority = actor.priority
        report = report * "    Deallocate: $actor_name (Priority $actor_priority)\n"
    end

    if report == ""
        report = report * "    (Nothing in Deallocation Step)\n"
    end

    report = "----- DEALLOCATION STEP:\n" * report

    return report
end

################################################################################

function Grabbable_Actor_In_Heap(Heap)

    #=
    Returns true is there is a grabbale actor in the heap and false otherwise
    =#

    grabbable_actor_in_heap = false

    for entry in Heap
        if typeof(entry) == Actor && entry.grabbable_actor == true
            grabbable_actor_in_heap = true
        end
    end
    return grabbable_actor_in_heap
end

################################################################################

function Grabbable_Actor_In_Heap_Count(Heap)

    #=
    Returns the number of grabbable actors in Heap
    =#

    grabbable_actor_in_heap_count = 0

    for entry in Heap
        if typeof(entry) == Actor && entry.grabbable_actor == true
            grabbable_actor_in_heap_count += 1
        end
    end
    return grabbable_actor_in_heap_count
end

################################################################################

function Grabbable_Actors_In_Heap_List(Heap)

    #=
    Returns a list of all grabbable actors in Heap
    =#

    grabbable_actor_in_heap_list = []

    for entry in Heap
        if typeof(entry) == Actor && entry.grabbable_actor == true
            push!(grabbable_actor_in_heap_list, entry)
        end
    end
    return grabbable_actor_in_heap_list
end

################################################################################

function Deallocation_Step_Before_Superslide!(Heap, Overlay_Dict)

    #=
    The purpose of this function is to make sure that AT LEAST one grabbable
    actor is left in the heap after the deallocation step
    =#

    deallocation_list = []

    report = ""

    for entry in Heap

        # uniform([0,1])
        coin_flip = rand()

        if typeof(entry) == Actor && entry.unloadable == true && coin_flip > .5
            push!(deallocation_list, entry)
        end
    end

    for actor in deallocation_list

        if (Grabbable_Actor_In_Heap_Count(Heap) > 1) || actor.grabbable_actor == false

            if actor.clearable == true
                Clear_Instance!(actor)
            end

            Deallocate!(Heap, actor, Overlay_Dict)

            actor_name = actor.name
            actor_priority = actor.priority
            report = report * "    Deallocate: $actor_name (Priority $actor_priority)\n"
        end
    end

    if report == ""
        report = report * "    (Nothing in Deallocation Step)\n"
    end

    report = "----- DEALLOCATION STEP:\n" * report

    return report
end

################################################################################

function Find_Grotto_Overlay_Address(Heap)

    grotto_overlay_found = false

    for entry in Heap
        if typeof(entry) == Overlay && entry.id == "0055"
            global grotto_overlay_address = entry.address # It is stupid that I need to declare this as global...
            grotto_overlay_found = true
            break
        end
    end

    if grotto_overlay_found == false
        println("atom won't print this maybe")
        println("ERROR: Grotto Overlay is NOT found in the Heap! [Find_Grotto_Overlay_Address() function error]")
    end
    return grotto_overlay_address
end

################################################################################

function Superslide_Step!(Heap, Room_Number, Room_Dict, Overlay_Dict; Entered_Room_1)

    #=
    Room_Number is the number of the room before performing the superslide

    Room_Dict is a Dict() of Room structs that are used where room numbers are the keys
    and the Room structs are the values
    =#

    report = ""

    grabbable_actor_list = Grabbable_Actors_In_Heap_List(Heap)

    # randomly choose one grabbale actor (uniformly)
    chosen_grabbable_actor = rand(grabbable_actor_list)

    # store the address (and other information) of the chosen grabbale actor to test for grotto offset later
    pointer_address = chosen_grabbable_actor.address
    pointer_address_string = string(chosen_grabbable_actor.address, base=16)
    pointer_priority = chosen_grabbable_actor.priority
    pointer_name = chosen_grabbable_actor.name
    pointer_id = chosen_grabbable_actor.id

    # randomly choose a transition to superslide through (uniformly)
    chosen_superslide_entry = rand(chosen_grabbable_actor.valid_superslide_list)

    #=
    Recall, chosen_superslide_entry is a tuple in the form e.g. ("010", transition1)
    =#
    chosen_binary_string = chosen_superslide_entry[1]
    chosen_transition = chosen_superslide_entry[2]

    # Determine the number of the room that you will superslide into
    if chosen_transition.transition[1] == Room_Number
        new_room_number = chosen_transition.transition[2]
    elseif chosen_transition.transition[2] == Room_Number
        new_room_number = chosen_transition.transition[1]
    end

    superslide_options = []

    # length(chosen_binary_string) = 3 always
    for i=1:3
        if chosen_binary_string[i] == '1'
            push!(superslide_options, i)
        end
    end

    # randomly choose a superslide option (uniformly)
    chosen_superslide_option = rand(superslide_options)

    # enter Plane with both Bomb and Smoke loaded
    if chosen_superslide_option == 1
        Superslide_With_Bomb_And_Smoke!(Heap, Room_Number, Overlay_Dict)
        Load_Room!(Heap, Room_Dict[new_room_number], chosen_transition, Overlay_Dict, Entered_Room_1=Entered_Room_1)
        report = report * "Superslide with Bomb and Smoke loaded into Room $new_room_number off of: $pointer_id [$pointer_name] (Priority $pointer_priority) allocated at: 0x$pointer_address_string\n"

    # enter Plane with Smoke loaded, but no Bomb loaded
    elseif chosen_superslide_option == 2
        Allocate_Smoke!(Heap, Room_Number, Overlay_Dict)
        Load_Room!(Heap, Room_Dict[new_room_number], chosen_transition, Overlay_Dict, Entered_Room_1=Entered_Room_1)
        report = report * "Superslide with only Smoke loaded into Room $new_room_number off of: $pointer_id [$pointer_name] (Priority $pointer_priority) allocated at: 0x$pointer_address_string\n"

    # enter Plane with no Smoke (or bomb) loaded
    elseif chosen_superslide_option == 3
        Load_Room!(Heap, Room_Dict[new_room_number], chosen_transition, Overlay_Dict, Entered_Room_1=Entered_Room_1)
        report = report * "Superslide WITHOUT Bomb OR Smoke loaded into Room $new_room_number off of: $pointer_id [$pointer_name] (Priority $pointer_priority) allocated at: 0x$pointer_address_string\n"
    end
    report = "----- SUPERSLIDE STEP:\n" * report
    return (report, pointer_address, new_room_number)
end

################################################################################

function Naive_Grotto_Solver(Transition_Count, Room_Dict, Allocation_List_Dict, Overlay_Dict, filename; Initial_Room_Number=1, Initial_Heap=Any[Node(address=0x40B140, size=0x10), Node(address=0x5FFFFF, size=0x10)])

    #=

    Transition_Count is a nonnegatve integer that is the number of room loads performed before
    attempting a Superslide step

    Room_Dict is a Dict() of Room structs that are used where room numbers are the keys
    and the Room structs are the values

    filename is a string


    This function tests a random permutation with Transition_Count room loads before the superslide step
    and appends the solution to a text file if found. This function returns true if a solution is found
    and false otherwise. The idea is to run this function repeatedly to test tons of permutations.

    =#

    solution_found = false
    solution_report = ""

    heap = deepcopy(Initial_Heap)
    room_dict = deepcopy(Room_Dict)

    Load_Scene!(heap, room_dict[Initial_Room_Number], Overlay_Dict)
    scene_report = "Load Scene from Room $Initial_Room_Number\n"
    solution_report = solution_report * scene_report

    # determine whether or not you have entered room 1
    if Initial_Room_Number == 1
        entered_room_1 = true
    else
        entered_room_1 = false
    end

    current_room_number = Initial_Room_Number

    for i=0:Transition_Count

        # Perform Superslide Step if i == Transition_Count, which allows a Deallocation Step before it
        if i == Transition_Count
            d_report = Deallocation_Step_Before_Superslide!(heap, Overlay_Dict)
            solution_report = solution_report * d_report

            # Perform Superslide Step
            (ss_report, pointer_address, new_room_number) = Superslide_Step!(heap, current_room_number, room_dict, Overlay_Dict, Entered_Room_1=entered_room_1)
            solution_report = solution_report * ss_report

            # update the current room number and check if you entered Room 1
            current_room_number = new_room_number
            if current_room_number == 1
                entered_room_1 = true
            end

            # Now we are in Room current_room_number and need to get back to Room 2 (or exit and reenter Room 2 if current_room_number = 2)
            # TODO

            # in this case, choose between entering and exiting Room 1 or Room 5
            if current_room_number == 2
                room_coin_flip = rand()

                # go to previous room (Room 1)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[1], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 1
                    entered_room_1 = true
                    solution_report = solution_report * "Load Room $current_room_number\n"

                    # Now reload Room 2 through the correct plane
                    Load_Room!(heap, room_dict[2], room_dict[2].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 2
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 5)
                elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 5
                    solution_report = solution_report * "Load Room $current_room_number\n"

                    # Now reload Room 2 through the correct plane
                    Load_Room!(heap, room_dict[2], room_dict[2].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 2
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, go to Room 2 directly from Room 1; go 1 -> 2 [only one entry in transition_list]
            elseif current_room_number == 1
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, go to Room 2 directly from Room 5; go 5 -> 2
            elseif current_room_number == 5
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, go 8 -> 5 -> 2
            elseif current_room_number == 8

                # 8 -> 5
                Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 5
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 5 -> 2
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, go 7 -> 8 -> 5 -> 2
            elseif current_room_number == 7

                # 7 -> 8
                Load_Room!(heap, room_dict[8], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 8
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 8 -> 5
                Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 5
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 5 -> 2
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, go 4 -> 7 -> 8 -> 5 -> 2
            elseif current_room_number == 4

                # 4 -> 7
                Load_Room!(heap, room_dict[7], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 7
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 7 -> 8
                Load_Room!(heap, room_dict[8], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 8
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 8 -> 5
                Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 5
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 5 -> 2
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, go 3 -> 4 -> 7 -> 8 -> 5 -> 2
            elseif current_room_number == 3

                # 3 -> 4
                Load_Room!(heap, room_dict[4], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 4
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 4 -> 7
                Load_Room!(heap, room_dict[7], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 7
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 7 -> 8
                Load_Room!(heap, room_dict[8], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 8
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 8 -> 5
                Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 5
                solution_report = solution_report * "Load Room $current_room_number\n"

                # 5 -> 2
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"
            end

            ##### NOW YOU SHOULD BE IN ROOM 2

            # Now check if the Grotto Overlay address lines up with the pointer_address
            grotto_overlay_address = Find_Grotto_Overlay_Address(heap)
            if pointer_address - grotto_overlay_address == 0x5D0
                solution_found = true
                println("SOLUTION FOUND!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                grotto_overlay_address_string = string(grotto_overlay_address, base=16)
                pointer_address_string = string(pointer_address, base=16)
                solution_report = "\n--------------------------------------------------------------------------------------------------------------------------------------------\nSOLUTION: (Grotto Overlay Address=0x$grotto_overlay_address_string, Pointer Address=0x$pointer_address_string)\n" * solution_report

                # Now write the solution_report to the text file (filename)
                open(filename, "a") do file
                    write(file, solution_report)
                end
            end


        elseif i < Transition_Count

            # DEALLOCATION STEP
            d_report = Deallocation_Step!(heap, Overlay_Dict)
            solution_report = solution_report * d_report

            # ALLOCATION STEP
            a_report = Allocation_Step!(heap, current_room_number, Overlay_Dict, Allocation_List_Dict)
            solution_report = solution_report * a_report

            # RANDOMLY CHOOSE A ROOM TO ENTER (HARDCODE THE OPTIONS!!!)
            #=
            Hardcode the Room transition lists such that transition_list[1] takes you to the previous room
            and transition_list[2] takes you to the next room
            =#

            # in this case, Room 2 is the only option! (There is only one transition, so use transition_list[1])
            if current_room_number == 1
                Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 2
                solution_report = solution_report * "Load Room $current_room_number\n"

            # in this case, we choose between Room 1 and Room 5
            elseif current_room_number == 2
                room_coin_flip = rand()

                # go to previous room (Room 1)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[1], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 1
                    entered_room_1 = true
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 5)
            elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 5
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, we choose between Room 2 and Room 8
            elseif current_room_number == 5
                room_coin_flip = rand()

                # go to previous room (Room 2)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[2], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 2
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 8)
                elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[8], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 8
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, we choose between Room 5 and Room 7
            elseif current_room_number == 8
                room_coin_flip = rand()

                # go to previous room (Room 5)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[5], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 5
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 7)
                elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[7], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 7
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, we choose between Room 8 and Room 4
            elseif current_room_number == 7
                room_coin_flip = rand()

                # go to previous room (Room 8)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[8], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 8
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 4)
                elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[4], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 4
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, we choose between Room 7 and Room 3
            elseif current_room_number == 4
                room_coin_flip = rand()

                # go to previous room (Room 7)
                if room_coin_flip > .5
                    Load_Room!(heap, room_dict[7], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 7
                    solution_report = solution_report * "Load Room $current_room_number\n"
                # go to next room (Room 3)
                elseif room_coin_flip <= .5
                    Load_Room!(heap, room_dict[3], room_dict[current_room_number].transition_list[2], Overlay_Dict, Entered_Room_1=entered_room_1)
                    current_room_number = 3
                    solution_report = solution_report * "Load Room $current_room_number\n"
                end

            # in this case, Room 4 is the only option! (There is only one transition, so use transition_list[1])
            elseif current_room_number == 3
                Load_Room!(heap, room_dict[4], room_dict[current_room_number].transition_list[1], Overlay_Dict, Entered_Room_1=entered_room_1)
                current_room_number = 4
                solution_report = solution_report * "Load Room $current_room_number\n"
            end
        end
    end
    return solution_found
end

################################################################################

function Naive_Grotto_Solver_Loop(Max_Transition_Count, Room_Dict, Allocation_List_Dict, Overlay_Dict, filename; Initial_Room_Number=1, Initial_Heap=Any[Node(address=0x40B140, size=0x10), Node(address=0x5FFFFF, size=0x10)])

    #=
    Max_Transition_Count is a nonnegative integer which is the maximum number of road loads
    that can be performed before the superslide step

    Room_Dict is a dictionary where the keys are the room numbers (integer)
    and the values are the Rooms (Room struct)
    =#

    iteration_count = 0
    solutions_found = 0

    println("Beginning infinite loop...")

    # start an infinite loop
    while true

        for Transition_Count=0:Max_Transition_Count

            solution_found = Naive_Grotto_Solver(Transition_Count, Room_Dict, Allocation_List_Dict, Overlay_Dict, filename, Initial_Room_Number=Initial_Room_Number, Initial_Heap=Initial_Heap)

            iteration_count += 1

            if solution_found == true
                solutions_found += 1
                println("Solutions Found: $solutions_found")
            end

            if iteration_count%50000 == 0
                println("Iterations Completed: $iteration_count --- Solutions Found: $solutions_found")
            end

        end
    end
end
