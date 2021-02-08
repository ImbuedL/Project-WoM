include("WoM_Heap_Structs.jl")

#=

There are only three cases that I care about in WoM:
  - Day 2 WoM with Kotake NOT flying in the woods AND the monkey still present (so Koume has not be saved yet AND the witch has NOT been activated yet)
  - Day 2 WoM with Kotake flying in the woods AND the monkey still present (so Koume has not been saved yet AND the witch HAS been activated)
  - Day 2 WoM with Kotake NOT flying in the woods AND the monkey is cleared (so Koume HAS been saved AND the witch is not flying in the woods anymore)

This file is dedicated to Day 2 WITH the monkey and WITHOUT Kotake

At the bottom, we define Room_Dict

Room Order: 1, 2, 5, 8, 7, 4, 3

100 : Possible to enter Plane with both Bomb and Smoke loaded
010 : Possible to enter Plane with Smoke loaded, but no Bomb loaded
001 : Possible to enter Plane with no Smoke loaded

Ideal order in which to define lists for a room:
 transition_list
 scene_load_actor_list
 actor_list_prev
 actor_list_next

=#

################################################################################

Room1_Transition_List = [
    Actor(
    name="Loading Plane",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[1, 2],
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room1_Scene_Load_Actor_List = [
    Actor(
    name="Loading Plane (Copy)",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=1,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (Copy)",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=1,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room1_Transition_List[1],
    Actor(
    name="Monkey",
    id="019E",
    size=0x3EC,
    overlay_type="A",
    address=0,
    room_number=false, # the Monkey allocates when you enter Room 1 and then stays allocated forever
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=1,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room1_Transition_List[1])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=1,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room1_Transition_List[1])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=1,
    priority=3,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room1_Transition_List[1])]
    ),
    Actor(
    name="Loading Plane (not transition)",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=1,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (not transition)",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=1,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Clock",
    id="015A",
    size=0x160,
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
]


Room1_Actor_List_Prev = [
    Room1_Scene_Load_Actor_List[1],
    Room1_Scene_Load_Actor_List[2],
    Room1_Transition_List[1], ################################## in reality this doesn't matter
    Room1_Scene_Load_Actor_List[4],
    Room1_Scene_Load_Actor_List[5],
    Room1_Scene_Load_Actor_List[6],
    Room1_Scene_Load_Actor_List[7],
    Room1_Scene_Load_Actor_List[8],
    Room1_Scene_Load_Actor_List[9]
]


Room1=Room(
    number = 1,
    actor_list_prev = Room1_Actor_List_Prev,
    actor_list_next = [], # empty since this is the first room (so it isn't the "next" room for any other room)
    scene_load_actor_list = Room1_Scene_Load_Actor_List,
    transition_list = Room1_Transition_List
)

################################################################################

Room2_Transition_List =[
    Room1_Transition_List[1], # loading plane transition=[1,2]
    Actor(
    name="Loading Plane",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[2, 5], # loading plane transition=[2,5]
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room2_Scene_Load_Actor_List = [
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Room1_Transition_List[1], # loading plane transition=[1,2]
    Actor(
    name="Grotto",
    id="0055",
    size=0x194,
    overlay_type="A",
    address=0,
    room_number=2,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false,
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=2,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room2_Transition_List[1]), ("010", Room2_Transition_List[2])]
    ),
    Room1_Scene_Load_Actor_List[10] # clock actor
]

Room2_Actor_List_Prev = [
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Room1_Transition_List[1], # loading plane transition=[1,2]
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from room 5 gets loaded here (before grotto)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=5,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room2_Scene_Load_Actor_List[3],
    Room2_Scene_Load_Actor_List[4]
]

Room2_Actor_List_Next = [
    Room1_Scene_Load_Actor_List[1], # plane copy from room 1 (appears first in list)
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Room1_Scene_Load_Actor_List[2], # plane copy from room 1 (appears directly before grotto; effectively since plane [1,2] already loaded)
    Room1_Transition_List[1], # loading plane transition=[1,2] ---- putting this here doesn't matter
    Room2_Scene_Load_Actor_List[3], # Grotto
    Room2_Scene_Load_Actor_List[4] # Grass
]


