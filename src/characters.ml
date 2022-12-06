type zombie_type =
  | RegularZombie
  | TrafficConeHeadZombie
  | BucketHeadZombie

type zombie = {
  mutable hp : int;
  damage : int;
  location : int * int;
  speed : int;
  frame : int;
  zombie_type : zombie_type;
  width : int;
}

type plant_type =
  | PeaShooterPlant
  | IcePeaShooterPlant
  | WalnutPlant

(* speed is the speed of how fast the plant shoots per state *)
type plant = {
  hp : int;
  speed : int;
  mutable timer : int;
  location : int * int;
  plant_type : plant_type;
  cost : int;
  width : int;
}

type pea_type =
  | RegularPea
  | FreezePea

(* speed should be just constant because the speed of the pea is the same for
   all plants (at least for now) *)
type pea = {
  pea_type : pea_type;
  damage : int;
  mutable location : int * int;
  speed : int;
  width : int;
}

type lawnmower = {
  damage : int;
  mutable speed : int;
  location : int * int;
  row : int;
  width : int;
}

type sun = {
  location : int * int;
  row : int;
}

(** [zombie_walk zombie] gives you a new zombie with new distance, makes the
    zombies walk *)
let zombie_walk (z : zombie) : zombie =
  let x, y = z.location in
  { z with location = (x - z.speed, y) }

(** [lawnmower_walk lawnmower] Returns a new lawnmower with updated distance.
    This can be used to update the lawnmowers on the screen, making it appear as
    if they are moving across the screen. *)
let lawnmower_walk (l : lawnmower option) : lawnmower option =
  match l with
  | Some lm ->
      let x, y = lm.location in
      Some { lm with location = (x + lm.speed, y) }
  | None -> None

(** [spawn_pea plant] Returns a pea based on the type of the plant *)
let spawn_pea (pl : plant) : pea =
  match pl.plant_type with
  | WalnutPlant -> failwith "Cannot spawn a pea from a walnut plant"
  | IcePeaShooterPlant ->
      {
        pea_type = FreezePea;
        damage = 1;
        location = pl.location;
        speed = 10;
        width = 5;
      }
  | PeaShooterPlant ->
      {
        pea_type = RegularPea;
        damage = 1;
        location = pl.location;
        speed = 10;
        width = 5;
      }

(** [pea_walk pea] Returns a new pea with updated location. *)
let pea_walk ({ location = x, y } as p : pea) : unit =
  p.location <- (x + p.speed, y)
