@cubeColors = [
  0x006699 # blue
  0x33CC00 # green
  0xE80000 #+ red
  0xFF6600 #+ orange
  0xFFFF00 #+ yellow
  0xFFFFFF #+ white
  0x333333 # inner color
]

width = window.innerWidth
height = window.innerHeight
cubeSize = width/(2*height)

rotations = [0, 0.5*Math.PI, Math.PI, 1.5*Math.PI]

Cube = (x, y, z, colors, max_cube, odd)->
  @x = x
  @y = y
  @z = z
  @rotationX = 0
  @rotationY = 0
  @rotationZ = 0

  @blinker = null

  @blink = =>
    xxx = 0
    @blinker = setInterval( =>
      if xxx
        @cube.position.x += 10
        @cube.position.y += 10
        @cube.position.z += 10
        xxx = 0
        clearInterval @blinker
      else
        @cube.position.x -= 10
        @cube.position.y -= 10
        @cube.position.z -= 10
        xxx = 1
    , 1000)

  @fix_rotations = =>
    @cube.rotation.x = rotations[@rotationX]
    @cube.rotation.y = rotations[@rotationY]
    @cube.rotation.z = rotations[@rotationZ]
    @rotationX

  @rotateX = =>
    @rotationX = (@rotationX + 1) % 4
    oy = @y
    @y = max_cube - @z
    @z = oy
    do @fix_rotations

  @rotateY = =>
    @rotationY = (@rotationY + 1) % 4
    ox = @x
    @x = @z
    @z = max_cube - ox
    do @fix_rotations

  @rotateZ = =>
    @rotationZ = (@rotationZ + 1) % 4
    oy = @y
    @y = @x
    @x = max_cube - oy
    do @fix_rotations


  @geometry = new THREE.BoxGeometry cubeSize, cubeSize, cubeSize
  plus = if odd then 0 else -0.5*1.1
  @geometry.applyMatrix new THREE.Matrix4().makeTranslation (x*1.1 + plus)*cubeSize, (y*1.1 + plus)*cubeSize, (z*1.1 + plus)*cubeSize
  @materials = [
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[0]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[1]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[2]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[3]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[4]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[5]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  ]
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials
  @

MainCube = (count, side, color)->
  @geometry = new THREE.BoxGeometry( side*count*1.06, side*count*1.06, side*count*1.06 )
  @geometry.applyMatrix new THREE.Matrix4().makeTranslation -0.5*side, -0.5*side, -0.5*side
  @materials = [
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  ]
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials
  @

buildAxis = (src, dst, colorHex) ->
  geom = new THREE.Geometry()
  mat = new THREE.LineBasicMaterial linewidth: 3, color: colorHex
  geom.vertices.push src.clone()
  geom.vertices.push dst.clone()

  new THREE.Line( geom, mat, THREE.LinePieces )

buildAxes = (length)->
  axes = new THREE.Object3D()
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(length, 0, 0),  cubeColors[1]
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(-length, 0, 0), cubeColors[0]
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, length, 0),  cubeColors[3]
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, -length, 0), cubeColors[2]
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, length),  cubeColors[5]
  axes.add buildAxis new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, -length), cubeColors[4]
  axes


