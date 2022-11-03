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
  | Some (PeaShooterPlant p) -> draw_dummy_graphic (x, y) "P"
  | Some (IcePeaShooterPlant p) -> draw_dummy_graphic (x, y) "PI"
  | Some (WalnutPlant p) -> draw_dummy_graphic (x, y) "PW"
  | None -> ()

let draw_row (row : Board.row) (st : State.t) =
  row.zombies
  |> List.iter (fun zombie ->
         match zombie with
         | RegularZombie { location } -> draw_dummy_graphic location "Z"
         | TrafficConeHeadZombie { location } ->
             draw_dummy_graphic location "ZT"
         | BucketHeadZombie { location } -> draw_dummy_graphic location "ZB");
  (match row.lawnmower with
  | Some (Lawnmower { location }) -> draw_dummy_graphic location "L"
  | None -> ());
  row.peas
  |> List.iter (fun pea ->
         match pea with
         | RegularPea { location } -> draw_dummy_graphic location "P"
         | FreezePea { location } -> draw_dummy_graphic location "PF")

let draw (st : State.t) ev =
  draw_grid
    (TopLeftPlace (0, 0))
    num_cols num_rows 100 100
    (fun row col (x, y) -> draw_cell row col (x, y) st);
  st.board.rows |> List.iter (fun row -> draw_row row st)

let tick st = st
