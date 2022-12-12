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
(* cells represents the cells (grid block) in that row zombies represents the
   list of zombies in that row plants represents the list of plants in that row
   peas represents the list of peas in that row *)

type t = { rows : row list }

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
          location = (185, (720 / num_rows / 2) + (row_id * (720 / num_rows)));
          row = row_id;
          width = 50;
        };
  }

let init () = { rows = List.init num_rows init_row }

let spawn_zombie (category : int) : zombie_type =
  match category with
  | 0 -> RegularZombie
  | 1 -> TrafficConeHeadZombie
  | 2 -> BucketHeadZombie
  | _ -> failwith "impossible"

let spawn_zombie_by_level (level : int) : zombie_type =
  match level with
  | 1 -> spawn_zombie 0
  | 2 -> spawn_zombie (Random.int 2)
  | 3 -> spawn_zombie (Random.int 3)
  | _ -> failwith "levels not implemented"

let spawn_zombie (level : int) (t : t) =
  let row_id = Random.int 5 in
  let row = row_id |> List.nth t.rows in
  let new_zombie =
    Characters.spawn_zombie
      (1280, (720 / num_rows / 2) + (row_id * (720 / num_rows)))
      (spawn_zombie_by_level level)
  in
  row.zombies <- new_zombie :: row.zombies
