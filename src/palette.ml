module G = Graphics

let black = G.black
let white = G.white
let border = 0x444488
let text = 0x111111
let button_text = 0x111111
let button_border = 0x115511
let button_bg = 0xDDFFDD
let field_base = G.rgb 92 199 70
let field_alternate = G.rgb 82 172 59
let plant_shop_brown = G.rgb 196 164 132
let stone_grey = G.rgb 145 142 133
let coin_yellow = G.rgb 243 199 13

(* Used for testing in order to indicate that a color should not be rendered
   onto the screen. *)
let failure = G.magenta
