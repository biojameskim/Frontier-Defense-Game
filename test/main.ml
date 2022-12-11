open OUnit2
open Game
open Characters
open Screen_play

(* This is a hacky workaround to get State.init () to not throw an error as it
   reads the images. *)
let _ = Graphics.open_graph ""

let compare_states (st1 : State.t) (st2 : State.t) =
  st1.board = st2.board && st1.screen = st2.screen
  && st1.was_mouse_pressed = st2.was_mouse_pressed
  && st1.timer = st2.timer
  && st1.shop_selection = st2.shop_selection
  && st1.coins = st2.coins && st1.level = st2.level
  && st1.zombies_killed = st2.zombies_killed

let trivial_tests =
  [
    ("trivial test" >:: fun _ -> assert_equal "abc" "abc");
    ( "trivial test 2" >:: fun _ ->
      assert_equal
        {
          damage = 0;
          location = (0, 0);
          speed = 0;
          pea_type = FreezePea;
          width = 15;
        }
        {
          damage = 0;
          location = (0, 0);
          speed = 0;
          pea_type = FreezePea;
          width = 15;
        } );
  ]

let gui_tests = []
let character_tests = []

let state_tests =
  let init_state = State.init () in
  [
    ( "inital state screen" >:: fun _ ->
      assert_equal Screen.HomeScreen init_state.screen );
    ( "inital state board" >:: fun _ ->
      assert_equal (Board.init ()) init_state.board );
    ( "inital state was_mouse_pressed" >:: fun _ ->
      assert_equal false init_state.was_mouse_pressed );
    ( "inital state shop_selection" >:: fun _ ->
      assert_equal None init_state.shop_selection );
    ("inital state coins" >:: fun _ -> assert_equal 0 init_state.coins);
    ("inital state level" >:: fun _ -> assert_equal 1 init_state.level);
    ( "inital state zombies_killed" >:: fun _ ->
      assert_equal 0 init_state.zombies_killed );
    ( "state change_screen" >:: fun _ ->
      assert_equal
        { init_state with screen = Screen.PauseScreen }
        (init_state |> State.change_screen Screen.PauseScreen)
        ~cmp:compare_states );
  ]

let get_plant_cost_test (name : string) (plant : plant_type)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_plant_cost plant)

let get_plant_hp_test (name : string) (plant : plant_type)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_plant_hp plant)

let get_plant_speed_test (name : string) (plant : plant_type)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_plant_speed plant)

let can_buy_test (name : string) (st : State.t) (plant : plant_type)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal expected_output (can_buy st plant)

let decrement_coins_test (name : string) (st : State.t) (plant : plant_type)
    (expected_output : int) : test =
  name >:: fun _ ->
  assert_equal expected_output
    (decrement_coins st plant;
     st.coins)

let is_game_not_lost_test (name : string) (st : State.t) (blist : bool list)
    (expected_output : State.t) : test =
  name >:: fun _ ->
  assert_equal expected_output (is_game_not_lost st blist) ~cmp:compare_states

let make_game_not_lost_list_test (name : string) (st : State.t)
    (expected_output : bool list) : test =
  name >:: fun _ -> assert_equal expected_output (make_game_not_lost_list st)

let should_spawn_zombie_test (name : string) (st : State.t) (level : int)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal expected_output (should_spawn_zombie st st.level)

let time_to_give_coins_test (name : string) (level : int) (st : State.t)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal expected_output (is_time_to_give_coins st.level st)

let zombies_in_lvl_test (name : string) (level : int) (expected_output : int) :
    test =
  name >:: fun _ -> assert_equal expected_output (zombies_in_level level)

let change_level_test (name : string) (st : State.t)
    (expected_output : Screen.t) : test =
  name >:: fun _ ->
  assert_equal expected_output
    (change_level st;
     st.screen)

