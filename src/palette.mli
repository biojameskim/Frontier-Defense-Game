(** Represents the color palette used for the game. *)

module G = Graphics

val black : G.color
(** [black] represents the color black. *)

val white : G.color
(** [white] represents the color white. *)

val border : int
(** [border] represents the color used for borders. *)

val text : int
(** [text] represents the color used for text. *)

val button_text : int
(** [button_text] represents the color used for button text. *)

val button_border : int
(** [button_border] represents the color used for button borders. *)

val button_bg : int
(** [button_bg] represents the color used for button backgrounds. *)

val field_base : G.color
(** [field_base] represents the color used for the default grid field column. *)

val field_alternate : G.color
(** [field_alternate] represents the color used for the alternate grid field
    column. *)

val plant_shop_brown : G.color
(** [plant_shop_brown] represents the color used for the plant shop background. *)

val stone_grey : G.color
(** [stone_grey] represents the color stone gray. *)

val coin_yellow : G.color
(** [coin_yellow] represents the color used for coins. *)

val failure : G.color
(** [failure] is used for testing in order to indicate that a color should not
    be rendered onto the screen. *)
