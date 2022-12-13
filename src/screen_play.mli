(** Represents the main play screen in the game. *)

module G := Graphics

val draw_cell_plant :
  int -> Gui_util.box -> State.t -> Characters.plant_type -> unit
(** [draw_cell_plant col box st plant_type] draws a plant within a cell given
    its column, box, state, and plant type. *)

val draw_row_zombies : Characters.zombie list -> State.t -> unit
(** [draw_row_zombies zs st] draws the zombies in a row. *)

val draw_row_peas : Characters.pea list -> State.t -> unit
(** [draw_row_peas ps st] draws the peas in a row. *)

val draw_shop_item_init :
  int -> int -> State.t -> Events.t -> Characters.plant_type -> unit
(** [draw_shop_item_init x y st ev plant_type] draws a single shop item. *)

val draw_shovel : State.t -> Events.t -> unit
(** [draw_shovel st ev] draws the shovel icon and adds clickables for it. *)

val draw_coin_track : State.t -> unit
(** [draw_coin_track st] draws the big coin tracker. *)

val tick_init : State.t -> unit
(** Increment the timer, add free coins, change the level if necessary, and do
    other actions. *)

val tick_zombie_plant_collisions : Board.row -> unit
(** Facilitate collisions between plants and zombies, including everything to be
    done*)

val tick_collision_peas_zombies_hp : Board.row -> unit
(** Check collisions between peas and zombies, and subtract hp from zombies as
    needed *)

val tick_collision_peas_zombies_remove_peas : Board.row -> unit
(** Check collisions between peas and zombies, and remove peas if needed*)

val tick_collision_zombies_lawnmowers : Board.row -> unit
(** Make lawnmowers collide with zombies and walk. *)

val tick_plants : State.t -> Board.row -> unit
(** Removes all plants that have non-positive HP on board. Trigger timer events
    of the plants, shooting peas and generating sun from bases. *)

val tick_post : State.t -> State.t
(** Perform post-tick actions. *)

val num_rows : int
(** [num_rows] is the number of rows in the board grid (field). *)

val num_cols : int
(** [num_cols] is the number of columns in the board grid (field). *)

val can_buy : State.t -> Characters.plant_type -> bool
(** [can_buy st p] returns whether you have enough coins to buy plant [p] in
    state [st]. *)

val decrement_coins : State.t -> Characters.plant_type -> unit
(** [decrement_coins st p] decrements the coin counter by the amount that plant
    [p] costs in state [st]. *)

val handle_clickable : Gui_util.box -> State.t -> Board.cell -> Events.t -> bool
(** [handle_clickable b st c ev] handles buying a plany from shop box [b] and
    placing the corresponding plant if there are sufficient coins. This function
    also handles clicking the shovel in box [b] and using it to remove plants.
    Updates cell [c] depending on the action that was taken. *)

val draw_cell : int -> int -> int * int -> State.t -> Events.t -> unit
(** [draw_cell r cl (x,y) st ev] draws a cell in row [r] and column [cl] with
    corners [(x,y)] in state [st]. Also adds a clickable event [ev]. *)

val draw_coin : ?text:string -> int -> int -> int -> Gui_util.text_size -> unit
(** [draw_coin ?text:s x y r ts] draws a coin with center [(x,y)] and radius
    [r]. The text in the coin is [s] and the size of the text is [ts]. *)

val draw_row : Board.row -> State.t -> unit
(** [draw_row r st] draws row [r] given state [st]. *)

val draw_shop_item :
  Graphics.image ->
  int ->
  int ->
  int ->
  int ->
  State.t ->
  Events.t ->
  Characters.plant_type ->
  unit
(** [draw_shop_item img w h x y st ev pl] draws plant [pl] in the plant shop
    with image [img], width [w], height [h], and corner [(x,y)] in state [st].
    Adds a clickable event [ev] such that each shop item can be clicked. *)

val draw_shop_items : State.t -> Events.t -> unit
(** [draw_shop_items st ev] calls [draw_shop_item] four times for each shop item
    in the shop. *)

val display_message : State.t -> unit
(** [display_message st] prints a message on the display in state [st]. *)

val manage_shovel : State.t -> Events.t -> unit
(** [manage_shovel st ev] manages the state of the shovel. If the shovel is
    selected, a cancel button appears. *)

