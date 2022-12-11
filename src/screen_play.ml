open Gui_util
open Characters
open Image_graphics
open State
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw_dummy_graphic (x, y) str =
  draw_string_p (CenterPlace (x + 50, y + 50)) ~size:BigText str

(** [get_plant_cost plant] gets the cost of the specific plant *)
let get_plant_cost (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 5
  | PeaShooterPlant -> 5
  | IcePeaShooterPlant -> 10
  | WalnutPlant -> 25

(** [get_plant_hp plant] gets the hp of the specific plant *)
let get_plant_hp (plant : plant_type) : int =
  match plant with
  | SunflowerPlant -> 50
  | PeaShooterPlant -> 100
  | IcePeaShooterPlant -> 100
  | WalnutPlant -> 300

(** [get_plant_speed plant_type] gets the speed of the plant *)
let get_plant_speed = function
  | SunflowerPlant -> 0
  | PeaShooterPlant -> 125
  | IcePeaShooterPlant -> 250
  | WalnutPlant -> 0

(** [get_plant_width plant_type] gets the width of the plant *)
let get_plant_width = function
  | SunflowerPlant -> 15
  | PeaShooterPlant -> 15
  | IcePeaShooterPlant -> 15
  | WalnutPlant -> 15

(** [can_buy plant st plant] is whether they have enough coins to buy the plant *)
let can_buy (st : State.t) (plant : plant_type) : bool =
  st.coins - get_plant_cost plant >= 0

(** [decrement_coins st plant] decrements the coin counter by the amount that
    the defense costs *)
let decrement_coins (st : State.t) (plant : plant_type) : unit =
  st.coins <- st.coins - get_plant_cost plant

(** [buy_from_shop (x,y) box st cell] handles clicking the shop boxes and
    placing if coins are sufficient. *)
let buy_from_shop (x, y) box st (cell : Board.cell) ev =
  Events.add_clickable_return_hover (get_box_corners box)
    (fun st ->
      match st.shop_selection with
      | None -> st
      | Some plant_type ->
          if can_buy st plant_type then (
            cell.plant <-
              Some
                {
                  hp = get_plant_hp plant_type;
                  location = (x, y);
                  plant_type;
                  speed = get_plant_speed plant_type;
                  cost = get_plant_cost plant_type;
                  timer = 0;
                  width = get_plant_width plant_type;
                };
            decrement_coins st plant_type);
          st.shop_selection <- None;
          st)
    ev

let use_shovel (x, y) box st (cell : Board.cell) ev =
  Events.add_clickable (get_box_corners box)
    (fun st ->
      if st.is_shovel_selected = true then (
        cell.plant <- None;
        st.is_shovel_selected <- false;
        st.shop_selection <- None);
      st)
    ev;
  ()

(** [draw_cell row col (x,y) st ev] draw single cell and add a clickable *)
let draw_cell row col (x, y) st ev =
  let cell = State.get_cell row col st in
  let box = CornerDimBox ((x, y), (1100 / num_cols, 720 / num_rows)) in
  let is_hovering =
    buy_from_shop (x, y) box st cell ev && st.shop_selection <> None
  in
  draw_rect_b box
    ~bg:(if col mod 2 = 0 then Palette.field_base else Palette.field_alternate)
    ~color:(if is_hovering then Palette.coin_yellow else Palette.border)
    ~border_width:(if is_hovering then 5 else 1);
  (match cell.plant with
  | Some { plant_type } ->
      (let info =
         match plant_type with
         | SunflowerPlant ->
             if col mod 2 = 0 then (st.images.base_light, 94, 100)
             else (st.images.base_dark, 94, 100)
         | PeaShooterPlant ->
             if col mod 2 = 0 then (st.images.rifle_soldier_light, 83, 100)
             else (st.images.rifle_soldier_dark, 83, 100)
         | IcePeaShooterPlant ->
             if col mod 2 = 0 then
               (st.images.rocket_launcher_soldier_light, 76, 100)
             else (st.images.rocket_launcher_soldier_dark, 76, 100)
         | WalnutPlant ->
             if col mod 2 = 0 then (st.images.shield_soldier_light, 58, 100)
             else (st.images.shield_soldier_dark, 58, 100)
       in
       let img, width, height = info in
       draw_image_with_placement img width height
         (CenterPlace (get_box_center box));
       ());
      ()
  | None -> ());
  use_shovel (x, y) box st cell ev

let draw_coin x y r text is_top_coin needs_offset =
  draw_and_fill_circle ~color:Palette.coin_yellow x y r;
  if is_top_coin then draw_string_p ~size:text (CenterPlace (x, y)) "$"
  else
    let dollar_offset = if needs_offset then 7 else 5 in
    draw_string_p ~size:text (CenterPlace (x - dollar_offset, y)) "$"

(** [draw_row row st] draws the char that represents each character *)

let draw_row (row : Board.row) (st : State.t) =
  row.zombies
  |> List.iter (fun { zombie_type; location } ->
         let x, y = location in
         let info =
           match zombie_type with
           | RegularZombie -> (st.images.regular_enemy, 89, 100)
           | TrafficConeHeadZombie -> (st.images.buff_enemy, 81, 100)
           | BucketHeadZombie -> (st.images.shield_enemy_1, 99, 100)
         in
         let img, width, height = info in
         draw_image_with_placement img width height (CenterPlace (x, y)));
  (match row.lawnmower with
  | Some { location = x, y } ->
      draw_image_with_placement st.images.horse 100 70 (CenterPlace (x, y))
  | None -> ());
  row.peas
  |> List.iter (fun { location; pea_type } ->
         let x, y = location in
         let info =
           match pea_type with
           | RegularPea -> (st.images.regular_bullet, 19, 10, 42, 25)
           | FreezePea -> (st.images.rocket_bullet, 20, 10, 38, 20)
         in
         let img, width, height, offset_x, offset_y = info in
         let offset_x = x + 50 + offset_x in
         let offset_y = y + 75 + offset_y in
         draw_image_with_placement img width height
           (CenterPlace (offset_x, offset_y)))

let draw_coin_amount x y plant_type =
  draw_string_p ~size:RegularText
    (CenterPlace (x, y))
    (string_of_int (get_plant_cost plant_type))

(** [draw_shop_items img w h x y st ev plant_type] draws the five boxes for the
    shop *)
let draw_shop_item img w h x y (st : State.t) ev plant_type =
  let box = CornerDimBox ((x, y), (180, 144)) in
  let is_hovering =
    Events.add_clickable_return_hover (get_box_corners box)
      (fun st -> { st with shop_selection = Some plant_type })
      ev
    || st.shop_selection = Some plant_type
  in
  if is_hovering then
    draw_rect_b ~bg:Palette.plant_shop_brown ~color:Palette.coin_yellow
      ~border_width:15 box
  else draw_rect_b ~bg:Palette.plant_shop_brown box;
  draw_image_with_placement img w h (BottomLeftPlace (x + 35, y + 25));
  let needs_offset = if get_plant_cost plant_type >= 10 then true else false in
  draw_coin (x + 150) (y + 120) 15 SmallText false needs_offset;
  draw_coin_amount (x + 155) (y + 120) plant_type;
  let plant_string, offset =
    match plant_type with
    | SunflowerPlant -> ("Base", 60)
    | PeaShooterPlant -> ("Rifleman", 50)
    | IcePeaShooterPlant -> ("Rocket Launcher", 10)
    | WalnutPlant -> ("Shield", 50)
  in
  draw_string_p (BottomLeftPlace (x + offset, y)) plant_string ~size:MediumText;
  Events.add_clickable (get_box_corners box)
    (fun st ->
      if st.is_shovel_selected then st.is_shovel_selected <- false;
      { st with shop_selection = Some plant_type })
    ev

(** [draw_shop_items st ev] calls draw_shop_item five times *)
let draw_shop_items (st : State.t) ev =
  draw_shop_item st.images.shield_soldier_shop 58 100 0 0 st ev WalnutPlant;
  draw_shop_item st.images.rocket_launcher_soldier_shop 76 100 0 144 st ev
    IcePeaShooterPlant;
  draw_shop_item st.images.rifle_soldier_shop 83 100 0 288 st ev PeaShooterPlant;
  draw_shop_item st.images.base_shop 83 100 0 432 st ev SunflowerPlant

(** [draw st ev] draws the grid *)
let draw (st : State.t) ev =
  draw_grid
    (BottomLeftPlace (180, 0))
    num_cols num_rows (1100 / num_cols) (720 / num_rows)
    (fun row col (x, y) -> draw_cell row col (x, y) st ev);
  st.board.rows |> List.iter (fun row -> draw_row row st);
  draw_shop_items st ev;
  let on_pause st = st |> State.change_screen Screen.PauseScreen in
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1265, 700)) 40 40) "||")
    on_pause ev;
  let shovel_center = PlacedBox (CenterPlace (1228, 65), (52, 100)) in
  Events.add_clickable
    (get_box_corners shovel_center)
    (fun st ->
      st.is_shovel_selected <- true;
      st)
    ev;
  let box = CornerDimBox ((0, 576), (180, 144)) in
  draw_rect_b ~bg:Palette.stone_grey box;
  draw_string_p ~size:BigText (CenterPlace (105, 680)) (string_of_int st.coins);

  (* draws top coin that tracks how many coins you have *)
  draw_coin 50 680 20 BigText true false;
  draw_string_p ~size:BigText
    (CenterPlace (90, 615))
    ("Level - " ^ string_of_int st.level);
  draw_image_with_placement st.images.shovel 52 100 (CenterPlace (1228, 65))

