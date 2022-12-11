open Game

let main () =
  Terminal.print_welcome ();
  let fatal_exception =
    try
      let _ = Gui.launch (fun () -> State.init ()) in
      false
    with
    | Graphics.Graphic_failure msg ->
        Terminal.print_error ("Graphic failure: " ^ msg);
        true
    | e ->
        Terminal.print_error
          ("Error: " ^ Printexc.to_string e ^ " " ^ Printexc.get_backtrace ());
        true
  in

  if fatal_exception then Terminal.print_error "Frontier Defense game stopped."

let () = main ()
