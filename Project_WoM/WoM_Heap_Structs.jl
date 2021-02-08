import Base.@kwdef

#=

This file contains structs that are useful for defining things relevant to the actor heap

structs:
- Actor
- Overlay
- Node
- Room

=#

@kwdef mutable struct Actor

    #=

    name : string, name of the Actor
    id : actor id
    size : integer, actor size (number of bytes)
    overlay_type : "A" or "B", determines if the Overlay allocates into the relevant part of the actor heap
    address : the address in memory (i.e. the actor heap) of the actor
    room_number : the number of the room that the actor belongs to, or nothing
    priority : the priority of the actor; an index to differentiate copies of the same instance
    unloadable : a boolean for whether or not it is possible to deallocate this actor without changing rooms
    clearable : True if it is possible to set a flag to make this actor not respawn upon reloading the room (though, unless it it Category 5 {{{instead of using Category 5 we will use attempts_to_allocate_if_cleared}}}, it will attempt to reload and then immediately deallocate), False otherwise
    cleared : True if the flag was set to clear this actor, False otherwise
    attemots_to_allocate_if_cleared : whether or not the actor will attempt to allocate on room load when it is already cleared
    transition : False is the actor is not a Loading Plane or a Door. Otherwise, it is a list of the rooms that the transition actor connects, ordered from least to greatest room number
    plane_copy : true if the actor is a plane copy [this is unique to WoM] that we need to deallocate, false otherwise
    grabbable_actor : true if you want to consider this actor to be used for superslide SRM, false otherwise
    valid_superslide_list : list of the types of superslides allowed e.g. "bomb and smoke", "smoke", "no smoke", empty list [] if none.
                            EDIT: valid_superslide_list is a list of tuples in the form e.g. ("011", transition1) where the first entry is a binary string and the second is an actor that is a transition that you superslide through
                            Ex. [("011", transition1), ("010", transition2)]
    =#

    name
    id
    size
    overlay_type
    address
    room_number
    priority
    unloadable
    clearable
    cleared
    attempts_to_allocate_if_cleared
    transition
    plane_copy
    grabbable_actor
    valid_superslide_list


end

@kwdef mutable struct Overlay

    id
    size
    address

end

@kwdef mutable struct Node

    size
    address

end

@kwdef struct Room

    #=

    number : the room number
    actor_list : the list of actors in the room, in order ##### NEVERMIND; SEE BELOW*
    scene_load_actor_list : the list of actors in the room on scene load, in order (often the same as actor_list, but sometimes different)
    transition_list : the list of transitions to other rooms


    *Since this heap sim is specialized for WoM Day 2, the Room struct will not use Room.actor_list and instead
    will use Room.actor_list_prev and Room.actor_list_next. The rooms in WoM are in the order 1, 2, 5, 8, 7, 4, 3

    Example: If I enter Room 2 from Room 1, then I'll load the actors in Room 2 using Room2.actor_list_next since it is the Room
    that comes after Room 1 (i.e. it is the "next" room)

    Alternatively, if I enter Room 2 from Room 5, then I'll load the actors in Room 2 using Room2.actor_list_prev since Room 2
    is the room that comes directly before Room 5 (i.e. it is the "previous" room)


    Since the clock doesn't reallocate in the woods, we'll only ever include it in the scene_load_actor_list and then never deallocate it

    =#

    number
    actor_list_prev
    actor_list_next
    scene_load_actor_list
    transition_list

end
