open Graphics
open Camlimages
open Images

(* Note: Part of this function was adapted from the original source code of
   camlimages in [graphic_image.ml]. Source:
   https://gitlab.com/camlspotter/camlimages/-/blob/hg-b4.2.6/src/graphic_image.ml *)

(** [array_of_image img] takes in an Images.t and converts it to a 2d array of
    colors *)
let array_of_image img red green blue =
  match img with
  | Rgba32 bitmap ->
      let w = bitmap.Rgba32.width and h = bitmap.Rgba32.height in
      Array.init h (fun i ->
          Array.init w (fun j ->
              let ({ color; alpha } : rgba) = Rgba32.unsafe_get bitmap j i in
              let { r; g; b } = color in
              match (r, g, b, alpha) with
              | r, g, b, 0 -> rgb red green blue
              | r, g, b, a -> rgb r g b))
  | Rgb24 bitmap ->
      let w = bitmap.Rgb24.width and h = bitmap.Rgb24.height in
      Array.init h (fun i ->
          Array.init w (fun j ->
              let { r; g; b } = Rgb24.unsafe_get bitmap j i in
              rgb r g b))
  | _ -> failwith "Filetype not supported"

(* Takes Images.t and make it into an image that Graphics can use *)
let to_image img = Graphics.make_image (array_of_image img 92 199 70)

(* Draw an image *)
let draw_image (x : int) (y : int) img = Graphics.draw_image (to_image img) x y
