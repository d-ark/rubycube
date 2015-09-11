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

Cube = (x, y, z, colors)->
  @geometry = new THREE.BoxGeometry( cubeSize, cubeSize, cubeSize );
  @materials = [
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[0]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[1]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[2]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[3]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[4]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[colors[5]], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  ]
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials

  @afterRender = =>
    @cube.position.x = (x*1.1 - 0.5)*cubeSize
    @cube.position.y = (y*1.1 - 0.5)*cubeSize
    @cube.position.z = (z*1.1 - 0.5)*cubeSize

  @

MainCube = (count, side, color)->
  @geometry = new THREE.BoxGeometry( side*count*1.06, side*count*1.06, side*count*1.06 );
  @materials = [
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: color, specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  ]
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials

  @afterRender = =>
    @cube.position.x = @cube.position.y = @cube.position.z = (-0.5)*side

  @

cubesForNormalCube = (cubeSide)->
  cubes = []

  firstCube = -(cubeSide-1)/2
  lastCube = (cubeSide-1)/2


  for i in [firstCube+1..lastCube-1]
    for j in [firstCube+1..lastCube-1]
      cubes.push new Cube(i, j, firstCube, [6,6,6,6,6,5])
      cubes.push new Cube(i, j, lastCube , [6,6,6,6,4,6])
      cubes.push new Cube(i, firstCube, j, [6,6,6,3,6,6])
      cubes.push new Cube(i, lastCube, j , [6,6,2,6,6,6])
      cubes.push new Cube(firstCube, i, j, [6,1,6,6,6,6])
      cubes.push new Cube(lastCube, i, j , [0,6,6,6,6,6])

  for i in [firstCube+1..lastCube-1]
    cubes.push new Cube(i, firstCube, firstCube, [6,6,6,3,6,5])
    cubes.push new Cube(i, firstCube, lastCube, [6,6,6,3,4,6])
    cubes.push new Cube(i, lastCube, firstCube, [6,6,2,6,6,5])
    cubes.push new Cube(i, lastCube, lastCube, [6,6,2,6,4,6])

    cubes.push new Cube(firstCube, i, firstCube, [6,1,6,6,6,5])
    cubes.push new Cube(firstCube, i, lastCube, [6,1,6,6,4,6])
    cubes.push new Cube(lastCube, i, firstCube, [0,6,6,6,6,5])
    cubes.push new Cube(lastCube, i, lastCube, [0,6,6,6,4,6])

    cubes.push new Cube(firstCube, firstCube, i, [6,1,6,3,6,6])
    cubes.push new Cube(firstCube, lastCube, i, [6,1,2,6,6,6])
    cubes.push new Cube(lastCube, firstCube, i, [0,6,6,3,6,6])
    cubes.push new Cube(lastCube, lastCube, i, [0,6,2,6,6,6])

  cubes.push new Cube(firstCube, firstCube, firstCube, [6,1,6,3,6,5])
  cubes.push new Cube(firstCube, firstCube, lastCube,  [6,1,6,3,4,6])
  cubes.push new Cube(firstCube, lastCube, firstCube,  [6,1,2,6,6,5])
  cubes.push new Cube(firstCube, lastCube, lastCube,   [6,1,2,6,4,6])
  cubes.push new Cube(lastCube, firstCube, firstCube,  [0,6,6,3,6,5])
  cubes.push new Cube(lastCube, firstCube, lastCube,   [0,6,6,3,4,6])
  cubes.push new Cube(lastCube, lastCube, firstCube,   [0,6,2,6,6,5])
  cubes.push new Cube(lastCube, lastCube, lastCube,    [0,6,2,6,4,6])

  cubes.push new MainCube(cubeSide, cubeSize, cubeColors[6])

  cubes


$(document).on 'ready page:load', ->
  scene = new THREE.Scene();
  window.camera = new THREE.PerspectiveCamera( 45, width / height, 1, 1000 );
  # window.camera = new THREE.OrthographicCamera( -width/2 , width/2, -height/2, height/2, -1000, 1000 )

  window.renderer = new THREE.WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  document.body.appendChild( renderer.domElement );

  for cube in cubesForNormalCube(5)
    scene.add( cube.cube );
    do cube.afterRender

  camera.position.x = 0;
  camera.position.y = 0;
  camera.position.z = 20;

  plus = 0.01

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

    camera.rotateX(plus)
    camera.rotateY(plus)

    sinX = Math.sin(camera.rotation.x)
    sinY = Math.sin(camera.rotation.y)
    cosX = Math.cos(camera.rotation.x)
    cosY = Math.cos(camera.rotation.y)

    camera.position.x = 20 * sinY
    camera.position.y = - 20 * sinX * cosY
    camera.position.z = 20 * cosY * cosX

    renderer.render(scene, camera);

  render();
