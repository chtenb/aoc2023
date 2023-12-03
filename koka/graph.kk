import utils

// TODO: is it possible to implent this as a struct of functions?
// If yes, what is more natural?
// Implicit graph structures
effect igraph<a>
  fun nodes() : list<a>
  fun nhood(n : a) : list<a>
  val size : int
  fun node-id(n : a) : int

fun arcs() : igraph<a> list<(a, a)>
  nodes().map(fn(n)
    nhood(n).map(fn(neigh) (n, neigh))
  ).flatmap(id)

effect visitor<a>
  ctl visit(n : a) : ()
  fun visited(n : a) : bool

// Visit nodes in DFS order
fun dfs(todo : list<a>) : <div,igraph<a>,visitor<a>|e> ()
  match todo
    Nil -> ()
    Cons (n,ns) -> 
      if !visited(n) then
        visit(n)
        dfs(nhood(n) ++ ns)
      else
        dfs(ns)

// Find the first node that matches the predicate
fun find-dfs(start : a, pred : a -> bool) : <igraph<a>,div,exn> maybe<a>
  var has-visited : vector<bool> := vector(size, False)
  with handler
    ctl visit(n)
      has-visited[node-id(n)] := True
      if !pred(n) then resume(()) else Just(n)
    fun visited(n) has-visited[node-id(n)]
  dfs([start])
  Nothing
  
// Explicitly stored graph structure
value struct graph
  nhoods : vector<list<int>>

fun graph(nhoods : list<list<int>>)
  Graph(vector(nhoods))
  
fun handle-graph-as-igraph(g : graph, cont : () -> <igraph<int>,exn|e> a) : <exn|e> a
  with handler
    fun nodes() list(0, g.nhoods.length())
    fun nhood(n) g.nhoods[n]
    val size = g.nhoods.length()
    fun node-id(n) n
  cont()

// Grid graph structure
value struct grid
  width : int
  height : int

value struct point
  x : int
  y : int

pub fun show(p : point) : string
  "(" ++ p.x.show ++ "," ++ p.y.show ++ ")"

pub fun show(x : maybe<point>) : string
  match x
    Nothing -> "Nothing"
    Just(p) -> "Just " ++ p.show

fun handle-grid-as-igraph(g : grid, cont : () -> <igraph<point>,exn|e> a) : <exn|e> a
  with handler
    fun nodes()
      list-comp
        val x = each(list(0, g.width - 1))
        val y = each(list(0, g.height - 1))
        Point(x,y)
    fun nhood(n)
      match n
        Point(x,y) -> [Point(x + 1,y), Point(x - 1,y), Point(x, y + 1), Point(x,y - 1)]
    val size = g.width * g.height
    fun node-id(n)
      match n
        Point(x,y) -> y * g.width + x
  cont()

fun test()
  val g = Grid(10,10)
  with handle-grid-as-igraph(g)
  find-dfs(Point(0,0)) fn(p)
    match p
      Point(x, _y) -> x == 5
