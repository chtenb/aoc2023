

pub effect each
  ctl each(elems : list<a>) : a
  ctl fail() : a

pub fun list-comp(action : () -> each a) : list<a>
  with handler
    return (x) [x]
    ctl each(elems) elems.flatmap(resume)
    ctl fail() []
  action()

pub fun guard(pred : bool) : each ()
  if pred then () else fail()

pub fun test-each()
  list-comp
    val x = each([1,2,3])
    val y = each([1,2,2])
    val z = x+y
    guard (z != 3)
    z * z

pub effect iter<a>
  ctl yield(elem : a) : ()

pub fun to-list(it : () -> iter<a> ()) : list<a>
  with unsafe-no-div()
  var result := Nil
  with fun yield(elem)
    result := Cons(elem, result)
  it()
  reverse(result) // List was accumulated in reverse order

pub fun take(n : int, it : () -> <div,iter<a>> ()) : iter<a> ()
  var count := 0
  with ctl yield(elem)
    if count < n then
      yield(elem) // Forward the yield to our new iterator
      count := count + 1
      resume(())
    else
      ()
  with unsafe-no-div()
  it()

pub fun test-iter() : div list<int>
  fun fib-iter(n1 : int, n2 : int) : <div,iter<int>> ()
    val n3 = n1 + n2
    yield(n3)
    fib-iter(n2, n3)
    
  to-list
    take(100)
      fib-iter(1,1)

    

pub fun foreach(it : () -> <iter<a>|e> (), do : a -> e ()) : e ()
  with ctl yield(elem)
    do(elem) // Run the foreach block for each element
    resume(()) // We don't want just the first element, so return to call site
  it() // Run iterator

pub fun to-list2(it : () -> iter<a> ()) : list<a>
  with unsafe-no-div() // No idea why this is necessary
  var result := Nil
  foreach(it) fn(elem)
    result := Cons(elem, result)
  reverse(result)
