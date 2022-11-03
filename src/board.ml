open Characters

let n_cols = 10
let n_rows = 5

type cell = {
  plant : plant option;
      (* zombie : zombie option; *)
      (* pea : pea option; *)
      (* lawnmower : lawnmower option; *)
}

type row = {
  cells : cell list;
  zombies : zombie list;
  (* plants : plant list; *)
  peas : pea list;
  lawnmower : lawnmower option;
}
(** cells represents the cells (grid block) in that row zombies represents the
    list of zombies in that row plants represents the list of plants in that row
    peas represents the list of peas in that row *)

type t = { rows : row list }

(* we want to intialitize the grid with an empty list of zombies, plants, and
   peas because at the beginning, there are no zombies, plants, nor peas in the
   row. *)
let init_row row =
  {
    cells =
      List.init n_cols (fun _ ->
          {
            plant =
              (if Random.bool () then None
              else Some (WalnutPlant { hp = 100; speed = 0 }));
          });
    zombies =
      [
        RegularZombie
          {
            hp = 10;
            damage = 1;
            location = (500 + Random.int 500, row * 100);
            speed = 1;
            frame = 0;
          };
        RegularZombie
          {
            hp = 10;
            damage = 1;
            location = (500 + Random.int 500, row * 100);
            speed = 1;
            frame = 0;
          };
      ];
    peas = [];
    lawnmower =
      Some
        (Lawnmower
           { speed = 0; damage = 0; location = (10, row * 100); row = 0 });
  }

let init () = { rows = List.init n_rows init_row }