(** [make_game_not_lost_list st] is the list of booleans (one boolean for each
    zombie that is false if the zombie is at the x position of the end of the
    lawn.)*)
let make_game_not_lost_list (st : State.t) =
  st.board.rows
  |> List.map (fun (row : Board.row) ->
         if row.zombies = [] then true
         else
           List.for_all
             (fun (zombie : zombie) ->
               match zombie.location with
               | x, y -> x > 50)
             row.zombies)

(** [is_game_not_lost st blist] pattern matches over blist (the bool list made
    from make_game_lost_list) and if any are true then a zombie has reached the
    end of the lawn, and the state switches screens to the end_lost screen *)
let rec is_game_not_lost (st : State.t) blist =
  match blist with
  | [] -> st
  | h :: t ->
      if h then is_game_not_lost st t
      else (
        st.coins <- 0;
        st.level <- 1;
        st.zombies_killed <- 0;
        st |> State.change_screen Screen.EndScreenLost)

(** [check_game_not_lost st] checks to see if the game is lost at the current
    game state *)
let check_game_not_lost st = is_game_not_lost st (make_game_not_lost_list st)

(** [should_spawn_zombie st level_number] checks the timer to see if another
    zombie should be spawned. If the timer reaches a certain amount, then a
    zombie is spawned in a random row. This is based on levels *)
