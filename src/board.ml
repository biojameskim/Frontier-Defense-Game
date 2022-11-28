open Characters

(* model, defines t (the whole board), init makes the board filled with random
   stuff*)
let n_cols = 10
let n_rows = 5

type cell = { mutable plant : plant option }

type row = {
  cells : cell list;
  mutable zombies : zombie list;
  mutable peas : pea list;
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
              else
                Some
                  {
                    plant_type = WalnutPlant;
                    hp = 100;
                    location = (10, 30);
                    speed = 0;
                  });
          });
    zombies =
      [
        {
          zombie_type = RegularZombie;
          hp = 10;
          damage = 1;
          location = (1280, row * 100);
          speed = 1;
          frame = 0;
        };
        {
          zombie_type = TrafficConeHeadZombie;
          hp = 10;
          damage = 1;
          location = (1280, row * 100);
          speed = 1;
          frame = 0;
        };
      ];
    peas = [];
    lawnmower =
      Some { speed = 0; damage = 0; location = (10, row * 100); row = 0 };
  }

(* calls the init_row function n_rows time *)
let init () = { rows = List.init n_rows init_row }

(* spawn a zombie in a random row *)

type zombie = {
  hp : int;
  damage : int;
  location : int * int;
  speed : int;
  frame : int;
  zombie_type : zombie_type;
}

let spawn_zombie (zombie_type : zombie_type) (t : t) =
  let row_id = Random.int 5 in
  let row = row_id |> List.nth t.rows in
  let new_zombie =
    {
      zombie_type = RegularZombie;
      hp = 10;
      damage = 1;
      location = (1280, row_id * 100);
      speed = 1;
      frame = 0;
    }
  in
  ()
