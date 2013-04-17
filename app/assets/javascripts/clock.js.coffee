class Experiments.Clock
  width: 400

  height: 200

  offsetX: 150

  offsetY: 100

  outerRadius: 80

  innerRadius: 4

  pi: Math.PI

  clockGroup: null

  scaleSeconds: null

  scaleMinutes: null

  scaleHours: null

  constructor: ->
    @setScales()
    @buildClock()
    @start()

  start: ->
    @render(@fields())
    setInterval =>
        @render(@fields())
      , 1000

  fields: ->
    time = new Date()
    second = time.getSeconds()
    minute = time.getMinutes()
    hour = time.getHours() + minute / 60

    [
      { unit: 'seconds', numeric: second },
      { unit: 'minutes', numeric: minute },
      { unit: 'hours', numeric: hour }
    ]

  setScales: ->
    @scaleSeconds = d3.scale.linear().domain([0, 59 + 999 / 1000]).range([0, 2 * @pi])
    @scaleMinutes = d3.scale.linear().domain([0, 59 + 59 / 60]).range([0, 2 * @pi])
    @scaleHours = d3.scale.linear().domain([0, 11 + 59 / 60]).range([0, 2 * @pi])

  buildClock: ->
    vis = d3.selectAll('.svg-content')
      .append('svg:svg')
      .attr('width', @width)
      .attr('height', @height)

    @clockGroup = vis.append('svg:g')
      .attr('transform', "translate(#{@offsetX},#{@offsetY})")

    @clockGroup.append('svg:circle')
      .attr('r', @outerRadius).attr('fill', 'none')
      .attr('class', 'clock outercircle')
      .attr('stroke', 'black')
      .attr('stroke-width', 2)

    @clockGroup.append('svg:circle')
      .attr('r', @innerRadius)
      .attr('fill', 'black')
      .attr('class', 'clock innercircle')

  render: (data) ->
    @clockGroup.selectAll('.clockhand').remove()

    secondArc = d3.svg.arc()
      .innerRadius(0)
      .outerRadius(@outerRadius - 10)
      .startAngle (d) =>
        @scaleSeconds(d.numeric)
      .endAngle (d) =>
        @scaleSeconds(d.numeric)

    minuteArc = d3.svg.arc()
      .innerRadius(0)
      .outerRadius(@outerRadius - 10)
      .startAngle (d) =>
        @scaleMinutes(d.numeric)
      .endAngle (d) =>
        @scaleMinutes(d.numeric)

    hourArc = d3.svg.arc()
      .innerRadius(0)
      .outerRadius(@outerRadius - 30)
      .startAngle (d) =>
        @scaleHours(d.numeric % 12)
      .endAngle (d) =>
        @scaleHours(d.numeric % 12)

    @clockGroup.selectAll('.clockhand')
      .data(data)
      .enter()
      .append('svg:path')
      .attr('d', (d) ->
        if d.unit == 'seconds'
          secondArc(d)
        else if d.unit == 'minutes'
          minuteArc(d)
        else if d.unit == 'hours'
          hourArc(d)
      )
      .attr('class', 'clockhand')
      .attr('stroke', (d) ->
        if d.unit == 'seconds' then 'red' else 'black'
      )
      .attr('stroke-width', (d) ->
        if d.unit == 'seconds' then 2 else 3
      )
      .attr('fill', 'none')