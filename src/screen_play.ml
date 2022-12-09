open Gui_util
open Characters
open Image_graphics
open State
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw_dummy_graphic (x, y) str =
  draw_string_p (CenterPlace (x + 50, y + 50)) ~size:BigText str

(** [get_plant_cost plant] gets the cost of the specific plant *)
let get_plant_cost (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 5
  | PeaShooterPlant -> 5
  | IcePeaShooterPlant -> 10
  | WalnutPlant -> 65

(** [get_plant_hp plant] gets the hp of the specific plant *)
let get_plant_hp (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 50
  | PeaShooterPlant -> 100
  | IcePeaShooterPlant -> 100
  | WalnutPlant -> 300

(** [get_plant_speed plant_type] gets the speed of the plant *)
let get_plant_speed = function
  | SunflowerPlant -> 0
  | PeaShooterPlant -> 50
  | IcePeaShooterPlant -> 50
  | WalnutPlant -> 0

(** [get_plant_width plant_type] gets the width of the plant *)
let get_plant_width = function
  | SunflowerPlant -> 15
  | PeaShooterPlant -> 15
  | IcePeaShooterPlant -> 15
  | WalnutPlant -> 15

(** [can_buy plant st plant] is whether they have enough coins to buy the plant *)
let can_buy (st : State.t) (plant : plant_type) : bool =
  st.coins - get_plant_cost plant >= 0

(** [decrement_coins st plant] decrements the coin counter by the amount that
    the defense costs *)
let decrement_coins (st : State.t) (plant : plant_type) : unit =
  st.coins <- st.coins - get_plant_cost plant

(** [buy_from_shop (x,y) box st cell] handles clicking the shop boxes and
    placing if coins are sufficient. *)
let buy_from_shop (x, y) box st (cell : Board.cell) ev =
  Events.add_clickable (get_box_corners box)
    (fun st ->
      match st.shop_selection with
      | None -> st
      | Some plant_type ->
          if can_buy st plant_type then (
            cell.plant <-
              Some
                {
                  hp = get_plant_hp plant_type;
                  location = (x, y);
                  plant_type;
                  speed = get_plant_speed plant_type;
                  cost = get_plant_cost plant_type;
                  timer = 0;
                  width = get_plant_width plant_type;
                };
            decrement_coins st plant_type);
          st.shop_selection <- None;
          st)
    ev

(** [draw_cell row col (x,y) st ev] draw single cell and add a clickable *)
let draw_cell row col (x, y) st ev =
  let cell = State.get_cell row col st in
  let box = CornerDimBox ((x, y), (1100 / num_cols, 720 / num_rows)) in
  draw_rect_b box
    ~bg:(if col mod 2 = 0 then Palette.field_base else Palette.field_alternate);
  (match cell.plant with
  | Some { plant_type } ->
      Graphics.draw_image
        (match plant_type with
        | PeaShooterPlant -> st.images.rifle_soldier
        | IcePeaShooterPlant -> st.images.rocket_launcher_soldier
        | WalnutPlant -> st.images.shield_soldier
        | SunflowerPlant -> st.images.base)
        x y
  | None -> ());
  buy_from_shop (x, y) box st cell ev

(** [draw_row row st] draws the char that represents each character *)
let draw_row (row : Board.row) (st : State.t) =
  row.zombies
  |> List.iter (fun { zombie_type; location } ->
         let x, y = location in
         let info =
           match zombie_type with
           | RegularZombie -> (st.images.regular_enemy, 89, 100)
           | TrafficConeHeadZombie -> (st.images.buff_enemy, 81, 100)
           | BucketHeadZombie -> (st.images.shield_enemy_1, 99, 100)
         in
         let img, width, height = info in
         draw_image_with_placement img width height (CenterPlace (x, y)));
  (match row.lawnmower with
  | Some { location = x, y } ->
      draw_image_with_placement st.images.horse 100 70 (CenterPlace (x, y))
  | None -> ());
  row.peas
  |> List.iter (fun { location; pea_type } ->
         let x, y = location in
         let info =
           match pea_type with
           | RegularPea -> (st.images.regular_bullet, 19, 10)
           | FreezePea -> (st.images.rocket_bullet, 20, 10)
         in
         let img, width, height = info in
         draw_image_with_placement img width height
           (CenterPlace (x + 50, y + 75)))

(** [draw_shop_items img w h x y ev plant_type] draws the five boxes for the
    shop *)
let draw_shop_item img w h x y ev plant_type =
  let box = CornerDimBox ((x, y), (180, 144)) in
  draw_rect_b ~bg:Palette.plant_shop_brown box;
  draw_image_with_placement img w h (BottomLeftPlace (x + 35, y + 25));
  Events.add_clickable (get_box_corners box)
    (fun st -> { st with shop_selection = Some plant_type })
    ev

(** [draw_shop_items st ev] calls draw_shop_item five times *)
let draw_shop_items (st : State.t) ev =
  draw_shop_item
    (Image_graphics.to_image
       (Png.load "assets/soldiers/shield_soldier.png" [])
       196 164 132)
    58 100 0 0 ev WalnutPlant;
  draw_shop_item
    (Image_graphics.to_image
       (Png.load "assets/soldiers/rocket_launcher_soldier.png" [])
       196 164 132)
    76 100 0 144 ev IcePeaShooterPlant;
  draw_shop_item
    (Image_graphics.to_image
       (Png.load "assets/soldiers/rifle_soldier.png" [])
       196 164 132)
    83 100 0 288 ev PeaShooterPlant;
  draw_shop_item
    (Image_graphics.to_image
       (Png.load "assets/soldiers/base.png" [])
       196 164 132)
    83 100 0 432 ev SunflowerPlant

(** [draw st ev] draws the grid *)
let draw (st : State.t) ev =
  draw_grid
    (BottomLeftPlace (180, 0))
    num_cols num_rows (1100 / num_cols) (720 / num_rows)
    (fun row col (x, y) -> draw_cell row col (x, y) st ev);
  st.board.rows |> List.iter (fun row -> draw_row row st);
  draw_shop_items st ev;
  let on_pause st = st |> State.change_screen Screen.PauseScreen in
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1260, 700)) 40 40) "||")
    on_pause ev;
  let box = CornerDimBox ((0, 576), (180, 144)) in
  draw_rect_b ~bg:Palette.stone_grey box;
  draw_string_big (CenterPlace (105, 680)) (string_of_int st.coins);
  draw_and_fill_circle ~color:Palette.coin_yellow 50 680 20;
  draw_string_big (CenterPlace (52, 680)) "$";
  draw_string_big (CenterPlace (90, 615)) ("Level - " ^ string_of_int st.level)

