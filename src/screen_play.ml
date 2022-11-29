open Gui_util
open Characters
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw_dummy_graphic (x, y) str =
  draw_string_p (CenterPlace (x + 50, y + 50)) ~size:BigText str

let get_plant_speed = function
  | PeaShooterPlant -> 5
  | IcePeaShooterPlant -> 5
  | WalnutPlant -> 0

(* draw single cell and add a clickable *)
let draw_cell row col (x, y) st ev =
  let cell = State.get_cell row col st in
  let box = CornerDimBox ((x, y), (1100 / num_cols, 720 / num_rows)) in
  draw_rect_b box
    ~bg:(if col mod 2 = 0 then Palette.field_base else Palette.field_alternate);
  (match cell.plant with
  | Some { plant_type } ->
      draw_dummy_graphic (x, y)
        (match plant_type with
        | PeaShooterPlant -> "P"
        | IcePeaShooterPlant -> "PI"
        | WalnutPlant -> "W")
  | None -> ());
  Events.add_clickable (get_box_corners box)
    (fun st ->
      match st.shop_selection with
      | None -> st
      | Some plant_type ->
          cell.plant <-
            Some
              {
                hp = 100;
                location = (x, y);
                plant_type;
                speed = get_plant_speed plant_type;
              };
          st.shop_selection <- None;
          st)
    ev

let draw_row (row : Board.row) (st : State.t) =
  row.zombies
  |> List.iter (fun { zombie_type; location } ->
         draw_dummy_graphic location
           (match zombie_type with
           | RegularZombie -> "Z"
           | TrafficConeHeadZombie -> "ZT"
           | BucketHeadZombie -> "ZB"));
  (match row.lawnmower with
  | Some { location } -> draw_dummy_graphic location "L"
  | None -> ());
  row.peas
  |> List.iter (fun { location; pea_type } ->
         draw_dummy_graphic location
           (match pea_type with
           | RegularPea -> "P"
           | FreezePea -> "PF"))

(* [draw_shop_items x y ev plant_type] draws the five boxes for the shop *)
let draw_shop_item x y ev plant_type =
  let box = CornerDimBox ((x, y), (180, 144)) in
  draw_rect_b ~bg:Palette.brown box;
  Events.add_clickable (get_box_corners box)
    (fun st -> { st with shop_selection = Some plant_type })
    ev

(* [draw_shop_items] calls draw_shop_item five times *)
let draw_shop_items ev =
  draw_shop_item 0 0 ev PeaShooterPlant;
  draw_shop_item 0 144 ev PeaShooterPlant;
  draw_shop_item 0 288 ev WalnutPlant;
  draw_shop_item 0 432 ev PeaShooterPlant

let coins = ref 0

(* draws the grid *)
let draw (st : State.t) ev =
  draw_grid
    (TopLeftPlace (180, 0))
    num_cols num_rows (1100 / num_cols) (720 / num_rows)
    (fun row col (x, y) -> draw_cell row col (x, y) st ev);
  st.board.rows |> List.iter (fun row -> draw_row row st);
  draw_shop_items ev;
  let on_pause st = st |> State.change_screen Screen.PauseScreen in
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1260, 700)) 40 40) "||")
    on_pause ev;
  let box = CornerDimBox ((0, 576), (180, 144)) in
  draw_rect_b ~bg:Palette.stone_grey box;
  draw_string_p (CenterPlace (150, 650)) (string_of_int !coins)

(* [make_game_lost_list st] is the list of booleans (one boolean for each zombie
   that is true if the zombie is at the x position of the end of the lawn)*)
let make_game_lost_list (st : State.t) =
  st.board.rows
  |> List.map (fun (row : Board.row) ->
         if row.zombies = [] then true
         else
           List.for_all
             (fun (zombie : zombie) ->
               match zombie.location with
               | x, y -> x > 150)
             row.zombies)

(* [is_game_lost st blist] pattern matches over blist (the bool list made from
   make_game_lost_list) and if any are true then a zombie has reached the end of
   the lawn, and the state switches screens to the end_lost screen *)
let rec is_game_lost (st : State.t) blist =
  match blist with
  | [] -> st
  | h :: t ->
      if h then is_game_lost st t
      else st |> State.change_screen Screen.EndScreenLost

(* [check_game_lost st] checks to see if the game is lost at the current game
   state *)
let check_game_lost st = is_game_lost st (make_game_lost_list st)

(* [timer_spawns_zombie st] checks the timer to see if another zombie should be
   spawned. If the timer reaches a certain amount, then a zombie is spawned in a
   random row *)
let timer_spawns_zombie (st : State.t) =
  if st.timer mod 5000 = 0 then
    Board.spawn_zombie RegularZombie { rows = st.board.rows }
  else { rows = st.board.rows }

(* [coin_auto_increment st] increments the coin counter if the timer reaches a
   certain threshold *)
let coin_auto_increment (st : State.t) =
  if st.timer mod 2500 = 0 then coins := !coins + 25 else ()

let coin_image = failwith "unimplemented"

(* changes to the state that should happen, add pea shot and moving *)
let tick (st : State.t) : State.t =
  st.timer <- st.timer + 25;
  coin_auto_increment st;
  let new_rows =
    (timer_spawns_zombie st).rows
    |> List.map (fun (row : Board.row) ->
           { row with zombies = row.zombies |> List.map Characters.zombie_walk })
  in

  let st = { st with board = { st.board with rows = new_rows } } in
  check_game_lost st

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
