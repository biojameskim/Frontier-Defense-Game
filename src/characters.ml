type zombie_type =
  | RegularZombie
  | TrafficConeHeadZombie
  | BucketHeadZombie

type zombie = {
  mutable hp : int;
  damage : int;
  location : int * int;
  mutable speed : int;
  frame : int;
  zombie_type : zombie_type;
  width : int;
}

type plant_type =
  | PeaShooterPlant
  | IcePeaShooterPlant
  | WalnutPlant
  | SunflowerPlant

(* speed is the speed of how fast the plant shoots per state *)
type plant = {
  mutable hp : int;
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

let zombie_walk (z : zombie) : zombie =
  let x, y = z.location in
  { z with location = (x - z.speed, y) }

let lawnmower_walk (l : lawnmower option) : lawnmower option =
  match l with
  | Some lm ->
      let x, y = lm.location in
      Some { lm with location = (x + lm.speed, y) }
  | None -> None

let spawn_pea (pl : plant) : pea =
  match pl.plant_type with
  | SunflowerPlant -> failwith "Cannot spawn a pea from a sunflower"
  | WalnutPlant -> failwith "Cannot spawn a pea from a walnut plant"
  | IcePeaShooterPlant ->
      {
        pea_type = FreezePea;
        damage = 20;
        location = pl.location;
        speed = 5;
        width = 5;
      }
  | PeaShooterPlant ->
      {
        pea_type = RegularPea;
        damage = 20;
        location = pl.location;
        speed = 5;
        width = 5;
      }

let spawn_zombie (location : Gui_util.point) (zombie_type : zombie_type) :
    zombie =
  let hp, damage, speed =
    match zombie_type with
    | RegularZombie ->
        (200, 2, 4) (* in the original game, 100 damage per second *)
    | TrafficConeHeadZombie -> (640, 2, 4)
    | BucketHeadZombie -> (1370, 2, 4)
  in
  { zombie_type; hp; damage; speed; location; frame = 0; width = 15 }

let pea_walk ({ location = x, y } as p : pea) : unit =
  p.location <- (x + p.speed, y)