(** [make_game_not_lost_list st] is the list of booleans (one boolean for each
    zombie that is false if the zombie is at the x position of the end of the
    lawn.)*)
let make_game_not_lost_list (st : State.t) =
  st.board.rows
  |> List.map (fun (row : Board.row) ->
         if row.zombies = [] then true
         else
           List.for_all
             (fun (zombie : zombie) ->
               match zombie.location with
               | x, y -> x > 50)
             row.zombies)

(** [is_game_not_lost st blist] pattern matches over blist (the bool list made
    from make_game_lost_list) and if any are true then a zombie has reached the
    end of the lawn, and the state switches screens to the end_lost screen *)
let rec is_game_not_lost (st : State.t) blist =
  match blist with
  | [] -> st
  | h :: t ->
      if h then is_game_not_lost st t
      else (
        st.coins <- 0;
        st.level <- 1;
        st.zombies_killed <- 0;
        st |> State.change_screen Screen.EndScreenLost)

(** [check_game_not_lost st] checks to see if the game is lost at the current
    game state *)
let check_game_not_lost st = is_game_not_lost st (make_game_not_lost_list st)

(** [should_spawn_zombie st level_number] checks the timer to see if another
    zombie should be spawned. If the timer reaches a certain amount, then a
    zombie is spawned in a random row. This is based on levels *)
let should_spawn_zombie (st : State.t) (level_number : int) : bool =
  match level_number with
  | 1 -> st.timer mod 100 = 0
  | 2 -> st.timer mod 200 = 0
  | 3 -> st.timer mod 200 = 0
  | _ -> failwith "have not implemented those levels"

(** [timer_spawns_zombie st] checks the timer to see if another zombie should be
    spawned. If the timer reaches a certain amount, then a zombie is spawned in
    a random row *)
let timer_spawns_zombie (st : State.t) : Board.t =
  if should_spawn_zombie st st.level then
    Board.spawn_zombie st.level { rows = st.board.rows }
  else { rows = st.board.rows }

(** [is_time_to_give_coins level st] is if the timer reaches a certain
    threshold. It depends on the level if we want it to *)
let is_time_to_give_coins (level_number : int) (st : State.t) : bool =
  match level_number with
  | 1 -> st.timer mod 100 = 0
  | 2 -> st.timer mod 100 = 0
  | 3 -> st.timer mod 120 = 0
  | _ -> failwith "have not implemented more levels"

(** [coin_auto_increment st] increments the coin counter if the timer reaches a
    certain threshold. The amount of coins you get and the timer multiple needed
    depends on the level *)
let coin_auto_increment (st : State.t) (level_number : int) : unit =
  if is_time_to_give_coins level_number st then st.coins <- st.coins + 25
  else ()

(** [zombies_on_board rows] is the number of zombies on the board at that given
    screen *)
let rec zombies_on_board (rows : Board.row list) : int =
  match rows with
  | [] -> 0
  | row :: rest_of_rows ->
      List.length row.zombies + zombies_on_board rest_of_rows

(** [zombies_in_level level_number] is the amount of zombies that are in each
    level *)
let zombies_in_level level_number : int =
  match level_number with
  | 1 -> 10
  | 2 -> 25
  | 3 -> 50
  | _ -> failwith "have not implemented more levels "

