open Core.Std
open Import    let _ = _squelch_unused_module_warning_
open Types.Kind

module Node = Types.Node

type t = Types.At_intervals.t =
  { main          : unit Node.t
  ; base          : Time.t
  ; interval      : Time.Span.t
  ; mutable alarm : Alarm.t
  }
with fields, sexp_of

let invariant t =
  Invariant.invariant _here_ t <:sexp_of< t >> (fun () ->
    let check f = Invariant.check_field t f in
    Fields.iter
      ~main:(check (fun (main : _ Node.t) ->
        match main.kind with
        | Invalid -> ()
        | At_intervals t' -> assert (phys_equal t t')
        | _ -> assert false))
      ~base:ignore
      ~interval:(check (fun interval -> assert (Time.Span.is_positive interval)))
      ~alarm:(check Alarm.invariant))
;;
