@cubeColors = [
  0x006699 # blue
  0x33CC00 # green
  0xE80000 #+ red
  0xFF6600 #+ orange
  0xFFFF00 #+ yellow
  0xFFFFFF #+ white
]

width = window.innerWidth
height = window.innerHeight
cubeSize = width/(2*height)

Cube = (x, y, z)->
  @geometry = new THREE.BoxGeometry( cubeSize, cubeSize, cubeSize );
  @materials = [
    new THREE.MeshBasicMaterial( { color: cubeColors[0], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[1], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[2], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[3], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[4], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
    new THREE.MeshBasicMaterial( { color: cubeColors[5], specular: 0x009900, shininess: 30, shading: THREE.FlatShading } )
  ]
  @cube = new THREE.Mesh @geometry, new THREE.MeshFaceMaterial @materials

  @afterRender = =>
    @cube.position.x += (x*1.1 - 0.5)*cubeSize
    @cube.position.y += (y*1.1 - 0.5)*cubeSize
    @cube.position.z += (z*1.1 - 0.5)*cubeSize

  @


$(document).on 'ready page:load', ->
  scene = new THREE.Scene();
  window.camera = new THREE.PerspectiveCamera( 45, width / height, 1, 1000 );
  # window.camera = new THREE.OrthographicCamera( -width/2 , width/2, -height/2, height/2, -1000, 1000 )

  window.renderer = new THREE.WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  document.body.appendChild( renderer.domElement );


  window.cubes = []
  cubeSide = 5
  for i in [-(cubeSide-1)/2..(cubeSide-1)/2]
    for j in [-(cubeSide-1)/2..(cubeSide-1)/2]
      for k in [-(cubeSide-1)/2..(cubeSide-1)/2]
        window.cubes.push new Cube(i,j,k)

  for cube in cubes
    scene.add( cube.cube );
    do cube.afterRender

  camera.position.x = 0;
  camera.position.y = 0;
  camera.position.z = 20;

  plus = 0.05

  render = ->
    requestAnimationFrame( render );

    ## Rotation 1

    # camera.rotateY(plus)
    # camera.position.x = 20 * Math.sin(camera.rotation.y)
    # camera.position.z = 20 * Math.cos(camera.rotation.y)

    ## Rotation 2

    # camera.rotateX(plus)
    # camera.position.y = -20 * Math.sin(camera.rotation.x)
    # camera.position.z = 20 * Math.cos(camera.rotation.x)

    ## Rotation 3

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
