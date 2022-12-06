(* defines types for zombies and plants *)
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
}

type lawnmower = {
  damage : int;
  mutable speed : int;
  location : int * int;
  row : int;
}

type sun = {
  location : int * int;
  row : int;
}

(* gives you a new record of the zombie with new distance, makes the zombies
   walk *)
let zombie_walk (z : zombie) : zombie =
  let x, y = z.location in
  { z with location = (x - z.speed, y) }

(** [lawnmower_walk] Returns a new record of the lawnmower with new distance.
    This can be used to update the lawnmowers on the screen, making it appear as
    if they are moving across the screen. *)
let lawnmower_walk (l : lawnmower option) : lawnmower option =
  match l with
  | Some lm ->
      let x, y = lm.location in
      Some { lm with location = (x + lm.speed, y) }
  | None -> None
