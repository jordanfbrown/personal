class Experiments.D3
  svg: null

  width: 600

  height: 600

  data: null

  constructor: ->
    @createSvg()

    setInterval =>
      @render()
    , 1000

  createSvg: ->
    @svg = d3.selectAll('#content')
      .append('svg:svg')
      .attr('width', @width)
      .attr('height', @height)

  getData: ->
    { x: Math.random() * 500, y: Math.random() * 500, r: Math.random() * 30  } for x in [0..9]

  render: ->
    data = @getData()
    @circles = @svg.selectAll('circle')
      .data(data)

    @circles.enter()
      .append('circle')
      .attr('r', 0)
      .transition()
        .attr('r', (d) -> d.r)

    @circles
      .attr('cx', (d) -> d.x)
      .attr('cy', (d) -> d.y)

    @circles.exit()
      .transition()
      .attr('r', 0)