Room2 = Room(
    number = 2,
    actor_list_prev = Room2_Actor_List_Prev,
    actor_list_next = Room2_Actor_List_Next,
    scene_load_actor_list = Room2_Scene_Load_Actor_List,
    transition_list = Room2_Transition_List
)

################################################################################

Room5_Transition_List = [
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Actor(
    name="Loading Plane", # loading plane transition=[5,8]
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[5, 8],
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room5_Scene_Load_Actor_List = [
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Room5_Transition_List[2], # loading plane transition=[5,8]
    Room2_Actor_List_Prev[3], # loading plane copy from room 5
    Actor(
    name="Snapper",
    id="01BA",
    size=0x38C,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Deku Flower",
    id="0183",
    size=0x284,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Deku Flower",
    id="0183",
    size=0x284,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Mushroom Scent Cloud",
    id="023B",
    size=0x144,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room5_Transition_List[1]), ("011", Room5_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=5,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room5_Transition_List[1]), ("011", Room5_Transition_List[2])]
    ),
    Actor(
    name="Loading Plane (not transition)",
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=5,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room1_Scene_Load_Actor_List[10] # clock actor
]

Room5_Actor_List_Prev = [
    Room2_Transition_List[2], # loading plane transition=[2,5]
    Room2_Actor_List_Prev[3], # loading plane copy from room 5
    Room5_Scene_Load_Actor_List[4], # Snapper
    Room5_Scene_Load_Actor_List[5], # Deku Flower
    Room5_Scene_Load_Actor_List[6], # Deku Flower
    Room5_Scene_Load_Actor_List[7], # Mushroom Scent Cloud
    Room5_Scene_Load_Actor_List[8], # Grass
    Room5_Scene_Load_Actor_List[9], # Grass
    Room5_Scene_Load_Actor_List[10] # Loading Plane from room 5 (NOT a transition)
]

Room5_Actor_List_Next = [
    Room5_Scene_Load_Actor_List[1],
    Room5_Scene_Load_Actor_List[2],
    Room5_Scene_Load_Actor_List[3],
    Room5_Scene_Load_Actor_List[4],
    Room5_Scene_Load_Actor_List[5],
    Room5_Scene_Load_Actor_List[6],
    Room5_Scene_Load_Actor_List[7],
    Room5_Scene_Load_Actor_List[8],
    Room5_Scene_Load_Actor_List[9],
    Room5_Scene_Load_Actor_List[10]
]

Room5 = Room(
    number = 5,
    actor_list_prev = Room5_Actor_List_Prev, # TODO define this properly
    actor_list_next = Room5_Actor_List_Next,
    scene_load_actor_list = Room5_Scene_Load_Actor_List,
    transition_list = Room5_Transition_List
)

################################################################################

Room8_Transition_List = [
    Room5_Transition_List[2], # loading plane transition=[5,8]
    Actor(
    name="Loading Plane", # loading plane transition=[8,7]
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[8, 7],
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room8_Scene_Load_Actor_List = [
    Room5_Transition_List[2], # loading plane transition=[5,8]
    Room8_Transition_List[2], # loading plane transition=[8,7]
    Actor(
    name="Kotake",
    id="01B7",
    size=0x3DC,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=1,
    unloadable=false,
    clearable=true,
    cleared=true,   ########################### Kotake is cleared initially
    attempts_to_allocate_if_cleared=true,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room8_Transition_List[1]), ("010", Room8_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room8_Transition_List[1]), ("010", Room8_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=3,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room8_Transition_List[1]), ("010", Room8_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=4,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room8_Transition_List[1]), ("010", Room8_Transition_List[2])]
    ),
    Room1_Scene_Load_Actor_List[10], # clock actor
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=8,
    priority=5,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room8_Transition_List[1]), ("010", Room8_Transition_List[2])]
    )
]

