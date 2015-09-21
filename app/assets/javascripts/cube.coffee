@cubeColors = [
  0x006699 # blue
  0x33CC00 # green
  0xE80000 # red
  0xFF6600 # orange
  0xFFFF00 # yellow
  0xFFFFFF # white
  0x333333 # inner color
]

rotationMatrixes = {
  x:
    forward: [
      [1,  0, 0]
      [0,  0, 1]
      [0, -1, 0]
    ]
    backward: [
      [1, 0,  0]
      [0, 0, -1]
      [0, 1,  0]
    ]
  y:
    forward: [
      [0, 0, -1]
      [0, 1,  0]
      [1, 0,  0]
    ]
    backward: [
      [ 0, 0, 1]
      [ 0, 1, 0]
      [-1, 0, 0]
    ]
  z:
    forward: [
      [ 0, 1, 0]
      [-1, 0, 0]
      [ 0, 0, 1]
    ]
    backward: [
      [0, -1, 0]
      [1,  0, 0]
      [0,  0, 1]
    ]
}

colorMatrixes = {
  x:
    forward: [
      [1, 0, 0, 0, 0, 0]
      [0, 1, 0, 0, 0, 0]
      [0, 0, 0, 0, 1, 0]
      [0, 0, 0, 0, 0, 1]
      [0, 0, 0, 1, 0, 0]
      [0, 0, 1, 0, 0, 0]
    ]
    backward: [
      [1, 0, 0, 0, 0, 0]
      [0, 1, 0, 0, 0, 0]
      [0, 0, 0, 0, 0, 1]
      [0, 0, 0, 0, 1, 0]
      [0, 0, 1, 0, 0, 0]
      [0, 0, 0, 1, 0, 0]
    ]
  y:
    forward: [
      [0, 0, 0, 0, 0, 1]
      [0, 0, 0, 0, 1, 0]
      [0, 0, 1, 0, 0, 0]
      [0, 0, 0, 1, 0, 0]
      [1, 0, 0, 0, 0, 0]
      [0, 1, 0, 0, 0, 0]
    ]
    backward: [
      [0, 0, 0, 0, 1, 0]
      [0, 0, 0, 0, 0, 1]
      [0, 0, 1, 0, 0, 0]
      [0, 0, 0, 1, 0, 0]
      [0, 1, 0, 0, 0, 0]
      [1, 0, 0, 0, 0, 0]
    ]
  z:
    forward: [
      [0, 0, 1, 0, 0, 0]
      [0, 0, 0, 1, 0, 0]
      [0, 1, 0, 0, 0, 0]
      [1, 0, 0, 0, 0, 0]
      [0, 0, 0, 0, 1, 0]
      [0, 0, 0, 0, 0, 1]
    ]
    backward: [
      [0, 0, 0, 1, 0, 0]
      [0, 0, 1, 0, 0, 0]
      [1, 0, 0, 0, 0, 0]
      [0, 1, 0, 0, 0, 0]
      [0, 0, 0, 0, 1, 0]
      [0, 0, 0, 0, 0, 1]
    ]
}

@matrixMultiplay = (a, b) ->
  x = a.length - 1
  y = b.length - 1
  z = b[0].length - 1

  res = []

  for i in [0..x]
    res[i] = []
    for j in [0..z]
      res[i][j] = 0
      for k in [0..y]
        res[i][j] += a[i][k] * b[k][j]

  res

@vectorMatrixMultiplay = (v, a, offset = 0) ->
  matrixMultiplay([v.map (x)-> x - offset], a)[0].map (x)-> x + offset


