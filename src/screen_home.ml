open Gui_util
open Image_graphics
open Png
open Images

let draw (st : State.t) ev =
  let on_play (st : State.t) =
    st.message <- Some "Level 1";
    st.message_length <- Some 120;
    st |> State.change_screen Screen.PlayScreen
  in
  let on_tutorial st = st |> State.change_screen Screen.TutorialScreen1 in
  let on_quit _ = exit 0 in
  draw_string_p (CenterPlace (1280 / 2, 570)) ~size:GiantText "Frontier Defense";
  (* row 1 *)
  draw_image_with_placement st.images.rifle_soldier_tutorial 89 100
    (CenterPlace (430, 410));
  draw_image_with_placement st.images.regular_bullet_tutorial 89 100
    (CenterPlace (550, 482));
  draw_image_with_placement st.images.regular_enemy_tutorial 89 100
    (CenterPlace (860, 410));
  (* row 2 *)
  draw_image_with_placement st.images.rocket_launcher_soldier_tutorial 89 100
    (CenterPlace (340, 310));
  draw_image_with_placement st.images.rocket_bullet_tutorial 89 100
    (CenterPlace (460, 382));
  draw_image_with_placement st.images.shield_soldier_tutorial 89 100
    (CenterPlace (520, 310));
  draw_image_with_placement st.images.shield_enemy_1_tutorial 89 100
    (CenterPlace (770, 310));
  draw_image_with_placement st.images.shield_enemy_2_tutorial 89 100
    (CenterPlace (950, 310));
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (645, 170)) 155 50) "Tutorial")
    on_tutorial ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (570, 100)) 130 50) "Play")
    on_play ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (720, 100)) 130 50) "Quit")
    on_quit ev

let tick st = st
