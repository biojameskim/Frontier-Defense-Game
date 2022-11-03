open OUnit2
open Game
open Characters

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

let tests =
  "plantsvzombies test suite"
  >::: List.flatten [ trivial_tests; gui_tests; character_tests ]

let _ = run_test_tt_main tests
