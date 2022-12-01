open Characters

(* model, defines t (the whole board), init makes the board filled with random
   stuff*)
let num_cols = 10
let num_rows = 5

type cell = { mutable plant : plant option }

type row = {
  cells : cell list;
  mutable zombies : zombie list;
  mutable peas : pea list;
  mutable lawnmower : lawnmower option;
}
(** cells represents the cells (grid block) in that row zombies represents the
    list of zombies in that row plants represents the list of plants in that row
    peas represents the list of peas in that row *)

type t = { rows : row list }

(** [init_row] intialitizes a row in the grid with an empty list of zombies,
    plants, and peas, and an initial lawnmower. *)
let init_row row_id =
  {
    cells = List.init num_cols (fun _ -> { plant = None });
    zombies = [];
    peas = [];
    lawnmower =
      Some
        {
          speed = 0;
          damage = 10000;
          location = (145, row_id * 144);
          row = row_id;
        };
  }

(* calls the init_row function n_rows time *)
let init () = { rows = List.init num_rows init_row }

(** [spawn_zombie zombie_type t] spawns a zombie *)
let spawn_zombie (zombie_type : zombie_type) (t : t) =
  let row_id = Random.int 5 in
  let row = row_id |> List.nth t.rows in
  let new_zombie =
    {
      zombie_type = RegularZombie;
      hp = 10;
      damage = 1;
      location = (1280, row_id * 144);
      speed = 10;
      frame = 0;
    }
  in
  row.zombies <- new_zombie :: row.zombies;
  t
