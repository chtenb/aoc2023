module day01
import std/os/path
import std/os/file
import std/text/parse
import utils

pub fun parse-input()
  many1(parse-line)

pub fun parse-line() : <console,parse> int
  println("hi")
  val digits = many(parse-char-as-digit).flatmap-maybe(id)
  println(digits.string())
  whitespace()
  // eol()
  0
  // match (head(digits),last(digits))
  //   (Just(a), Just(b)) -> [a,b].string.parse-int-default(0)
  //   _ -> fail("parsing failed")
    
pub fun parse-char-as-digit() : parse maybe<char>
  // Nothing
  val c = alpha-num()
  Nothing
  // if c.is-digit() then
  //   Just(c)
  // else
  //   Nothing

pub fun run(fname)
  val input = read-text-file(fname.path)
  val numbers = parse-exn(input, parse-input)
  println(numbers.sum())

pub fun main()
  run("input/day01.txt")
pub fun example()
  run("ex/day01.txt")