SmallCube = (x, y, z, size, colors, avg_cube, odd)->
  @p = [x, y, z]
  @colors = colors
  plus = if odd then 0 else -0.5*1.1
  @matrix_data = [0,0,0]

  @rotator = null

  @finish_rotations = =>
    @cube.rotation.x = @cube.rotation.y = @cube.rotation.z = 0
    @geometry.verticesNeedUpdate = true
    @geometry.applyMatrix new THREE.Matrix4().makeTranslation(
      (@p[0]*1.1 + plus)*size - @matrix_data[0], (@p[1]*1.1 + plus)*size - @matrix_data[1], (@p[2]*1.1 + plus)*size - @matrix_data[2]
    )
    @matrix_data = [(@p[0]*1.1 + plus)*size, (@p[1]*1.1 + plus)*size, (@p[2]*1.1 + plus)*size]
    @geometry.verticesNeedUpdate = true
    @cube.material.materials = @materials()
    window.clearInterval(@rotator) if @rotator
    @rotator = null

  @perform_rotation = (axis, direction, speed = 0.03) =>
    do @finish_rotations if @rotator
    @p = vectorMatrixMultiplay @p, rotationMatrixes[axis][direction], avg_cube
    @colors = vectorMatrixMultiplay @colors, colorMatrixes[axis][direction]
    koef = if direction == 'forward' then 1 else -1
    @rotator = setInterval =>
      if Math.PI/2 - koef*@cube.rotation[axis] > speed
        @cube.rotation[axis] += koef*speed
      else
        do @finish_rotations
    , 10

  @rotateX = =>        @perform_rotation 'x', 'forward'
  @rotateY = =>        @perform_rotation 'y', 'forward'
  @rotateZ = =>        @perform_rotation 'z', 'forward'
  @rotateInverseX = => @perform_rotation 'x', 'backward'
  @rotateInverseY = => @perform_rotation 'y', 'backward'
  @rotateInverseZ = => @perform_rotation 'z', 'backward'

  @geometry = new THREE.BoxGeometry size, size, size
  @materials = =>
    @colors.map (c) ->
      new THREE.MeshBasicMaterial( { color: cubeColors[c], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials()
  do @finish_rotations
  @

@RubicCube = (cubes_count, cube_size)->
  side_colors = (x, y, z, min, max)->
    [
      if x == max then 0 else 6
      if x == min then 1 else 6
      if y == max then 2 else 6
      if y == min then 3 else 6
      if z == max then 4 else 6
      if z == min then 5 else 6
    ]
  @cubes = []

  odd = !!(cubes_count % 2)

  firstCube = -Math.floor (cubes_count-1)/2
  lastCube =  Math.floor (cubes_count)/2

  avgCube = (firstCube + lastCube)/2

  for i in [firstCube..lastCube]
    for j in [firstCube..lastCube]
      for k in [firstCube..lastCube]
        if i == firstCube || i == lastCube || j == firstCube || j == lastCube || k == firstCube || k == lastCube
          @cubes.push new SmallCube(i, j, k, cube_size, side_colors(i, j, k, firstCube, lastCube), avgCube, odd)

  @object = new THREE.Object3D()
  @object.add cube.cube for cube in @cubes

  @rotateX = (x)-> cube.rotateX() for cube in @cubes.filter((c)-> c.p[0] == x)
  @rotateY = (y)-> cube.rotateY() for cube in @cubes.filter((c)-> c.p[1] == y)
  @rotateZ = (z)-> cube.rotateZ() for cube in @cubes.filter((c)-> c.p[2] == z)

  @rotateInverseX = (x)-> cube.rotateInverseX() for cube in @cubes.filter((c)-> c.p[0] == x)
  @rotateInverseY = (y)-> cube.rotateInverseY() for cube in @cubes.filter((c)-> c.p[1] == y)
  @rotateInverseZ = (z)-> cube.rotateInverseZ() for cube in @cubes.filter((c)-> c.p[2] == z)

  @

@AxesBuilder = (length = 1000)->
  buildAxis = (src, dst, colorHex) ->
    geom = new THREE.Geometry()
    mat = new THREE.LineBasicMaterial linewidth: 3, color: colorHex
    geom.vertices.push src.clone()
    geom.vertices.push dst.clone()
    new THREE.Line( geom, mat, THREE.LinePieces )

  @object = new THREE.Object3D()
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3( length, 0, 0), cubeColors[0]
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(-length, 0, 0), cubeColors[1]
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0,  length, 0), cubeColors[2]
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, -length, 0), cubeColors[3]
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0,  length), cubeColors[4]
  @object.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, -length), cubeColors[5]

  @


width = window.innerWidth
height = window.innerHeight
cubeSize = 1.5*width/height
cubesCount = 7

$(document).on 'ready page:load', ->
  scene = new THREE.Scene()
  window.camera = new THREE.PerspectiveCamera( 45, width / height, 1, 1000 )

  window.renderer = new THREE.WebGLRenderer( antialias: true)
  renderer.setSize( window.innerWidth, window.innerHeight )
  document.body.appendChild( renderer.domElement )

  window.rubic_cube = new RubicCube(cubesCount, cubeSize/cubesCount)
  scene.add rubic_cube.object

  window.axes = new AxesBuilder
  scene.add axes.object

  camera.position.set 0, 0, 20

  plus = 0.01

  render = ->
    requestAnimationFrame( render );

    camera.rotateX(plus)
    camera.rotateY(plus)
    camera.rotateZ(plus)

    camera.lookAt 0, 0, 0

    # sinX = Math.sin(camera.rotation.x)
    # sinY = Math.sin(camera.rotation.y)
    # cosX = Math.cos(camera.rotation.x)
    # cosY = Math.cos(camera.rotation.y)

    # camera.position.x = 20 * sinY
    # camera.position.y = - 20 * sinX * cosY
    # camera.position.z = 20 * cosY * cosX

    renderer.render(scene, camera);

  render();
