open Gui_util
open Characters
open Image_graphics
open State
module G = Graphics

(* The general principle in balancing the game was to look at the video game
   Plants vs. Zombies 1 and make things go twice as fast. *)
(* https://plantsvszombies.fandom.com/wiki/Damage_per_shot was useful for some
   hard-to-find statistics for game balance. *)

let num_rows = 5
let num_cols = 10

let can_buy (st : State.t) (plant : plant_type) : bool =
  st.coins - Characters.get_plant_cost plant >= 0

let decrement_coins (st : State.t) (plant : plant_type) : unit =
  st.coins <- st.coins - Characters.get_plant_cost plant

let update_base_list st (plant : Characters.plant) =
  st.bases_on_screen <-
    List.filter
      (fun (compare_plant : Characters.plant) ->
        compare_plant.location <> plant.location)
      st.bases_on_screen

let handle_clickable box (st : State.t) (cell : Board.cell) (ev : Events.t) =
  Events.add_clickable_return_hover (get_box_corners box)
    (fun st ->
      (match st.shop_selection with
      | None -> ()
      | Some plant_type ->
          if can_buy st plant_type && cell.plant = None then (
            cell.plant <- Some (Characters.spawn_plant box plant_type);
            decrement_coins st plant_type;
            if st.timer < 40 * 30 && plant_type <> SunflowerPlant then
              st
              |> State.trigger_warning BuyBasesWarning
                   "Suggestion: buy more bases to get coins faster" 80;
            if plant_type = SunflowerPlant then
              st.bases_on_screen <-
                Characters.spawn_plant box plant_type :: st.bases_on_screen)
          else if cell.plant = None then
            st |> State.add_message "Not enough currency" 80;
          st.shop_selection <- None);
      if st.is_shovel_selected then (
        let _ = st |> State.update_shovel false in
        st.shop_selection <- None;
        if cell.plant = None then
          st |> State.add_message "Cell is already empty!" 80;
        let potential_sunflower = cell.plant in
        cell.plant <- None;
        match potential_sunflower with
        | None -> ()
        | Some compare_plant ->
            if compare_plant.plant_type = SunflowerPlant then
              update_base_list st compare_plant);
      st)
    ev

let draw_cell_plant col box st plant_type =
  let info =
    match plant_type with
    | SunflowerPlant ->
        if col mod 2 = 0 then (st.images.base_light, 94, 100)
        else (st.images.base_dark, 94, 100)
    | PeaShooterPlant ->
        if col mod 2 = 0 then (st.images.rifle_soldier_light, 83, 100)
        else (st.images.rifle_soldier_dark, 83, 100)
    | IcePeaShooterPlant ->
        if col mod 2 = 0 then (st.images.rocket_launcher_soldier_light, 76, 100)
        else (st.images.rocket_launcher_soldier_dark, 76, 100)
    | WalnutPlant ->
        if col mod 2 = 0 then (st.images.shield_soldier_light, 58, 100)
        else (st.images.shield_soldier_dark, 58, 100)
  in
  let img, width, height = info in
  draw_image_with_placement img width height (CenterPlace (get_box_center box));
  ()

let draw_cell row col (x, y) st ev =
  let cell = State.get_cell row col st in
  let box = CornerDimBox ((x, y), (1100 / num_cols, 720 / num_rows)) in
  let is_hovering =
    handle_clickable box st cell ev
    && (st.shop_selection <> None || st.is_shovel_selected)
  in
  draw_rect_b box
    ~bg:(if col mod 2 = 0 then Palette.field_base else Palette.field_alternate)
    ~color:(if is_hovering then Palette.coin_yellow else Palette.border)
    ~border_width:(if is_hovering then 5 else 1);
  match cell.plant with
  | Some { plant_type } -> draw_cell_plant col box st plant_type
  | None -> ()

let draw_coin ?(text = "$") x y r text_size =
  draw_and_fill_circle ~color:Palette.coin_yellow x y r;
  draw_string_p ~size:text_size (CenterPlace (x, y)) text

let draw_row_zombies zs st =
  zs
  |> List.iter (fun { zombie_type; location } ->
         let info =
           match zombie_type with
           | RegularZombie -> (st.images.regular_enemy, 89, 100)
           | TrafficConeHeadZombie -> (st.images.buff_enemy, 81, 100)
           | BucketHeadZombie -> (st.images.shield_enemy_1, 99, 100)
         in
         let img, width, height = info in
         draw_image_with_placement img width height (CenterPlace location))

