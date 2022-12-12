open Gui_util

let draw (st : State.t) ev =
  let on_home st = State.init () in
  let on_quit _ = exit 0 in
  draw_string_p (CenterPlace (1280 / 2, 520)) ~size:GiantText "Congratulations!";
  draw_string_p
    (CenterPlace (1280 / 2, 430))
    ~size:BigText "The frontier lives on!";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 320)) 200 50) "Play Again")
    (fun st ->
      let new_game = State.init () in
      State.add_message "Level 1" 120 new_game;
      State.change_screen PlayScreen new_game)
    ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (565, 180)) 130 50) "Home")
    on_home ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (715, 180)) 130 50) "Quit")
    on_quit ev

let tick st = st
