# D3-based renderer for Dagre

This is the dagre d3 renderer packaged for Meteor with some additional helpful utilities.

**You can view the original non-meteor repository [here](https://github.com/cpettitt/dagre-d3).**

Dagre is a JavaScript library that makes it easy to lay out directed graphs on
the client-side. The dagre-d3 library acts a front-end to dagre, providing
actual rendering using [D3][].

## Demo

There will be a demo of the new `ReactiveDagre` class added to the meteor implementation soon.

## Getting dagre-d3

You can install it with meteorite:

```
mrt add dagred3
```

## Using dagre-d3

With dagre-d3, you will first create a graph, then render it. Much of this process is wrapped in `ReactiveDagre`, which is outlined below.

### Creating a Graph

The renderer uses [graphlib](https://github.com/cpettitt/graphlib) to create graphs in
dagre, so its probably worth taking a look at its
[API](http://cpettitt.github.io/project/graphlib/latest/doc/index.html).
Graphlib comes bundled with dagre-d3.

```js
// Create a new directed graph
var g = new dagreD3.Digraph();

// Add nodes to the graph. The first argument is the node id. The second is
// metadata about the node. In this case we're going to add labels to each of
// our nodes.
g.addNode("kspacey",    { label: "Kevin Spacey" });
g.addNode("swilliams",  { label: "Saul Williams" });
g.addNode("bpitt",      { label: "Brad Pitt" });
g.addNode("hford",      { label: "Harrison Ford" });
g.addNode("lwilson",    { label: "Luke Wilson" });
g.addNode("kbacon",     { label: "Kevin Bacon" });

// Add edges to the graph. The first argument is the edge id. Here we use null
// to indicate that an arbitrary edge id can be assigned automatically. The
// second argument is the source of the edge. The third argument is the target
// of the edge. The last argument is the edge metadata.
g.addEdge(null, "kspacey",   "swilliams", { label: "K-PAX" });
g.addEdge(null, "swilliams", "kbacon",    { label: "These Vagabond Shoes" });
g.addEdge(null, "bpitt",     "kbacon",    { label: "Sleepers" });
g.addEdge(null, "hford",     "lwilson",   { label: "Anchorman 2" });
g.addEdge(null, "lwilson",   "kbacon",    { label: "Telling Lies in America" });
```

### Rendering the Graph

To render the graph, we first need to create an SVG element on our page:

```html
<svg width=650 height=680>
    <g transform="translate(20,20)"/>
</svg>
```

Then we ask the renderer to draw our graph in the SVG element:

```js
var renderer = new dagreD3.Renderer();
renderer.run(g, d3.select("svg g"));
```

We also need to add some basic style information to get a usable graph. These values can be tweaked, of course.

```css
<style>
svg {
    overflow: hidden;
}

.node rect {
    stroke: #333;
    stroke-width: 1.5px;
    fill: #fff;
}

.edgeLabel rect {
    fill: #fff;
}

.edgePath {
    stroke: #333;
    stroke-width: 1.5px;
    fill: none;
}
</style>
```

This produces the graph:

![oracle-of-bacon1.png](http://cpettitt.github.io/project/dagre-d3/static/oracle-of-bacon1.png)

### Configuring the Renderer

This section describes experimental rendering configuration.

* `renderer.edgeInterpolate(x)` sets the path interpolation used with d3. For a list of interpolation options, see the [D3 API](https://github.com/mbostock/d3/wiki/SVG-Shapes#wiki-line_interpolate).
* `renderer.edgeTension(x)` is used to set the tension for use with d3. See the [D3 API](https://github.com/mbostock/d3/wiki/SVG-Shapes#wiki-line_tension) for details.

For example, to set the edge interpolation to 'linear':

```js
renderer.edgeTension('linear');
renderer.run(g, d3.select('svg g'));
```

### Configuring the Layout

Here are a few methods you can call on the layout object to change layout behavior:

* `debugLevel(x)` sets the level of logging verbosity to the number `x`. Currently 4 is th max.
* `nodeSep(x)` sets the separation between adjacent nodes in the same rank to `x` pixels.
* `edgeSep(x)` sets the separation between adjacent edges in the same rank to `x` pixels.
* `rankSep(x)` sets the sepration between ranks in the layout to `x` pixels.
* `rankDir(x)` sets the direction of the layout.
    * Defaults to `"TB"` for top-to-bottom layout
    * `"LR"` sets layout to left-to-right

For example, to set node separation to 20 pixels and the rank direction to left-to-right:

```js
var layout = dagreD3.layout()
                    .nodeSep(20)
                    .rankDir("LR");
renderer.layout(layout).run(g, d3.select("svg g"));
```

This produces the following graph:

![oracle-of-bacon2.png](http://cpettitt.github.io/project/dagre-d3/static/oracle-of-bacon2.png)

##ReactiveDagre

The class added in this implementation for Meteor is `ReactiveDagre`. It automatically re-renders the layout with transitions when you add nodes, and wraps a lot of the init phases. Future support is planned for reactive functions in the data, for example, basing a graph off of a traditional Meteor function.

Right now, this is the simplified initialization process:

```coffee

g = new ReactiveDagre "svg g"

graphBuilt = false
buildGraph = ->
   if !graphBuilt
      graphBuilt = true
      g.layout.nodeSep(20).rankDir("LR")
      #Third option is no-render, if you don't want the graph to update immediately
      g.addNode "cool", {label: "Something Cool"}, true
      g.addNode "awesome", {label: "Something Awesome"}, true
      g.addEdge null, "cool", "awesome", {label: "Leads To"}, true

Template.dagre.rendered = ->
   buildGraph()
   g.render()

```

Once the graph is initially rendered, if you call `g.addNode` or `g.addEdge`, the graph will update automatically, with a nice 500ms transition. You can override the transition function by overwriting `ReactiveDagre.prototype.transition`.

You can also remove edges or nodes by ID using `g.delNode` or `g.delEdge`.

Please note that you're setting basically an HTML selector in the constructor of `ReactiveDagre`. If you try to add nodes when Meteor hasn't yet rendered your base `svg g`, it will throw errors. It is safe to constuct `ReactiveDagre` without any DOM, however.

## License

dagre-d3 is licensed under the terms of the MIT License. See the LICENSE file
for details.

[npm package manager]: http://npmjs.org/
[D3]: https://github.com/mbostock/d3
