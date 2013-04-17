class Experiments.Circles
  svg: null

  width: 600

  height: 600

  data: null

  constructor: ->
    @createSvg()

    @render(@getData())
    setInterval =>
      @updateRandomCircle()
    , 10

  createSvg: ->
    @svg = d3.selectAll('.svg-content')
      .append('svg:svg')
      .attr('width', @width)
      .attr('height', @height)

  randomColor: ->
    "hsl(#{Math.random() * 360}, 100%, 50%)"

  getData: ->
    { x: Math.random() * 500, y: Math.random() * 500, r: Math.random() * 30, color: @randomColor() } for x in [0..999]

  render: (data) ->
    randomColor = @randomColor
    @circles = @svg.selectAll('circle').data(data)

    @circles.enter()
      .append('circle')
      .on('mouseover', ->
        d3.select(@)
          .transition()
          .duration(1000)
          .attr('r', Math.random() * 50)
          .attr('fill', randomColor())
      )
      .attr('r', 0)
      .transition()
        .duration(2000)
        .attr('r', (d) -> d.r)

    @circles
      .attr('cx', (d) -> d.x)
      .attr('cy', (d) -> d.y)
      .attr('fill', (d) -> d.color)
      .attr('stroke', 'black')

  updateRandomCircle: ->
    d3.select(@svg.selectAll('circle')[0][Math.floor Math.random() * 1000])
      .transition()
      .duration(500)
      .attr('r', Math.random() * 50)
      .attr('fill', @randomColor())


