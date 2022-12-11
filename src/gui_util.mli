(** Represents utilities for the gui *)

module G := Graphics

(** [text_size] is a type representing custom variants for varying text sizes. *)
type text_size =
  | GiantText
  | BigText
  | MediumText
  | RegularText
  | SmallText
  | TinyText
  | CustomSizeText of int

val int_of_text_size : text_size -> int
(** [int_of_text_size] returns an int based on a given [text_size]. *)

type point = int * int
(** [point] is the type of points (x,y). *)

type dim = int * int
(** [dim] is the type representing the dimension (w,h). *)

(** [placement] is the type representing various ways to place a box on the
    screen. *)
type placement =
  | CenterPlace of point
  | BottomLeftPlace of point
  | CenterLeftPlace of point
  | TopCenterPlace of point

(** [box] is the type representing various boxes that can be constructed. *)
and box =
  | CornerBox of point * point
  | PlacedBox of placement * dim
  | CornerDimBox of point * dim

val get_box_corners : box -> point * point
(** [get_box_corners b] returns the corners of a box [b]. *)

val placed_box : placement -> int -> int -> box
(** [placed_box p w h] returns a [PlacedBox] with placement [p] and dim [(w,h)]. *)

val get_box_center : box -> int * int
(** [get_box_center b] returns a point that represents the center of the box
    [b]. *)

val is_point_in_box : box -> int * int -> bool
(** [is_point_in_box b p] returns a bool that represents whether point [p]
    exists within box [b]. *)

val draw_rect_b : ?color:G.color -> ?bg:G.color -> box -> unit
(** [draw_rect_b ~color:c ~bg:bg b] draws a rectangle of border color [c],
    background color [bg] and bounds of [box]. Does not affect the current
    location of the pen. *)

val draw_and_fill_circle : ?color:G.color -> int -> int -> int -> unit
(** [draw_and_fill_circle ~color:c x y r] draws a circle with border color [c],
    center [(x,y)], and radius [r]. *)

val draw_grid :
  placement ->
  int ->
  int ->
  int ->
  int ->
  (int -> int -> int * int -> unit) ->
  unit
(** [draw_grid p c r w h f] draws a grid with placement [p], [c] number of
    columns, [r] number of rows, width per cell [w], height per cell [h], and
    [f] is a function such that [f r c (x, y)] will be called once for each cell
    of the grid where [r] is the index of the row, [c] is the index of the
    column, and [(x,y)] is the bottom left corner of the cell. *)

val draw_string_p :
  placement -> ?color:G.color -> ?size:text_size -> string -> unit
(** [draw_string_p p ~color:c ~size:ts msg] draws a string [msg] with placement
    [p], color [c], and text size [ts]. *)

val draw_button :
  box ->
  ?text_color:G.color ->
  ?border:G.color ->
  ?bg:G.color ->
  ?text_size:text_size ->
  string ->
  point * point
(** [draw_button b ~text_color:ts ~border:bd ~bg:bg ~text_size:ts msg] returns
    the corners of a box given a box [b], text color [ts], border [bd],
    background color [bg], text size [ts], and message [msg]. *)

val draw_image_with_placement : G.image -> int -> int -> placement -> unit
(** [draw_image_with_placement img w h p] draws a Graphics.image [img] given a
    width [w], height [h], and a placement [p]. *)