val draw : State.t -> Events.t -> unit
(** [draw st ev] draws the grid of the game in state [st]. *)

val make_game_not_lost_list : State.t -> bool list
(** [make_game_not_lost_list st] returns a list of booleans where each boolean
    represents a zombie in state [st]. The boolean is false if the zombie is at
    the start of the lawn, where the game would be lost. *)

val is_game_not_lost : State.t -> bool list -> State.t
(** [is_game_not_lost st blist] updates the state based on whether the game is
    lost or not at state [st]. Takes a boolean list generated from
    [make_game_not_lost_list st] and if any of the values inside the list is
    true, then a zombie has reached the start of the lawn and the
    [EndScreenLost] screen is displayed. *)

val check_game_not_lost : State.t -> State.t
(** [check_game_not_lost st] checks to see if the game is lost at the current
    game state [st] and updates the state accordingly. *)

val should_spawn_zombie : State.t -> int -> bool
(** [should_spawn_zombie st ln] checks the timer to see if another zombie should
    be spawned in the current state [st] and returns true if so. If the timer
    reaches a certain amount, then a zombie is spawned in a random row. This is
    based on the level number [ln]. *)

val timer_spawns_zombie : State.t -> unit
(** [timer_spawns_zombie st] spawns a zombie in state [st] if another zombie
    should be spawned according to [should_spawn_zombie st ln]. If the timer
    reaches a certain amount, then a zombie is spawned in a random row. *)

val is_time_to_give_coins : int -> State.t -> bool
(** [is_time_to_give_coins ln st] returns true if the timer reaches a certain
    threshold in state [st]. This threshold determines if it is time to give the
    user more coins. The minimum time required to give coins is determined by
    level number [ln]. *)

val coin_auto_increment : State.t -> int -> unit
(** [coin_auto_increment st ln] automatically increments the coin counter if
    [is_time_to_give_coins st ln] is true. *)

val zombies_on_board_row : Board.row list -> int
(** [zombies_on_board_row rows] is the total number of zombies that are on the
    board. *)

val zombies_in_level : int -> int
(** [zombies_in_level ln] is the number of zombies that are in level number
    [ln]. *)

val all_lvl_zombs_spawned : State.t -> int -> bool
(** [all_lvl_zombs_spawned st ln] returns true if all zombies for level number
    [ln] are on the board or have been killed. *)

val change_level_screen : State.t -> unit
(** [change_level_screen st] changes the screen of the current state [st]
    depending on the current level. The screen can be changed either to the
    [LevelChangeScreen] if more levels exist or to the [EndScreenWin] if no more
    levels exist. *)

val change_level : State.t -> unit
(** [change_level st] changes the screen of the current state [st] to the
    [LevelChangeScreen] if all the zombies in that level have been killed. *)

val is_zombie_colliding_with_entity : int -> int -> Characters.zombie -> bool
(** [is_zombie_colliding_with_entity x w z] returns true if a zombie [z] is
    colliding with an entity of x-position [x] and width [w]. *)

val is_zombie_colliding_with_pea :
  bool -> Characters.pea -> Characters.zombie -> bool
(** [is_zombie_colliding_with_pea nt p z] returns true if zombie [z] is
    colliding with pea [p] when [nt] is false. If [nt] is true, this function
    returns true if zombie [z] is not colliding with pea [p]. *)

val is_pea_not_colliding_with_zombie :
  Characters.zombie -> Characters.pea -> bool
(** [is_pea_not_colliding_with_zombie z p] returns true if pea [p] is not
    colliding with zombie [z]. This is the same function as
    [is_zombie_colliding_with_pea] but with inputs in different order because it
    is needed in [tick] as a helper function. *)

val damage_zombie : Characters.zombie -> Characters.pea -> unit
(** [damage_zombie z p] subtracts the damage of pea [p] from the hp of zombie
    [z] if they are colliding. *)

val add_to_zombies_killed : State.t -> Characters.zombie list -> unit
(** [add_to_zombies_killed st zl] increments [st.zombies_killed] for each zombie
    that has hp <= 0 in zombie list [zl] in state [st]. *)

val manage_message_length : State.t -> unit
(** [manage_message_length st] manages the duration of a message on the display
    in state [st]. *)

val tick : State.t -> State.t
(** [tick st] refreshes and updates the state [st] of the game. *)
