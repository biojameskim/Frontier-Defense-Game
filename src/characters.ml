type zombie_type =
  | RegularZombie
  | TrafficConeHeadZombie
  | BucketHeadZombie

type zombie = {
  mutable hp : int;
  damage : int;
  mutable location : int * int;
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
  | RocketPea

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

let zombie_walk (z : zombie) : unit =
  let x, y = z.location in
  z.location <- (x - z.speed, y)

let lawnmower_walk (l : lawnmower option) : lawnmower option =
  match l with
  | Some lm ->
      let x, y = lm.location in
      Some { lm with location = (x + lm.speed, y) }
  | None -> None

let spawn_pea ({ location = x, y } as pl : plant) : pea =
  match pl.plant_type with
  | SunflowerPlant -> failwith "Cannot spawn a pea from a sunflower"
  | WalnutPlant -> failwith "Cannot spawn a pea from a walnut plant"
  | IcePeaShooterPlant ->
      {
        pea_type = RocketPea;
        damage = 20;
        location = (x + 38, y + 20);
        speed = 5;
        width = 5;
      }
  | PeaShooterPlant ->
      {
        pea_type = RegularPea;
        damage = 20;
        location = (x + 42, y + 25);
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
  { zombie_type; hp; damage; speed; location; frame = 0; width = 80 }

let pea_walk ({ location = x, y } as p : pea) : unit =
  p.location <- (x + p.speed, y)

let get_plant_cost (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 50
  | PeaShooterPlant -> 100
  | IcePeaShooterPlant -> 175
  | WalnutPlant -> 50

let get_plant_hp (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 300
  | PeaShooterPlant -> 300
  | IcePeaShooterPlant -> 600
  | WalnutPlant -> 4000

let get_plant_speed = function
  (* these go twice as fast as the original game (1.5 seconds / 45 ticks -> 0.75
     seconds / 22 ticks) *)
  | SunflowerPlant -> 12 * 30 (* every 12 seconds *)
  | PeaShooterPlant -> 22
  | IcePeaShooterPlant -> 22
  | WalnutPlant -> 0

let get_plant_width = function
  | SunflowerPlant -> 15
  | PeaShooterPlant -> 15
  | IcePeaShooterPlant -> 15
  | WalnutPlant -> 15

let spawn_plant box (plant_type : plant_type) =
  {
    hp = get_plant_hp plant_type;
    location = Gui_util.get_box_center box;
    plant_type;
    speed = get_plant_speed plant_type;
    cost = get_plant_cost plant_type;
    timer = 0;
    width = get_plant_width plant_type;
  }
