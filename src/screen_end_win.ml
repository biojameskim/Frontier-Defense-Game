open Gui_util

let draw (st : State.t) ev =
  let on_home st = State.init () in
  let on_quit _ = exit 0 in
  draw_string_p
    (CenterPlace (1280 / 2, 480))
    ~size:BigText "Congrats! You have successfully defended off the enemies";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 350)) 130 50) "Restart")
    (fun st ->
      let new_game = State.init () in
      new_game.screen <- PlayScreen;
      new_game.message <- Some "Level 1";
      new_game.message_length <- Some 120;
      new_game)
    ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (565, 180)) 130 50) "Home")
    on_home ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (715, 180)) 130 50) "Quit")
    on_quit ev

let tick st = st
