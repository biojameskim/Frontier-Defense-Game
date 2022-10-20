module G = Graphics

type text_size =
  | GiantText
  | BigText
  | RegularText
  | SmallText
  | TinyText
  | CustomSizeText of int

let int_of_text_size text_size =
  match text_size with
  | GiantText -> 36
  | BigText -> 24
  | RegularText -> 16
  | SmallText -> 14
  | TinyText -> 12
  | CustomSizeText x -> x

type corner_box = int * int * int * int
(** A box defined by its top-left and bottom-right corners. *)

(** Represents a place on the screen and an instruction for how items with width
    [w] and height [h] should be placed relative to it. For instance,
    [draw_rect_from_placement ScreenCenter 50 50] places a 50x50 box at the
    center of the screen. [draw_rect_from_placement (Centered 300 300) 50 50]
    places the box centered at [(300, 300)].
    [draw_string_from_placement (CenterLeftAligned 100 100) "hello world"]
    places the text so that the center of the left edge is at [(100, 100)]. I
    think this makes the code more readable. *)
type placement =
  | CenterPlace of int * int (* the center point *)
  | TopLeftPlace of int * int (* the top-left corner point *)
  | CenterLeftPlace of int * int
    (* the point where the center of the left edge of the box should go *)
  | TopCenterPlace of int * int
    (* the point where the center of the top edge of the box should go *)
  | ScreenCenterPlace
  | ScreenTopLeftPlace
(* | RightAligned of int * int *)

let get_rect_center x y w h = (x + (w / 2), y + (h / 2))
let get_corner_box x y w h : corner_box = (x, y, x + w, y + h)

let rec place_box placement w h =
  match placement with
  | CenterPlace (x, y) -> get_rect_center x y ~-w ~-h
  | TopLeftPlace (x, y) -> (x, y)
  | CenterLeftPlace (x, y) -> (x, y - (h / 2))
  | TopCenterPlace (x, y) -> (x - (w / 2), y)
  | ScreenCenterPlace ->
      place_box (CenterPlace (G.size_x () / 2, G.size_y () / 2)) w h
  | ScreenTopLeftPlace -> place_box (TopLeftPlace (0, G.size_y () - 1)) w h

let draw_rect_from_points x0 y0 x1 y1 =
  assert (x0 < x1);
  assert (y0 < y1);
  (* current point is unchanged *)
  G.draw_rect x0 y0 (x1 - x0) (y1 - y0)

let draw_rect_from_placement placement ?(color = Palette.border) w h =
  G.set_color color;
  let x, y = place_box placement w h in
  draw_rect_from_points x y (x + w) (y + h)

let draw_grid placement cols rows cell_w cell_h f_draw_cell =
  let x_corner, y_corner =
    place_box placement (cols * cell_w) (rows * cell_h)
  in
  List.init rows (fun x -> x)
  |> List.map (fun row ->
         List.init cols (fun x -> x)
         |> List.map (fun col ->
                f_draw_cell col row
                  (x_corner + (col * cell_w))
                  (y_corner + (row * cell_h))))

let draw_reset_state () =
  G.moveto 0 0;
  G.set_color Palette.failure;
  G.set_line_width 1;
  G.set_text_size 18

let draw_string_from_placement placement ?(color = Palette.text)
    ?(size = RegularText) msg =
  G.set_color color;
  let w, h = G.text_size msg in
  let x, y = place_box placement w h in
  G.moveto x y;
  G.set_color color;
  G.set_text_size (int_of_text_size size);
  G.draw_string msg

let draw_button placement w h ?(text_color = Palette.button_text)
    ?(bg_color = Palette.button_bg) ?(text_size = RegularText) msg : corner_box
    =
  draw_rect_from_placement placement ~color:bg_color w h;
  let x, y = place_box placement w h in
  let x', y' = get_rect_center x y w h in
  draw_string_from_placement
    (CenterPlace (x', y'))
    ~color:text_color ~size:text_size msg;
  get_corner_box x y w h

let rec draw_row_lines (window_x : int) (window_y : int) (curr_y : int)
    (num_rows : int) =
  if curr_y < window_y then
    (G.moveto 0 curr_y;
     G.lineto window_x curr_y;
     draw_row_lines window_x window_y (curr_y + (window_y / num_rows)))
      num_rows
  else G.lineto window_x curr_y

let rec draw_col_lines (window_x : int) (window_y : int) (cur_x : int)
    (num_cols : int) =
  if cur_x < window_x then
    (G.moveto cur_x window_y;
     G.lineto cur_x 0;
     draw_col_lines window_x window_y (cur_x + (window_x / num_cols)))
      num_cols
  else G.lineto cur_x 0
