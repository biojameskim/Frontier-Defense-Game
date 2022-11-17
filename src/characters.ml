(* defines types for zombies and plants *)
type zombie_type =
  | RegularZombie
  | TrafficConeHeadZombie
  | BucketHeadZombie

type zombie = {
  hp : int;
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
  plant_type : plant_type;
}

type pea_type =
  | RegularPea
  | FreezePea

(* speed should be just constant because the speed of the pea is the same for
   all plants (at least for now) *)
type pea = {
  pea_type : pea_type;
  damage : int;
  location : int * int;
  speed : int;
  speedChange : int;
  row : int;
}

type lawnmower = {
  damage : int;
  speed : int;
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