cubesForNormalCube = (cubeSide)->
  cubes = []

  odd = !!(cubeSide % 2)

  firstCube = -Math.floor (cubeSide-1)/2
  lastCube =  Math.floor (cubeSide)/2

  if cubeSide > 2
    for i in [firstCube+1..lastCube-1]
      for j in [firstCube+1..lastCube-1]
        cubes.push new Cube(i, j, firstCube, [6,6,6,6,6,5], lastCube, odd)
        cubes.push new Cube(i, j, lastCube , [6,6,6,6,4,6], lastCube, odd)
        cubes.push new Cube(i, firstCube, j, [6,6,6,3,6,6], lastCube, odd)
        cubes.push new Cube(i, lastCube, j , [6,6,2,6,6,6], lastCube, odd)
        cubes.push new Cube(firstCube, i, j, [6,1,6,6,6,6], lastCube, odd)
        cubes.push new Cube(lastCube, i, j , [0,6,6,6,6,6], lastCube, odd)

    for i in [firstCube+1..lastCube-1]
      cubes.push new Cube(i, firstCube, firstCube, [6,6,6,3,6,5], lastCube, odd)
      cubes.push new Cube(i, firstCube, lastCube, [6,6,6,3,4,6], lastCube, odd)
      cubes.push new Cube(i, lastCube, firstCube, [6,6,2,6,6,5], lastCube, odd)
      cubes.push new Cube(i, lastCube, lastCube, [6,6,2,6,4,6], lastCube, odd)

      cubes.push new Cube(firstCube, i, firstCube, [6,1,6,6,6,5], lastCube, odd)
      cubes.push new Cube(firstCube, i, lastCube, [6,1,6,6,4,6], lastCube, odd)
      cubes.push new Cube(lastCube, i, firstCube, [0,6,6,6,6,5], lastCube, odd)
      cubes.push new Cube(lastCube, i, lastCube, [0,6,6,6,4,6], lastCube, odd)

      cubes.push new Cube(firstCube, firstCube, i, [6,1,6,3,6,6], lastCube, odd)
      cubes.push new Cube(firstCube, lastCube, i, [6,1,2,6,6,6], lastCube, odd)
      cubes.push new Cube(lastCube, firstCube, i, [0,6,6,3,6,6], lastCube, odd)
      cubes.push new Cube(lastCube, lastCube, i, [0,6,2,6,6,6], lastCube, odd)

  cubes.push new Cube(firstCube, firstCube, firstCube, [6,1,6,3,6,5], lastCube, odd)
  # cubes.push new Cube(firstCube, firstCube, lastCube,  [6,1,6,3,4,6], lastCube, odd)
  # cubes.push new Cube(firstCube, lastCube, firstCube,  [6,1,2,6,6,5], lastCube, odd)
  # cubes.push new Cube(firstCube, lastCube, lastCube,   [6,1,2,6,4,6], lastCube, odd)
  # cubes.push new Cube(lastCube, firstCube, firstCube,  [0,6,6,3,6,5], lastCube, odd)
  # cubes.push new Cube(lastCube, firstCube, lastCube,   [0,6,6,3,4,6], lastCube, odd)
  # cubes.push new Cube(lastCube, lastCube, firstCube,   [0,6,2,6,6,5], lastCube, odd)
  # cubes.push new Cube(lastCube, lastCube, lastCube,    [0,6,2,6,4,6], lastCube, odd)

  # cubes.push new MainCube(cubeSide, cubeSize, cubeColors[6])

  cubes

@rotateCubesX = (x)->
  cc = window.cubes.filter((c)-> c.x == x)
  cube.rotateX() for cube in cc

@rotateCubesY = (y)->
  cc = window.cubes.filter((c)-> c.y == y)

  cube.rotateY() for cube in cc

@rotateCubesZ = (z)->
  cc = window.cubes.filter((c)-> c.z == z)
  console.log cc.length
  cube.rotateZ() for cube in cc

@blinkCubesX = (x)->
  cube.blink() for cube in window.cubes.filter((c)-> c.x == x)

@YCubes = (y)-> window.cubes.filter((c)-> c.y == y)
@blinkCubesY = (y)->
  cube.blink() for cube in window.cubes.filter((c)-> c.y == y)

@blinkCubesZ = (z)->
  cube.blink() for cube in window.cubes.filter((c)-> c.z == z)

$(document).on 'ready page:load', ->
  scene = new THREE.Scene();
  window.camera = new THREE.PerspectiveCamera( 45, width / height, 1, 1000 );
  # window.camera = new THREE.OrthographicCamera( -width/2 , width/2, -height/2, height/2, -1000, 1000 )

  window.renderer = new THREE.WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  document.body.appendChild( renderer.domElement );

  window.cubes = cubesForNormalCube(2)

  scene.add( cube.cube ) for cube in cubes

  axes = buildAxes(1000)
  scene.add axes

  camera.position.x = 0;
  camera.position.y = 0;
  camera.position.z = 20;

  plus = 0.01

  window.XRotationsOn =  false
  window.YRotationsOn =  false
  window.ZRotationsOn =  false

  f = true

  render = ->
    requestAnimationFrame( render );

    # Rotation 1

    # camera.rotateY(plus)
    # camera.position.x = 20 * Math.sin(camera.rotation.y)
    # camera.position.z = 20 * Math.cos(camera.rotation.y)

    # Rotation 2

    # camera.rotateX(plus)
    # camera.position.y = -20 * Math.sin(camera.rotation.x)
    # camera.position.z = 20 * Math.cos(camera.rotation.x)

    # Rotation 3

    if f
      f = false
      camera.rotateX(50*plus)
      camera.rotateY(50*plus)
      camera.rotateZ(50*plus)


    camera.rotateX(plus) if window.XRotationsOn
    camera.rotateY(plus) if window.YRotationsOn
    camera.rotateZ(plus) if window.ZRotationsOn

    sinX = Math.sin(camera.rotation.x)
    sinY = Math.sin(camera.rotation.y)
    cosX = Math.cos(camera.rotation.x)
    cosY = Math.cos(camera.rotation.y)

    camera.position.x = 20 * sinY
    camera.position.y = - 20 * sinX * cosY
    camera.position.z = 20 * cosY * cosX


    renderer.render(scene, camera);

  render();
