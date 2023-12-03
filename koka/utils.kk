module utils

import std/os/path
import std/os/file
import std/text/parse

pub fun parse-exn(input:string, p:() -> <parse,console> a) : <console,exn> a
  val s = slice(input)
  match parse-eof(s, p)
    ParseOk(result, _) -> result
    ParseError(msg, rest) -> 
      throw-exn(Exception("parse error: " ++ msg ++ "\n Rest:  " ++ rest.string, ExnError))

pub fun eol() : parse ()
  // Apparently we only must parse \n regardless of platform
  // val _ = char('\r') // optional('\r', { char('\r') })
  val _ = char('\n')
  ()
