open Gui_util
open Image_graphics
open Png
open Images

let draw (st : State.t) ev =
  let on_quit _ = exit 0 in
  let on_home st = st |> State.change_screen Screen.HomeScreen in
  let on_play st = st |> State.change_screen Screen.PlayScreen in
  draw_string_p
    (CenterPlace (1280 / 2, 580))
    ~size:BigText "Use your currency to buy defense before it is too late";
  (* draws and explains horse *)
  draw_string_p (CenterPlace (150, 450)) ~size:MediumText "Horse";
  draw_string_p (CenterPlace (150, 300)) ~size:MediumText "Destroys all";
  draw_string_p (CenterPlace (150, 275)) ~size:MediumText "enemies in row";
  draw_image_with_placement st.images.horse_tutorial 100 70
    (CenterPlace (150, 380));
  (* draws and explains base *)
  draw_string_p (CenterPlace (425, 450)) ~size:MediumText "Base";
  draw_string_p (CenterPlace (420, 300)) ~size:MediumText "Generates currency";
  draw_image_with_placement st.images.base_tutorial 83 100
    (CenterPlace (420, 380));
  (* draws coin *)
  draw_and_fill_circle ~color:Palette.coin_yellow 650 380 40;
  draw_string_p (CenterPlace (653, 300)) ~size:MediumText "Currency";
  draw_string_p ~size:GiantText (CenterPlace (652, 380)) "$";
  (* draws and explains soldiers *)
  draw_string_p (CenterPlace (990, 490)) ~size:MediumText "Soldiers";
  draw_string_p (CenterPlace (850, 450)) ~size:MediumText "Rifleman";
  draw_image_with_placement st.images.rifle_soldier_tutorial 83 100
    (CenterPlace (850, 380));
  draw_string_p (CenterPlace (990, 450)) ~size:MediumText "Rocket";
  draw_image_with_placement st.images.rocket_launcher_soldier_tutorial 76 100
    (CenterPlace (990, 380));
  draw_string_p (CenterPlace (1100, 450)) ~size:MediumText "Guard";
  draw_image_with_placement st.images.shield_soldier_tutorial 58 100
    (CenterPlace (1100, 380));
  draw_string_p (CenterPlace (980, 300)) ~size:MediumText "Defends off enemies";
  (* adds play and quit button*)
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (65, 80)) 130 50) "Home")
    on_home ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (65, 25)) 130 50) "Quit")
    on_quit ev;
  draw_string_p
    (CenterPlace (645, 190))
    ~size:MediumText "Ready to enter the frontier?";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 115)) 130 60) "Play")
    on_play ev

let tick st = st
