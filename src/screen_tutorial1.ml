open Gui_util
open Image_graphics
open Png
open Images

let draw (st : State.t) ev =
  let on_skip st = st |> State.change_screen Screen.PlayScreen in
  let on_home st = st |> State.change_screen Screen.HomeScreen in
  let on_quit _ = exit 0 in
  let on_next st = st |> State.change_screen Screen.TutorialScreen2 in
  draw_string_p
    (CenterPlace (1280 / 2, 585))
    ~size:BigText "Welcome to the frontier!";
  draw_string_p
    (CenterPlace (1280 / 2, 470))
    ~size:MediumText "Enemy soldiers are invading your territory";
  draw_string_p
    (CenterPlace (1280 / 2, 380))
    ~size:MediumText "Fight them off before they destroy your homeland";
  draw_image_with_placement st.images.regular_enemy_tutorial 89 100
    (CenterPlace (500, 260));
  draw_image_with_placement st.images.buff_enemy_tutorial 89 100
    (CenterPlace (640, 260));
  draw_image_with_placement st.images.shield_enemy_1_tutorial 89 100
    (CenterPlace (780, 260));
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1215, 695)) 130 50) "Skip")
    on_skip ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (65, 80)) 130 50) "Home")
    on_home ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (65, 25)) 130 50) "Quit")
    on_quit ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 125)) 130 50) "Next")
    on_next ev

let tick st = st
