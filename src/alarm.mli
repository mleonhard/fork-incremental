(** A timing-wheel alarm used to implement a time-dependent incremental: [at],
    [at_intervals], [snapshot], [step_function]. *)

open! Core.Std
open! Import

type t = Types.Alarm.t
with sexp_of

include Invariant.S with type t := t

val null : t
