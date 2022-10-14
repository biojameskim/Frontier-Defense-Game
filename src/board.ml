open Characters

module Game = struct
  let n_cols = 10
  let n_rows = 5
  type cell = { 
    plant : plant option;
    zombie : zombie option;
    pea : pea option;
    lawnmower : lawnmower option
    }

(** cells represents the cells (grid block) in that row
  zombies represents the list of zombies in that row
  plants represents the list of plants in that row
  peas represents the list of peas in that row 
*)
  type row = {
  cells : cell list;
  zombies : zombie list;
  plants : plant list;
  peas : pea list;
  lawnmower : lawnmower
  }

  type t = {
  rows : row list
  }

  (* we want to intialitize the grid with an empty list of zombies, plants, and peas 
     because at the beginning, there are no zombies, plants, nor peas in the row. *)
  let init_row () = {
  cells = List.init n_cols (fun _ -> { plant = None });
  zombies = []
  plants = []
  peas = []
  }
  
  let init () = {
  rows = List.init n_rows (fun _ -> init_row ())
  }
end
  
let game = Game.init ()
  