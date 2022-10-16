type zombie_properties = {
  hp : int;
  damage : int;
  distance : int;
  speed : int;
  frame : int;
  row : int;
}

(* speed is the speed of how fast the plant shoots per state *)
type plant_properties = { hp : int; distance : int; speed : int; row : int }

(* speed should be just constant because the speed of the pea is the same for all plants
   (at least for now) *)
type pea_properties = {
  damage : int;
  distance : int;
  speed : int;
  speedChange : int;
  row : int;
}

type lawnmower_properties = {
  damage : int;
  speed : int;
  distance : int;
  row : int;
}

type sun_properties = { distance : int; row : int }

type zombie =
  | RegularZombie of zombie_properties
  | TrafficConeHeadZombie of zombie_properties
  | BucketHeadZombie of zombie_properties

type plant =
  | PeaShooterPlant of plant_properties
  | IcePeaShooterPlant of plant_properties
  | WalnutPlant of plant_properties

type pea = RegularPea of pea_properties | FreezePea of pea_properties
(* | FirePea of pea_properties *)

type lawnmower = Lawnmower of lawnmower_properties
type sun = Sun of sun_properties
type zombie_list = zombie list
type plant_list = plant list
type pea_list = pea list
