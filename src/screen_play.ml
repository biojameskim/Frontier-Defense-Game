open Gui_util
open Characters
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw_dummy_graphic (x, y) str =
  draw_string_p (CenterPlace (x + 50, y + 50)) ~size:BigText str

(* draw single cell and add a clickable *)
let draw_cell row col (x, y) st ev =
  let cell = State.get_cell row col st in
  let box = CornerDimBox ((x, y), (100, 100)) in
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
    (fun st' ->
      Printf.printf "clicked cell %d %d\n%!" row col;
      st')
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

(* draws the grid *)
let draw (st : State.t) ev =
  draw_grid
    (TopLeftPlace (0, 0))
    num_cols num_rows 100 100
    (fun row col (x, y) -> draw_cell row col (x, y) st ev);
  st.board.rows |> List.iter (fun row -> draw_row row st)

(* changes to the state that should happen, add pea shot and moving *)
let tick (st : State.t) : State.t =
  let new_rows =
    st.board.rows
    |> List.map (fun (row : Board.row) ->
           { row with zombies = row.zombies |> List.map Characters.zombie_walk })
  in
  { st with board = { st.board with rows = new_rows } }

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
