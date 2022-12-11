(** Represents functionality for images. *)

val array_of_image : Images.t -> int -> int -> int -> int array array
(** [array_of_image img r g b] takes in an Images.t [img] and converts it to a
    2d array of colors. [r, g, b] represent the rgb color that alpha values in
    the [img] will be set to. *)

val to_image : Images.t -> int -> int -> int -> Graphics.image
(** [to_image img r g b] returns a Graphics.image given an Images.t [img] and
    colors [r, g, b] for the rgb color that alpha values in the [img] will be
    set to. *)

val draw_image : int -> int -> Images.t -> int -> int -> int -> unit
(** [draw_image x y img r g b] draws an image [img] with lower left corner
    [(x,y)] and colors [r, g, b] for the rgb color that alpha values in the
    [img] will be set to. *)