let draw_row_peas ps st =
  ps
  |> List.iter (fun { location; pea_type } ->
         let info =
           match pea_type with
           | RegularPea -> (st.images.regular_bullet, 19, 10)
           | RocketPea -> (st.images.rocket_bullet, 20, 10)
         in
         let img, width, height = info in
         draw_image_with_placement img width height (CenterPlace location))

let draw_row (row : Board.row) (st : State.t) =
  st |> draw_row_zombies row.zombies;
  (match row.lawnmower with
  | Some { location = x, y } ->
      draw_image_with_placement st.images.horse 100 70 (CenterPlace (x, y))
  | None -> ());
  st |> draw_row_peas row.peas

let draw_shop_item_init x y st ev plant_type =
  let box = CornerDimBox ((x, y), (180, 144)) in
  let is_hovering =
    st.shop_selection = Some plant_type
    || Events.add_clickable_return_hover (get_box_corners box)
         (fun st ->
           {
             (st |> State.update_shovel false) with
             shop_selection = Some plant_type;
           })
         ev
  in
  if is_hovering then
    draw_rect_b ~bg:Palette.plant_shop_brown ~color:Palette.coin_yellow
      ~border_width:15 box
  else draw_rect_b ~bg:Palette.plant_shop_brown box

let draw_shop_item img w h x y (st : State.t) ev plant_type =
  draw_shop_item_init x y st ev plant_type;
  draw_image_with_placement img w h (BottomLeftPlace (x + 35, y + 25));
  draw_coin (x + 145) (y + 110) 25 SmallText
    ~text:("$" ^ (get_plant_cost plant_type |> string_of_int));
  let plant_string, offset =
    match plant_type with
    | SunflowerPlant -> ("Base", 60)
    | PeaShooterPlant -> ("Rifleman", 50)
    | IcePeaShooterPlant -> ("Rocket Launcher", 10)
    | WalnutPlant -> ("Shield", 50)
  in
  draw_string_p (BottomLeftPlace (x + offset, y)) plant_string ~size:MediumText

let draw_shop_items (st : State.t) ev =
  draw_shop_item st.images.shield_soldier_shop 58 100 0 0 st ev WalnutPlant;
  draw_shop_item st.images.rocket_launcher_soldier_shop 76 100 0 144 st ev
    IcePeaShooterPlant;
  draw_shop_item st.images.rifle_soldier_shop 83 100 0 288 st ev PeaShooterPlant;
  draw_shop_item st.images.base_shop 83 100 0 432 st ev SunflowerPlant

let display_message st =
  (* st.messages |> List.map fst |> String.concat " " |> print_endline; *)
  st.messages
  |> List.iteri (fun i (msg, _) ->
         draw_string_p
           (CenterPlace (1280 / 2, 360 - (i * 80)))
           ~size:BigText msg)

let manage_shovel st ev =
  if st.is_shovel_selected then
    Events.add_clickable
      (draw_button (placed_box (CenterPlace (1225, 70)) 110 50) "Cancel")
      (State.update_shovel false)
      ev

let draw_shovel st ev =
  let shovel_box = PlacedBox (CenterPlace (1228, 65), (52, 100)) in
  let is_shovel_hovered =
    Events.add_clickable_return_hover
      (get_box_corners shovel_box)
      (State.update_shovel true) ev
  in
  draw_image_with_placement st.images.shovel 52 100 (CenterPlace (1228, 65));
  if is_shovel_hovered then
    let shovel_border_box = PlacedBox (CenterPlace (1228, 65), (78, 126)) in
    draw_rect_b shovel_border_box ~color:Palette.coin_yellow ~border_width:8

let draw_coin_track st =
  let box = CornerDimBox ((0, 576), (180, 144)) in
  draw_rect_b ~bg:Palette.stone_grey box;
  draw_string_p ~size:BigText (CenterPlace (105, 680)) (string_of_int st.coins);
  draw_coin 50 680 20 BigText

let manage_base_messages st =
  if st.is_base_message_time then
    List.iter
      (fun (plant : Characters.plant) ->
        let x, y = plant.location in
        draw_string_p ~size:RegularText (CenterPlace (x + 47, y + 50)) "+ 25")
      st.bases_on_screen