let screen_play_tests =
  let init_state = State.init () in
  let changed_coin_amt = { init_state with coins = 50 } in
  let changed_state_coin_screen =
    { init_state with coins = 50; screen = PlayScreen; zombies_killed = 15 }
  in
  [
    get_plant_cost_test "cost - PeaShooterPlant" PeaShooterPlant 5;
    get_plant_cost_test "cost - PeaShooterPlant" IcePeaShooterPlant 10;
    get_plant_cost_test "cost - PeaShooterPlant" WalnutPlant 65;
    get_plant_hp_test "hp - PeaShooterPlant" PeaShooterPlant 100;
    get_plant_hp_test "hp - IcePeaShooterPlant" IcePeaShooterPlant 100;
    get_plant_hp_test "hp - WalnutPlant" WalnutPlant 300;
    get_plant_speed_test "speed - PeaShooterPlant" PeaShooterPlant 50;
    get_plant_speed_test "speed - IcePeaShooterPlant" IcePeaShooterPlant 50;
    get_plant_speed_test "speed - WalnutPlant" WalnutPlant 0;
    can_buy_test "not enough money" init_state PeaShooterPlant false;
    can_buy_test "enough money" changed_coin_amt PeaShooterPlant true;
    decrement_coins_test "decrements coins - PeaShooter" changed_coin_amt
      PeaShooterPlant 45;
    is_game_not_lost_test "did not lose" changed_state_coin_screen
      [ true; true; true; true ] changed_state_coin_screen;
    is_game_not_lost_test "did lose" changed_state_coin_screen
      [ true; true; true; false ]
      { init_state with screen = EndScreenLost };
    make_game_not_lost_list_test "all true"
      {
        init_state with
        board =
          {
            rows =
              [
                {
                  cells = [];
                  zombies =
                    [
                      {
                        zombie_type = RegularZombie;
                        hp = 10;
                        damage = 1;
                        location = (1280, 100);
                        speed = 1;
                        frame = 0;
                        width = 50;
                      };
                    ];
                  peas = [];
                  lawnmower = None;
                };
              ];
          };
      }
      [ true ];
    make_game_not_lost_list_test "one true one false"
      {
        init_state with
        board =
          {
            rows =
              [
                {
                  cells = [];
                  zombies =
                    [
                      {
                        zombie_type = RegularZombie;
                        hp = 10;
                        damage = 1;
                        location = (1280, 100);
                        speed = 1;
                        frame = 0;
                        width = 15;
                      };
                    ];
                  peas = [];
                  lawnmower = None;
                };
                {
                  cells = [];
                  zombies =
                    [
                      {
                        zombie_type = RegularZombie;
                        hp = 10;
                        damage = 1;
                        location = (49, 100);
                        speed = 1;
                        frame = 0;
                        width = 15;
                      };
                    ];
                  peas = [];
                  lawnmower = None;
                };
              ];
          };
      }
      [ true; false ];
    (let lvl_one_works = { init_state with timer = 5000 } in
     should_spawn_zombie_test "level one, should spawn" lvl_one_works
       lvl_one_works.level true);
    (let lvl_one_does_not_work = { init_state with timer = 4999 } in
     should_spawn_zombie_test "level one, should not spawn"
       lvl_one_does_not_work lvl_one_does_not_work.level false);
    (let lvl_two_works = { init_state with timer = 4000; level = 2 } in
     should_spawn_zombie_test "level two, should spawn" lvl_two_works
       lvl_two_works.level true);
    (let lvl_one_coins_works = { init_state with timer = 2500 } in
     time_to_give_coins_test "level one should give coins"
       lvl_one_coins_works.level lvl_one_coins_works true);
    (let lvl_one_coins_dont_work = { init_state with timer = 150 } in
     time_to_give_coins_test "level one should not give coins"
       lvl_one_coins_dont_work.level lvl_one_coins_dont_work false);
    (let lvl_three_coins_works = { init_state with timer = 3000; level = 3 } in
     time_to_give_coins_test "level three should give coins"
       lvl_three_coins_works.level lvl_three_coins_works true);
    zombies_in_lvl_test "level 1 zombies" 1 10;
    zombies_in_lvl_test "level 1 zombies" 2 25
    (*(let (changed_level = {init_state with }))*)
    (* have not tested buy_from_shop, draw_cell or draw_row, stopped at
       changed_level *);
  ]

let tests =
  "plantsvzombies test suite"
  >::: List.flatten
         [
           trivial_tests;
           gui_tests;
           character_tests;
           state_tests;
           screen_play_tests;
         ]

let _ = run_test_tt_main tests
