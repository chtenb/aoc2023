import std/text/parse

pub fun main()
  val input = join(list(0, 1000).map(fn(n) "aaaaaaaaaaaaaaaaaaa" ++ show(n)), "\n")
  val x = parse(slice(input))
    many(fn() alpha-num || ({ optional('\n', { char('\r') }) }))
  println("exit")
