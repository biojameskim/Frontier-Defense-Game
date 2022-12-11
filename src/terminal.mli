(** Represents messages printed to the terminal. *)

val print_error : string -> unit
(** [print_error msg] prints an error message [msg] to the terminal. *)

val print_message : string -> unit
(** [print_message msg] prints a message [msg] to the terminal. *)

val print_welcome : unit -> unit
(** [print_welcome msg] prints a welcome message [msg] to the terminal. *)