let should_spawn_zombie (st : State.t) (level_number : int) : bool =
  match level_number with
  | 1 -> st.timer mod 250 = 0
  | 2 -> st.timer mod 250 = 0
  | 3 -> st.timer mod 250 = 0
  | _ -> failwith "have not implemented those levels"

(** [timer_spawns_zombie st] checks the timer to see if another zombie should be
    spawned. If the timer reaches a certain amount, then a zombie is spawned in
    a random row *)
let timer_spawns_zombie (st : State.t) : Board.t =
  if should_spawn_zombie st st.level then
    Board.spawn_zombie st.level { rows = st.board.rows }
  else { rows = st.board.rows }

(** [is_time_to_give_coins level st] is if the timer reaches a certain
    threshold. It depends on the level if we want it to *)
let is_time_to_give_coins (level_number : int) (st : State.t) : bool =
  match level_number with
  | 1 -> st.timer mod 250 = 0
  | 2 -> st.timer mod 250 = 0
  | 3 -> st.timer mod 250 = 0
  | _ -> failwith "have not implemented more levels"

(** [coin_auto_increment st] increments the coin counter if the timer reaches a
    certain threshold. The amount of coins you get and the timer multiple needed
    depends on the level *)
let coin_auto_increment (st : State.t) (level_number : int) : unit =
  if is_time_to_give_coins level_number st then st.coins <- st.coins + 25
  else ()

