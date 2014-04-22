contains = (a, b) ->
  _.contains a, b

class ReactiveDagre
  constructor: (target)->
    @graph = new dagreD3.Digraph()
    @renderer = new dagreD3.Renderer()
    @layout = dagreD3.layout()
    @target = target
    @renderer = @renderer.layout(@layout).transition(ReactiveDagre::transition)
  render: ->
    @renderer.run(@graph, d3.select(@target))
  addNode: (name, options, norerender)->
    @graph.addNode name, options
    if !norerender? || !norerender
      @render()
  addEdge: (id, source, dest, options, norerender)->
    return if !contains @graph.nodes(), source
    return if !contains @graph.nodes(), dest
    @graph.addEdge id, source, dest, options
    if !norerender? || !norerender
      @render()
  delEdge: (id, norerender)->
    return if !contains @graph.edges(), id
    @graph.delEdge id
    if !norerender? || !norerender
      @render()
  delNode: (id, norerender)->
    return if !contains @graph.nodes(), id
    @graph.delNode id
    if !norerender? || !norerender
      @render()
  transition: (selection)->
    selection.transition().duration(500)

@ReactiveDagre = ReactiveDagre
