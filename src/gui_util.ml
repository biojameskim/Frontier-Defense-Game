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
  | GiantText -> 60
  | BigText -> 36
  | RegularText -> 16
  | SmallText -> 14
  | TinyText -> 12
  | CustomSizeText x -> x

(** Represents a place on the screen and an instruction for how items with width
    [w] and height [h] should be placed relative to it. For instance,
    [draw_rect_from_placement ScreenCenter 50 50] places a 50x50 box at the
    center of the screen. [draw_rect_from_placement (Centered 300 300) 50 50]
    places the box centered at [(300, 300)].
    [draw_string_from_placement (CenterLeftAligned 100 100) "hello world"]
    places the text so that the center of the left edge is at [(100, 100)]. I
    think this makes the code more readable. *)

type point = int * int
type dim = int * int

type placement =
  | CenterPlace of point
  | TopLeftPlace of point
  | CenterLeftPlace of point
  | TopCenterPlace of point

and box =
  | CornerBox of point * point
  | PlacedBox of placement * dim
  | CornerDimBox of point * dim

(** Get the corners of a box. *)
let rec get_box_corners = function
  (* Overview: CornerBox and CornerDimBox are the base cases. A PlacedBox is
     converted to a CornerDimBox by figuring out what the top-left corner should
     be. *)
  | CornerBox (corner1, corner2) -> (corner1, corner2)
  | CornerDimBox ((x, y), (w, h)) -> ((x, y), (x + w, y + h))
  | PlacedBox (p, ((w, h) as dim)) -> (
      match p with
      | CenterPlace (x, y) ->
          get_box_corners (CornerDimBox ((x - (w / 2), y - (h / 2)), dim))
      | TopLeftPlace (x, y) -> get_box_corners (CornerDimBox ((x, y), dim))
      | CenterLeftPlace (x, y) ->
          get_box_corners (CornerDimBox ((x, y - (h / 2)), dim))
      | TopCenterPlace (x, y) ->
          get_box_corners (CornerDimBox ((x - (w / 2), y), dim)))

(** Utility function to define a placed box. *)
let placed_box placement w h = PlacedBox (placement, (w, h))

(** Get the center point of a box. *)
let get_box_center box =
  let (x1, y1), (x2, y2) = get_box_corners box in
  ((x1 + x2) / 2, (y1 + y2) / 2)

(** Test if a point is in a box. *)
let is_point_in_box box (x, y) =
  let (x1, y1), (x2, y2) = get_box_corners box in
  (* Printf.printf "is_point_in_box: %d %d %d %d %d %d\n" x1 y1 x2 y2 x y; *)
  x1 <= x && x <= x2 && y1 <= y && y <= y2

(** Draw a rectangle. Does not affect the current location of the pen. *)
let draw_rect_b ?(color = Palette.border) ?bg box =
  let (x1, y1), (x2, y2) = get_box_corners box in
  (match bg with
  | Some c ->
      G.set_color c;
      G.fill_rect x1 y1 (x2 - x1) (y2 - y1)
  | None -> ());
  G.set_color color;
  G.draw_rect x1 y1 (x2 - x1) (y2 - y1)

let draw_and_fill_circle ?(color = Palette.border) x y r =
  G.set_color color;
  G.draw_circle x y r;
  G.fill_circle x y r

let draw_grid placement cols rows cell_w cell_h f_draw_cell =
  let (x_corner, y_corner), _ =
    get_box_corners (PlacedBox (placement, (cols * cell_w, rows * cell_h)))
  in
  List.init rows (fun x -> x)
  |> List.iter (fun row ->
         List.init cols (fun x -> x)
         |> List.iter (fun col ->
                let x_cell = x_corner + (col * cell_w) in
                let y_cell = y_corner + (row * cell_h) in
                f_draw_cell row col (x_cell, y_cell)))

let draw_string_p placement ?(color = Palette.text) ?(size = RegularText) msg =
  G.set_font
    (Printf.sprintf "-*-fixed-medium-r-semicondensed--%d-*-*-*-*-*-iso8859-1"
       (int_of_text_size size));
  G.set_color color;
  let (x, y), _ = get_box_corners (PlacedBox (placement, G.text_size msg)) in
  G.moveto x y;
  G.set_color color;
  G.draw_string msg

let draw_string_big placement ?(color = Palette.text) ?(size = BigText) msg =
  G.set_font
    (Printf.sprintf "-*-fixed-medium-r-semicondensed--%d-*-*-*-*-*-iso8859-1"
       (int_of_text_size size));
  G.set_color color;
  let (x, y), _ = get_box_corners (PlacedBox (placement, G.text_size msg)) in
  G.moveto x y;
  G.set_color color;
  G.draw_string msg

let draw_button box ?(text_color = Palette.button_text)
    ?(border = Palette.button_border) ?(bg = Palette.button_bg)
    ?(text_size = BigText) msg : point * point =
  draw_rect_b box ~color:border ~bg;
  draw_string_p
    (CenterPlace (get_box_center box))
    ~color:text_color ~size:text_size msg;
  get_box_corners box

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

let rec init_lawnmowers (window_x : int) (window_y : int) (num_rows : int)
    (num_cols : int) (curr_y : int) =
  if curr_y < window_y then (
    let pos_x = window_x / (num_cols * 2) in
    let pos_y = window_y / (num_rows * 2) in
    G.moveto pos_x pos_y;
    G.draw_circle pos_x curr_y 20;
    init_lawnmowers window_x window_y num_rows num_cols
      (curr_y + (window_y / num_rows)))
  else G.draw_circle 0 0 0

let find_dist (window_x : int) (num_cols : int) (is_plant : bool) =
  if is_plant = true then window_x - (window_x / num_cols / 2)
  else
    let box = window_x / num_cols in
    box + (window_x / num_cols / 2)

let rec draw_plants_or_zombies (window_x : int) (window_y : int) (curr_y : int)
    (num_rows : int) (num_cols : int) (is_plant : bool) =
  if curr_y < window_y then (
    let half_col = find_dist window_x num_cols is_plant in
    G.moveto half_col (curr_y + (window_y / num_rows / 2) - 25);
    G.set_font "-*-fixed-medium-r-semicondensed--50-*-*-*-*-*-iso8859-1";
    if is_plant then G.draw_char 'Z' else G.draw_char 'P';
    let new_y = curr_y + (window_y / num_rows) in
    draw_plants_or_zombies window_x window_y new_y num_rows num_cols is_plant)
  else G.draw_char ' '

let rec color_grid_alternate (window_x : int) (window_y : int) (num_cols : int)
    (curr_x : int) =
  if curr_x < window_x then (
    G.set_color (G.rgb 82 172 59);
    let width = window_x / num_cols in
    G.fill_rect curr_x 0 width window_y;
    color_grid_alternate window_x window_y num_cols (curr_x + (width * 2)))
  else G.fill_rect 0 0 0 0