let draw (st : State.t) ev =
  draw_grid
    (BottomLeftPlace (180, 0))
    num_cols num_rows (1100 / num_cols) (720 / num_rows)
    (fun row col (x, y) -> draw_cell row col (x, y) st ev);
  st.board.rows |> List.iter (fun row -> draw_row row st);
  draw_shop_items st ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1265, 700)) 40 40) "||")
    (State.change_screen PauseScreen)
    ev;
  draw_coin_track st;
  draw_string_p ~size:BigText
    (CenterPlace (90, 615))
    ("Level - " ^ string_of_int st.level);
  draw_shovel st ev;
  display_message st;
  manage_shovel st ev;
  manage_base_messages st

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

let check_game_not_lost st = is_game_not_lost st (make_game_not_lost_list st)

let should_spawn_zombie (st : State.t) (level_number : int) : bool =
  (* 30 seconds at the beginning to set up *)
  match level_number with
  | 1 -> st.timer > 30 * 30 && st.timer mod 250 = 0
  | 2 -> st.timer mod 250 = 0
  | 3 -> st.timer mod 250 = 0
  | _ -> failwith "Have not implemented those levels"

let timer_spawns_zombie (st : State.t) : unit =
  if should_spawn_zombie st st.level then
    st.board |> Board.spawn_zombie st.level

let is_time_to_give_coins (level_number : int) (st : State.t) : bool =
  (* 10 seconds in the original game, but we make ours a lot faster *)
  match level_number with
  | 1 -> st.timer mod 120 = 0
  | 2 -> st.timer mod 120 = 0
  | 3 -> st.timer mod 120 = 0
  | _ -> failwith "have not implemented more levels"

let coin_auto_increment (st : State.t) (level_number : int) : unit =
  if is_time_to_give_coins level_number st then st.coins <- st.coins + 25
  else ()

let rec zombies_on_board_row (rows : Board.row list) : int =
  match rows with
  | [] -> 0
  | row :: rest_of_rows ->
      List.length row.zombies + zombies_on_board_row rest_of_rows

let zombies_in_level level_number : int =
  match level_number with
  | 1 -> 10
  | 2 -> 25
  | 3 -> 50
  | _ -> failwith "Have not implemented more levels "

let all_lvl_zombs_spawned (st : State.t) (level_number : int) : bool =
  match level_number with
  | 1 | 2 | 3 ->
      st.zombies_killed + st.zombies_on_board = zombies_in_level level_number
  | _ -> failwith "Have not implemented more levels"

let change_level_screen (st : State.t) =
  match st.level with
  | 1 | 2 -> st.screen <- LevelChangeScreen
  | 3 -> st.screen <- EndScreenWin
  | _ -> failwith "Levels not implemented"

let change_level (st : State.t) =
  if st.zombies_killed = zombies_in_level st.level then change_level_screen st
  else ()

let is_zombie_colliding_with_entity (entity_x : int) (entity_width : int)
    ({ location = zombie_x, _; width = zombie_width } : zombie) : bool =
  abs (zombie_x - entity_x) < (entity_width / 2) + (zombie_width / 2)

let is_zombie_colliding_with_pea (nt : bool) (pea : pea)
    ({ location = zombie_x, zombie_y; width = zombie_width } : zombie) : bool =
  let pea_x = fst pea.location in
  let check = abs (zombie_x - pea_x) < (zombie_width / 2) + (pea.width / 2) in
  if nt then not check else check

let is_pea_not_colliding_with_zombie
    ({ location = zombie_x, zombie_y; width = zombie_width } : zombie)
    (pea : pea) : bool =
  let pea_x = fst pea.location in
  not (abs (zombie_x - pea_x) < (zombie_width / 2) + (pea.width / 2))

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

let manage_message_length = reduce_message_durations

let tick_init (st : State.t) =
  st.timer <- st.timer + 1;
  coin_auto_increment st st.level;
  change_level st;
  manage_message_length st;
  (* Spawn zombies. *)
  if not (all_lvl_zombs_spawned st st.level) then timer_spawns_zombie st;
  let current_rows = st.board.rows in
  (* Make zombies walk. *)
  current_rows
  |> List.iter (fun (row : Board.row) ->
         row.zombies |> List.iter Characters.zombie_walk);
  (* Make peas walk. *)
  current_rows
  |> List.iter (fun (row : Board.row) -> row.peas |> List.iter pea_walk)

