open Core.Std
open Import    let _ = _squelch_unused_module_warning_

module Action = struct
  type t = Types.Alarm_value.Action.t =
    | At            of At.t
    | At_intervals  of At_intervals.t
    | Snapshot       : _ Snapshot.t -> t
    | Step_function  : _ Step_function.t -> t
  with sexp_of

  let invariant = function
    | At at -> At.invariant at
    | At_intervals at_intervals -> At_intervals.invariant at_intervals
    | Snapshot snapshot -> Snapshot.invariant ignore snapshot
    | Step_function step_function -> Step_function.invariant ignore step_function
  ;;
end

type t = Types.Alarm_value.t =
  { action             : Action.t
  (* [next_fired] singly links all alarm values that fire during a single call to
     [advance_clock]. *)
  ; mutable next_fired : t Uopt.t sexp_opaque
  }
with fields, sexp_of

let invariant t =
  Invariant.invariant _here_ t <:sexp_of< t >> (fun () ->
    let check f = Invariant.check_field t f in
    Fields.iter
      ~action:(check Action.invariant)
      ~next_fired:ignore)
;;

let create action = { action; next_fired = Uopt.none }
