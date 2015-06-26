(** A module internal to Incremental.  Users should see {!Incremental_intf}.

    Node ids are consecutive integers assigned to nodes as they are created.
*)

open! Core.Std
open! Import

type t = private int with compare, sexp_of

include Hashable    with type t := t
include Invariant.S with type t := t

val next : unit -> t
val to_string : t -> string