let rec zombies_on_board_row (rows : Board.row list) : int =
  match rows with
  | [] -> 0
  | row :: rest_of_rows ->
      List.length row.zombies + zombies_on_board_row rest_of_rows

(** [zombies_in_level level_number] is the amount of zombies that are in each
    level *)
let zombies_in_level level_number : int =
  match level_number with
  | 1 -> 10
  | 2 -> 25
  | 3 -> 50
  | _ -> failwith "have not implemented more levels "

(** [all_lvl_zombs_spawned st level_number] is if all zombies for that level are
    on the board or have been killed *)
let all_lvl_zombs_spawned (st : State.t) (level_number : int) : bool =
  match level_number with
  | 1 | 2 | 3 ->
      st.zombies_killed + st.zombies_on_board = zombies_in_level level_number
  | _ -> failwith "have not implemented more levels"

(** [change_level_screen st] changes the state screen to the level_change screen *)
let change_level_screen (st : State.t) =
  match st.level with
  | 1 | 2 | 3 -> st.screen <- LevelChangeScreen
  | _ -> failwith "levels not implemented"

(** [change_level st] determines if all zombies in that level were killed *)
let change_level (st : State.t) =
  if st.zombies_killed = zombies_in_level st.level then change_level_screen st
  else ()

(** [is_zombie_colliding_with_entity entity_x entity_width zombie] Check whether
    a zombie is colliding with an entity. *)
let is_zombie_colliding_with_entity (entity_x : int) (entity_width : int)
    ({ location = zombie_x, _; width = zombie_width } : zombie) : bool =
  abs (zombie_x - entity_x) < (entity_width / 2) + (zombie_width / 2)

(** [is_pea_colliding_with_zombie] checks whether a zombie is colliding with a
    pea if nt is false, and checks if a zombie is NOT colliding with a pea if nt
    is true *)
let is_zombie_colliding_with_pea (nt : bool) (pea : pea)
    ({ location = zombie_x, zombie_y; width = zombie_width } : zombie) : bool =
  let pea_x = fst pea.location in
  let check = abs (zombie_x - pea_x) < (zombie_width / 2) + (pea.width / 2) in
  if nt then not check else check

(** [is_pea_colliding_with_zombie] checks whether a pea is NOT colliding with a
    zombie *)
let is_pea_not_colliding_with_zombie
    ({ location = zombie_x, zombie_y; width = zombie_width } : zombie)
    (pea : pea) : bool =
  let pea_x = fst pea.location in
  not (abs (zombie_x - pea_x) < (zombie_width / 2) + (pea.width / 2))

(** [damage_zombie] subtracts a pea's damage from a zombie's hp if they are
    colliding*)
let damage_zombie (zombie : zombie) (pea : pea) : unit =
  if not (is_pea_not_colliding_with_zombie zombie pea) then
    zombie.hp <- zombie.hp - pea.damage
  else ()

let rec add_to_zombies_killed (st : State.t) (zlist : zombie list) =
  match zlist with
  | [] -> ()
  | h :: t ->
      if h.hp <= 0 then (
        st.zombies_killed <- st.zombies_killed + 1;
        add_to_zombies_killed st t)
      else add_to_zombies_killed st t

