open Gui_util
open Characters
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw_dummy_graphic (x, y) str =
  draw_string_p (CenterPlace (x + 50, y + 50)) ~size:BigText str

let draw_cell row col (x, y) st =
  let cell = State.get_cell row col st in
  draw_rect_b
    (CornerDimBox ((x, y), (100, 100)))
    ~bg:(if col mod 2 = 0 then Palette.field_base else Palette.field_alternate);
  match cell.plant with
  | Some { plant_type } ->
      draw_dummy_graphic (x, y)
        (match plant_type with
        | PeaShooterPlant -> "P"
        | IcePeaShooterPlant -> "PI"
        | WalnutPlant -> "W")
  | None -> ()

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

let draw (st : State.t) ev =
  draw_grid
    (TopLeftPlace (0, 0))
    num_cols num_rows 100 100
    (fun row col (x, y) -> draw_cell row col (x, y) st);
  st.board.rows |> List.iter (fun row -> draw_row row st)

let tick (st : State.t) : State.t =
  let new_rows =
    st.board.rows
    |> List.map (fun (row : Board.row) ->
           { row with zombies = row.zombies |> List.map Characters.zombie_walk })
  in
  { st with board = { st.board with rows = new_rows } }