Room8_Actor_List_Prev = [
    Room8_Transition_List[1], # loading plane transition=[5,8]
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from Room 7
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=7,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room8_Scene_Load_Actor_List[3], # Kotake (cleared)
    Room8_Scene_Load_Actor_List[4], # Grass
    Room8_Scene_Load_Actor_List[5], # Grass
    Room8_Scene_Load_Actor_List[6], # Grass
    Room8_Scene_Load_Actor_List[7], # Grass
    Actor(
    name="Clock Copy", # this clock copy allocates and then immediately deallocates
    id="015A",
    size=0x160,
    overlay_type="A",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=true,                         ########################################
    attempts_to_allocate_if_cleared=true, # dealing with this by making it cleared
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room8_Scene_Load_Actor_List[9] # Grass
]

Room8_Actor_List_Next = [
    Room8_Transition_List[2], # loading plane transition=[8,7]
    Room2_Actor_List_Prev[3], # loading plane copy from room 5
    Room8_Scene_Load_Actor_List[3], # Kotake (cleared)
    Room8_Scene_Load_Actor_List[4], # Grass
    Room8_Scene_Load_Actor_List[5], # Grass
    Room8_Scene_Load_Actor_List[6], # Grass
    Room8_Scene_Load_Actor_List[7], # Grass
    Room8_Actor_List_Prev[8], # Clock Copy
    Room8_Scene_Load_Actor_List[9] # Grass
]

Room8 = Room(
    number = 8,
    actor_list_prev = Room8_Actor_List_Prev,
    actor_list_next = Room8_Actor_List_Next,
    scene_load_actor_list = Room8_Scene_Load_Actor_List,
    transition_list = Room8_Transition_List
)

################################################################################

Room7_Transition_List = [
    Room8_Transition_List[2], # loading plane transition=[8,7]
    Actor(
    name="Loading Plane", # loading plane transition=[7,4]
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[7, 4],
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room7_Scene_Load_Actor_List = [
    Room7_Transition_List[2], # loading plane transition=[7,4]
    Room8_Actor_List_Prev[2], # loading plane copy from Room 7
    Room7_Transition_List[1], # loading plane transition=[8,7]
    Actor(
    name="Snapper",
    id="01BA",
    size=0x38C,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Deku Flower",
    id="0183",
    size=0x284,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Deku Flower",
    id="0183",
    size=0x284,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Mushroom Scent Cloud",
    id="023B",
    size=0x144,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room7_Transition_List[1]), ("011", Room7_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=7,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room7_Transition_List[1]), ("011", Room7_Transition_List[2])]
    ),
    Actor(
    name="Loading Plane (not transition)", # loading plane from Room 7 (not a transiton)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=7,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room1_Scene_Load_Actor_List[10] # clock actor
]

Room7_Actor_List_Prev = [
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from Room 4 (-440, 0, 0)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=4,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room8_Actor_List_Prev[2], # loading plane copy from Room 7
    Room7_Transition_List[1], # loading plane transition=[8,7]
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from Room 4 (-880, 0, -440)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=4,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room7_Scene_Load_Actor_List[4], # Snapper
    Room7_Scene_Load_Actor_List[5], # Deku Flower
    Room7_Scene_Load_Actor_List[6], # Deku Flower
    Room7_Scene_Load_Actor_List[7], # Mushroom Scent Cloud
    Room7_Scene_Load_Actor_List[8], # Grass
    Room7_Scene_Load_Actor_List[9], # Grass
    Room7_Scene_Load_Actor_List[10] # loading plane from Room 7 (not a transiton)
]

Room7_Actor_List_Next = [
    Room7_Transition_List[2], # loading plane transition=[7,4]
    Room8_Actor_List_Prev[2], # loading plane copy from Room 7
    Room7_Scene_Load_Actor_List[4], # Snapper
    Room7_Scene_Load_Actor_List[5], # Deku Flower
    Room7_Scene_Load_Actor_List[6], # Deku Flower
    Room7_Scene_Load_Actor_List[7], # Mushroom Scent Cloud
    Room7_Scene_Load_Actor_List[8], # Grass
    Room7_Scene_Load_Actor_List[9], # Grass
    Room7_Scene_Load_Actor_List[10] # loading plane from Room 7 (not a transiton)

]

Room7 = Room(
    number = 7,
    actor_list_prev = Room7_Actor_List_Prev,
    actor_list_next = Room7_Actor_List_Next,
    scene_load_actor_list = Room7_Scene_Load_Actor_List,
    transition_list = Room7_Transition_List
)

################################################################################

Room4_Transition_List = [
    Room7_Transition_List[2], # loading plane transition=[7,4]
    Actor(
    name="Loading Plane", # loading plane transition=[4,3]
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=[4, 3],
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room4_Scene_Load_Actor_List = [
    Room7_Actor_List_Prev[1], # loading plane copy from Room 4 (-440, 0, 0)
    Room4_Transition_List[1], # loading plane transition=[7,4]
    Room4_Transition_List[2], # loading plane transition=[4,3]
    Room7_Actor_List_Prev[4], # loading plane copy from Room 4 (-880, 0, -440)
    Actor(
    name="Snapper",
    id="01BA",
    size=0x38C,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Deku Flower",
    id="0183",
    size=0x284,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (not transition)", # loading plane from Room 4 (not a transiton) (-880, 0, -440)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=4,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (not transition)", # loading plane from Room 4 (not a transiton) (-440, 0, 0)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=4,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room1_Scene_Load_Actor_List[10], # clock actor
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room4_Transition_List[1]), ("011", Room4_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room4_Transition_List[1]), ("011", Room4_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=3,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room4_Transition_List[1]), ("011", Room4_Transition_List[2])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=4,
    priority=4,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("011", Room4_Transition_List[1]), ("011", Room4_Transition_List[2])]
    )
]

Room4_Actor_List_Prev = [
    Room7_Actor_List_Prev[1], # loading plane copy from Room 4 (-440, 0, 0)
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from Room 3 (-440, 0, 880)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (Copy)", # loading plane copy from Room 3 (-1320, 0, 880)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=true,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room4_Transition_List[1], # loading plane transition=[7,4]
    Room7_Actor_List_Prev[4], # loading plane copy from Room 4 (-880, 0, -440)
    Room4_Scene_Load_Actor_List[5], # Snapper
    Room4_Scene_Load_Actor_List[6], # Deku Flower
    Room4_Scene_Load_Actor_List[7], # loading plane from Room 4 (not a transiton) (-880, 0, -440)
    Room4_Scene_Load_Actor_List[8], # loading plane from Room 4 (not a transiton) (-440, 0, 0)
    Actor(
    name="Clock Copy", # this clock copy allocates and then immediately deallocates
    id="015A",
    size=0x160,
    overlay_type="A",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=true,                         ########################################
    attempts_to_allocate_if_cleared=true, # dealing with this by making it cleared
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room4_Scene_Load_Actor_List[10], # Grass
    Room4_Scene_Load_Actor_List[11], # Grass
    Room4_Scene_Load_Actor_List[12], # Grass
    Room4_Scene_Load_Actor_List[13], # Grass
]

Room4_Actor_List_Next = [
    Room7_Actor_List_Prev[1], # loading plane copy from Room 4 (-440, 0, 0)
    Room4_Transition_List[2], # loading plane transition=[4,3]
    Room8_Actor_List_Prev[2], # loading plane copy from Room 7
    Room7_Actor_List_Prev[4], # loading plane copy from Room 4 (-880, 0, -440)
    Room4_Scene_Load_Actor_List[5], # Snapper
    Room4_Scene_Load_Actor_List[6], # Deku Flower
    Room4_Scene_Load_Actor_List[7], # loading plane from Room 4 (not a transiton) (-880, 0, -440)
    Room4_Scene_Load_Actor_List[8], # loading plane from Room 4 (not a transiton) (-440, 0, 0)
    Room4_Actor_List_Prev[1], # Clock Copy (deallocates immediately)
    Room4_Scene_Load_Actor_List[10], # Grass
    Room4_Scene_Load_Actor_List[11], # Grass
    Room4_Scene_Load_Actor_List[12], # Grass
    Room4_Scene_Load_Actor_List[13], # Grass
]

Room4 = Room(
    number = 4,
    actor_list_prev = Room4_Actor_List_Prev,
    actor_list_next = Room4_Actor_List_Next,
    scene_load_actor_list = Room4_Scene_Load_Actor_List,
    transition_list = Room4_Transition_List
)

################################################################################

Room3_Transition_List = [
    Room4_Transition_List[2] # loading plane transition=[4,3]
]

Room3_Scene_Load_Actor_List = [
    Room4_Actor_List_Prev[2], # loading plane copy from Room 3 (-440, 0, 880)
    Room4_Actor_List_Prev[3], # loading plane copy from Room 3 (-1320, 0, 880)
    Room3_Transition_List[1], # loading plane transition=[4,3]
    Actor(
    name="Koume",
    id="0187",
    size=0x934,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false, # don't think I care
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Mushroom Scent Cloud",
    id="023B",
    size=0x144,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Monkey",
    id="019E",
    size=0x3EC,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Monkey",
    id="019E",
    size=0x3EC,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=1,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room3_Transition_List[1])]
    ),
    Actor(
    name="Grass",
    id="0090",
    size=0x19C,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=2,
    unloadable=true,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=true,
    valid_superslide_list=[("010", Room3_Transition_List[1])]
    ),
    Actor(
    name="Loading Plane (not transition)", # loading plane from Room 3 (not a transiton) (-440, 0, 880)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Loading Plane (not transition)", # loading plane from Room 3 (not a transiton) (-1320, 0, 880)
    id="0018",
    size=0x150,
    overlay_type="B",
    address=0,
    room_number=3,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room1_Scene_Load_Actor_List[10], # clock actor
    Actor(
    name="Square Sign",
    id="00A8",
    size=0x1F0,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Square Sign",
    id="00A8",
    size=0x1F0,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=2,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Actor(
    name="Square Sign",
    id="00A8",
    size=0x1F0,
    overlay_type="A",
    address=0,
    room_number=3,
    priority=3,
    unloadable=false,
    clearable=false,
    cleared=false,
    attempts_to_allocate_if_cleared=false,
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    )
]

Room3_Actor_List_Prev = [] # Room 3 is NOT previous to any room

Room3_Actor_List_Next = [
    Room7_Actor_List_Prev[1], # loading plane copy from Room 4 (-440, 0, 0)
    Room4_Actor_List_Prev[2], # loading plane copy from Room 3 (-440, 0, 880)
    Room4_Actor_List_Prev[3], # loading plane copy from Room 3 (-1320, 0, 880)
    Room7_Actor_List_Prev[4], # loading plane copy from Room 4 (-880, 0, -440)
    Room3_Scene_Load_Actor_List[4], # Koume
    Room3_Scene_Load_Actor_List[5], # Mushroom Scent Cloud
    Room3_Scene_Load_Actor_List[6], # Monkey
    Room3_Scene_Load_Actor_List[7], # Monkey
    Room3_Scene_Load_Actor_List[8], # Grass
    Room3_Scene_Load_Actor_List[9], # Grass
    Room3_Scene_Load_Actor_List[10], # loading plane from Room 3 (not a transiton) (-440, 0, 880)
    Room3_Scene_Load_Actor_List[11], # loading plane from Room 3 (not a transiton) (-1320, 0, 880)
    Actor(
    name="Clock Copy", # this clock copy allocates and then immediately deallocates
    id="015A",
    size=0x160,
    overlay_type="A",
    address=0,
    room_number=false,
    priority=1,
    unloadable=false,
    clearable=false,
    cleared=true,                         ########################################
    attempts_to_allocate_if_cleared=true, # dealing with this by making it cleared
    transition=false,
    plane_copy=false,
    grabbable_actor=false,
    valid_superslide_list=false
    ),
    Room3_Scene_Load_Actor_List[13], # Square Sign
    Room3_Scene_Load_Actor_List[14], # Square Sign
    Room3_Scene_Load_Actor_List[15] # Square Sign
]

Room3 = Room(
    number = 3,
    actor_list_prev = Room3_Actor_List_Prev,
    actor_list_next = Room3_Actor_List_Next,
    scene_load_actor_list = Room3_Scene_Load_Actor_List,
    transition_list = Room3_Transition_List
)

################################################################################


Room_Dict = Dict(
    1 => Room1,
    2 => Room2,
    5 => Room5,
    8 => Room8,
    7 => Room7,
    4 => Room4,
    3 => Room3
)
