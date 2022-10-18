let print_error msg = ANSITerminal.print_string [ ANSITerminal.red ] (msg ^ "\n")
let print_message msg = ANSITerminal.print_string [] (msg ^ "\n")
let print_welcome () = print_message "Welcome to Plants vs. Zombies!"
