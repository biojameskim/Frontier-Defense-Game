open OUnit2
open Game
open Characters
open Screen_play

let trivial_tests =
  [
    ("trivial test" >:: fun _ -> assert_equal "abc" "abc");
    ( "trivial test 2" >:: fun _ ->
      assert_equal
        {
          damage = 0;
          location = (0, 0);
          speed = 0;
          speedChange = 0;
          row = 1;
          pea_type = FreezePea;
        }
        {
          damage = 0;
          location = (0, 0);
          speed = 0;
          speedChange = 0;
          row = 1;
          pea_type = FreezePea;
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
        (init_state |> State.change_screen Screen.PauseScreen) );
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
  name >:: fun _ -> assert_equal expected_output (is_game_not_lost st blist)

let make_game_not_lost_list_test (name : string) (st : State.t)
    (expected_output : bool list) : test =
  name >:: fun _ -> assert_equal expected_output (make_game_not_lost_list st)

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
    get_plant_speed_test "speed - PeaShooterPlant" PeaShooterPlant 5;
    get_plant_speed_test "speed - IcePeaShooterPlant" IcePeaShooterPlant 5;
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
                        location = (149, 100);
                        speed = 1;
                        frame = 0;
                      };
                    ];
                  peas = [];
                  lawnmower = None;
                };
              ];
          };
      }
      [ true; false ]
    (* have not tested buy_from_shop, draw_cell or draw_row, stopped at
       should_spawn_zombie *);
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
