module G = Graphics

let draw_rect_from_points x0 y0 x1 y1 =
  assert (x0 < x1);
  assert (y0 < y1);
  G.draw_rect x0 y0 (x1 - x0) (y1 - y0)

let draw_reset_state () =
  G.moveto 0 0;
  G.set_color Palette.failure;
  G.set_line_width 1;
  G.set_text_size 18