(** [tick st] refreshes and updates the state of the game *)
let tick (st : State.t) : State.t =
  print_endline (string_of_bool st.is_shovel_selected);
  (* Increment the timer, add free coins, and change the level if necessary. *)
  st.timer <- st.timer + 1;
  coin_auto_increment st st.level;
  change_level st;
  let new_rows =
    (* Spawn zombies. *)
    let spawn_zombie_rows =
      if all_lvl_zombs_spawned st st.level then st.board.rows
      else (timer_spawns_zombie st).rows
    in

    (* Make zombies walk. *)
    let current_rows =
      spawn_zombie_rows
      |> List.map (fun (row : Board.row) ->
             {
               row with
               zombies = row.zombies |> List.map Characters.zombie_walk;
             })
    in
    (* Make peas walk. *)
    current_rows
    |> List.iter (fun (row : Board.row) -> row.peas |> List.iter pea_walk);

    (* changes the field for number of zombies on the board *)
    st.zombies_on_board <- zombies_on_board_row current_rows;
    (* Make lawnmowers collide with zombies and walk. *)
    current_rows
    |> List.iter (fun (row : Board.row) ->
           (match row.lawnmower with
           | Some lm ->
               let x, _ = lm.location in
               if x > 1280 then row.lawnmower <- None
               else if
                 List.exists (is_zombie_colliding_with_entity x 50) row.zombies
               then lm.speed <- 10
           | None -> ());
           row.lawnmower <- Characters.lawnmower_walk row.lawnmower);

    (* Kill zombies that hit lawnmowers. *)
    current_rows
    |> List.iter (fun ({ lawnmower; zombies } : Board.row) ->
           match lawnmower with
           | Some { location = x, _ } ->
               zombies
               |> List.iter (fun z ->
                      if is_zombie_colliding_with_entity x 50 z then
                        z.hp <- z.hp - 1000)
           | None -> ());
    (* Shoot peas from plants. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.cells
           |> List.iter (fun ({ plant } : Board.cell) ->
                  match plant with
                  | Some pl ->
                      pl.timer <- pl.timer + 1;
                      if pl.speed <> 0 && pl.timer mod pl.speed = 0 then
                        r.peas <- Characters.spawn_pea pl :: r.peas
                  | None -> ()));
    (* Check collisions between peas and zombies, and subtract hp from zombies
       as needed *)
    current_rows
    |> List.iter (fun (row : Board.row) ->
           match row.zombies with
           | [] -> ()
           | zbs ->
               let rec iter_peas ps =
                 match ps with
                 | [] -> ()
                 | h :: t ->
                     row.zombies <-
                       (let collided =
                          List.filter (is_zombie_colliding_with_pea false h) zbs
                        in
                        if List.length collided > 0 then (
                          let zb = List.nth collided 0 in
                          damage_zombie zb h;
                          zb
                          :: List.filter
                               (is_zombie_colliding_with_pea true h)
                               zbs)
                        else row.zombies);
                     iter_peas t
               in
               iter_peas row.peas);
    (* Check collisions between peas and zombies, and remove peas if needed*)
    current_rows
    |> List.iter (fun (row : Board.row) ->
           match row.peas with
           | [] -> ()
           | ps ->
               let rec destroy zbs =
                 match zbs with
                 | [] -> ()
                 | h :: t ->
                     row.peas <-
                       List.filter (is_pea_not_colliding_with_zombie h) ps;
                     destroy t
               in
               destroy row.zombies);
    (* add number of zombies with non_postive HP to st.zombies_killed *)
    current_rows
    |> List.iter (fun (r : Board.row) -> add_to_zombies_killed st r.zombies);
    (* Remove zombies with non-positive HP. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.zombies <- r.zombies |> List.filter (fun (z : zombie) -> z.hp > 0));

    (* Remove peas off the edge of the screen. *)
    current_rows
    |> List.iter (fun (r : Board.row) ->
           r.peas <-
             r.peas |> List.filter (fun ({ location = x, _ } : pea) -> x < 1280));

    current_rows
  in

  (* Create new state. *)
  let (new_board : Board.t) = { rows = new_rows } in
  let st = { st with board = new_board } in

  (* Finally, change the state if the game is lost. *)
  check_game_not_lost st