(** [all_lvl_zombs_spawned st level_number] is if all zombies for that level are
    on the board or have been killed *)
let all_lvl_zombs_spawned (st : State.t) (level_number : int) : bool =
  match level_number with
  | 1 | 2 | 3 ->
      st.zombies_killed + zombies_on_board st.board.rows
      = zombies_in_level level_number
  | _ -> failwith "have not implemented more levels"

(** [change_level_screen st] changes the state screen to the level_change screen *)
let change_level_screen (st : State.t) =
  match st.level with
  | 1 | 2 | 3 -> st.screen <- LevelChangeScreen
  | _ -> failwith "levels not implemented"

(** [change_level st] determines if all zombies in that level were killed *)
let change_level (st : State.t) =
  if st.zombies_killed = zombies_in_level st.level then change_level_screen st
  else ()

(** [is_zombie_colliding_with_entity entity_x entity_width zombie] Check whether
    a zombie is colliding with an entity. *)
let is_zombie_colliding_with_entity (entity_x : int) (entity_width : int)
    ({ location = zombie_x, _; width = zombie_width } : zombie) : bool =
  abs (zombie_x - entity_x) < (entity_width / 2) + (zombie_width / 2)

(** [tick st] refreshes and updates the state of the game *)
let tick (st : State.t) : State.t =
  (* Increment the timer, add free coins, and change the level if necessary. *)
  st.timer <- st.timer + 1;
  coin_auto_increment st st.level;
  change_level st;

  let new_rows =
    (* Spawn zombies. *)
    let spawn_zombie_rows =
      if all_lvl_zombs_spawned st st.level then st.board.rows
      else (timer_spawns_zombie st).rows
    in

    (* Make zombies walk. *)
    let current_rows =
      spawn_zombie_rows
      |> List.map (fun (row : Board.row) ->
             {
               row with
               zombies = row.zombies |> List.map Characters.zombie_walk;
             })
    in
    (* Make peas walk. *)
    current_rows
    |> List.iter (fun (row : Board.row) -> row.peas |> List.iter pea_walk);

    (* Make lawnmowers collide with zombies and walk. *)
    current_rows
    |> List.iter (fun (row : Board.row) ->
           (match row.lawnmower with
           | Some lm ->
               let x, _ = lm.location in
               if x > 1280 then row.lawnmower <- None
               else if
                 List.exists (is_zombie_colliding_with_entity x 50) row.zombies
               then lm.speed <- 10
           | None -> ());
           row.lawnmower <- Characters.lawnmower_walk row.lawnmower);

    (* Kill zombies that hit lawnmowers. *)
    current_rows
    |> List.iter (fun ({ lawnmower; zombies } : Board.row) ->
           match lawnmower with
           | Some { location = x, _ } ->
               zombies
               |> List.iter (fun z ->
                      if is_zombie_colliding_with_entity x 50 z then
                        z.hp <- z.hp - 1000)
           | None -> ());

    (* Shoot peas from plants. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.cells
           |> List.iter (fun ({ plant } : Board.cell) ->
                  match plant with
                  | Some pl ->
                      pl.timer <- pl.timer + 1;
                      if pl.speed <> 0 && pl.timer mod pl.speed = 0 then (
                        print_endline "spawn pea";
                        r.peas <- Characters.spawn_pea pl :: r.peas)
                  | None -> ()));

    (* Remove zombies with non-positive HP. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.zombies <- r.zombies |> List.filter (fun (z : zombie) -> z.hp > 0));

    (* Remove peas off the edge of the screen. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.peas <-
             r.peas |> List.filter (fun ({ location = x, _ } : pea) -> x < 1280));

    current_rows
  in

  (* Create new state. *)
  let (new_board : Board.t) = { rows = new_rows } in
  let st = { st with board = new_board } in

  (* Finally, change the state if the game is lost. *)
  check_game_not_lost st

let get_plant_being_eaten_by_zombie (row : Board.row) (zombie : zombie) :
    plant option =
  raise (Failure "unimplemented")
(*List.find_opt (fun cell -> test_plant_collision_with_zombie row )*)

let test_plant_collision_with_zombie (plant : plant) (zombie : zombie) =
  raise (Failure "unimplemented")

let zombie_eat_plant (plant : plant) (zombie : zombie) = ()

let change_board_plant (st_old : State.t) =
  (*List.fold_left process_row st_old st_old.board.rows)*)
  raise (Failure "unimplemented")

(* fold left over all the old states, accumulator is the state *)
(* process row should be getting its row from process_row's state.old *)

let make_zombies_eat_plants (st_old : State.t) : State.t =
  raise (Failure "unimplemented")
(*List.fold_left process_row st_old [0;1;2;3;4]*)

let process_row (st_old : State.t) : State.t =
  (*(row : row)*) raise (Failure "Unimplemented")
(*List.fold_left process_zombies st_old (List.nth st_old.board.rows
  row).zombies*)