let tick_zombie_plant_collisions (row : Board.row) =
  let rec iter_zombie (zombies : zombie list) =
    match zombies with
    | [] -> ()
    | h :: t ->
        (let rec iter_plants (pls : Board.cell list) (was_eating : bool) =
           let colliding =
             List.filter
               (fun (plt : Board.cell) ->
                 match plt.plant with
                 | None -> false
                 | Some plant ->
                     let x, y = plant.location in
                     if is_zombie_colliding_with_entity x plant.width h then
                       true
                     else false)
               pls
           in
           if List.length colliding > 0 then
             List.iter
               (fun (plt : Board.cell) ->
                 match plt.plant with
                 | None -> ()
                 | Some plant ->
                     if Some plant = (List.nth colliding 0).plant then (
                       plant.hp <- plant.hp - h.damage;
                       h.speed <- 0;
                       if plant.hp <= 0 then h.speed <- 5 else ())
                     else ())
               pls
           else h.speed <- 5
         in
         iter_plants row.cells false);
        iter_zombie t
  in
  iter_zombie row.zombies

let tick_collision_peas_zombies_hp (row : Board.row) =
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
                 zb :: List.filter (is_zombie_colliding_with_pea true h) zbs)
               else row.zombies);
            iter_peas t
      in
      iter_peas row.peas

let tick_collision_peas_zombies_remove_peas (row : Board.row) =
  match row.peas with
  | [] -> ()
  | ps ->
      let rec destroy zbs =
        match zbs with
        | [] -> ()
        | h :: t ->
            row.peas <- List.filter (is_pea_not_colliding_with_zombie h) ps;
            destroy t
      in
      destroy row.zombies

let tick_collision_zombies_lawnmowers (row : Board.row) =
  (match row.lawnmower with
  | Some lm ->
      let x, _ = lm.location in
      if x > 1280 then row.lawnmower <- None
      else if List.exists (is_zombie_colliding_with_entity x 50) row.zombies
      then lm.speed <- 10
  | None -> ());
  row.lawnmower <- Characters.lawnmower_walk row.lawnmower;
  match row.lawnmower with
  | Some { location = x, _ } ->
      row.zombies
      |> List.iter (fun z ->
             if is_zombie_colliding_with_entity x 50 z then z.hp <- z.hp - 1000)
  | None -> ()

let tick_plants (st : State.t) (row : Board.row) =
  List.iter
    (fun (cell : Board.cell) ->
      match cell.plant with
      | None -> ()
      | Some plant ->
          if plant.hp <= 0 then (
            cell.plant <- None;
            if plant.plant_type = SunflowerPlant then update_base_list st plant
            else ()))
    row.cells;
  let r = row in
  r.cells
  |> List.iter (fun ({ plant } : Board.cell) ->
         match plant with
         | Some pl -> (
             pl.timer <- pl.timer + 1;
             if pl.speed <> 0 && pl.timer mod pl.speed = 0 then
               match pl.plant_type with
               | SunflowerPlant ->
                   st.coins <- st.coins + (25 * List.length st.bases_on_screen);
                   st.is_base_message_time <- true;
                   st.base_message_length <- Some 50
               | _ -> r.peas <- Characters.spawn_pea pl :: r.peas)
         | None -> ())

let tick_post (st : State.t) =
  let current_rows = st.board.rows in
  (* changes the field for number of zombies on the board *)
  st.zombies_on_board <- zombies_on_board_row current_rows;
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
  (* Finally, change the state if the game is lost. *)
  check_game_not_lost st

let tick (st : State.t) : State.t =
  let current_rows = st.board.rows in

  (* The ordering of these entries matters. The overall approach is to first
     create entities, then have entities cause damage to each other, then remove
     entities. This avoids bugs such as bullets being created and immediately
     removed before having an effect on the zombies. *)

  (* These create entities. *)
  tick_init st;
  current_rows |> List.iter (tick_plants st);

  (* These get entities to cause damage to each other. *)
  current_rows |> List.iter tick_collision_zombies_lawnmowers;
  current_rows |> List.iter tick_collision_peas_zombies_hp;

  (* These remove entities. *)
  current_rows |> List.iter tick_zombie_plant_collisions;
  current_rows |> List.iter tick_collision_peas_zombies_remove_peas;
  tick_post st
