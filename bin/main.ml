open Game

let main () =
  Terminal.print_welcome ();
  let fatal_exception =
    try
      let _ = Gui.launch (State.init ()) in
      false
    with
    | Graphics.Graphic_failure msg ->
        Terminal.print_error ("Graphic failure: " ^ msg);
        true
    | _ ->
        Terminal.print_error
          ("Unknown error. Backtrace:" ^ Printexc.get_backtrace ());
        true
  in
  if fatal_exception then
    Terminal.print_error "Plants vs. Zombies game stopped."

let () = main ()