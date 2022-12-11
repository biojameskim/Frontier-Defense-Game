open Gui_util
open Image_graphics
open Png
open Images

let draw (st : State.t) ev =
  let on_quit _ = exit 0 in
  let on_play st = st |> State.change_screen Screen.PlayScreen in
  draw_string_p (CenterPlace (1280 / 2, 650)) ~size:GiantText "Tutorial";
  draw_string_p
    (CenterPlace (1280 / 2, 550))
    ~size:BigText "Use your currency to buy defense before it is too late";
  (* draws and explains horse *)
  draw_string_p (CenterPlace (150, 420)) ~size:MediumText "Horse";
  draw_string_p (CenterPlace (150, 270)) ~size:MediumText "Destroys all";
  draw_string_p (CenterPlace (150, 245)) ~size:MediumText "enemies in row";
  draw_image_with_placement st.images.horse 100 70 (CenterPlace (150, 350));
  (* draws and explains base *)
  draw_string_p (CenterPlace (425, 420)) ~size:MediumText "Base";
  draw_string_p (CenterPlace (420, 270)) ~size:MediumText "Generates currency";
  draw_image_with_placement st.images.base_dark 83 100 (CenterPlace (420, 350));
  (* draws coin *)
  draw_and_fill_circle ~color:Palette.coin_yellow 640 360 40;
  draw_string_p ~size:GiantText (CenterPlace (643, 360)) "$";
  (* draws and explains soldiers *)
  draw_string_p (CenterPlace (990, 460)) ~size:MediumText "Soldiers";
  draw_string_p (CenterPlace (850, 420)) ~size:MediumText "Rifleman";
  draw_image_with_placement st.images.rifle_soldier_dark 83 100
    (CenterPlace (850, 350));
  draw_string_p (CenterPlace (990, 420)) ~size:MediumText "Rocket";
  draw_image_with_placement st.images.rocket_launcher_soldier_dark 76 100
    (CenterPlace (990, 350));
  draw_string_p (CenterPlace (1100, 420)) ~size:MediumText "Guard";
  draw_image_with_placement st.images.shield_soldier_dark 58 100
    (CenterPlace (1100, 350));
  draw_string_p (CenterPlace (990, 270)) ~size:MediumText "Defends off enemies";
  (* adds play and quit button*)
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (65, 25)) 130 50) "Quit")
    on_quit ev;
  draw_string_p (CenterPlace (645, 175)) ~size:MediumText "Ready to play?";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 120)) 130 50) "Play")
    on_play ev

let tick st = st
