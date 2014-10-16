# Importeer PSD
PSD = Framer.Importer.load "imported/framer"
    
# BG Layer
PSD.bg.draggable.enabled = false
PSD.text.draggable.enabled = true

PSD.menu.superLayer = PSD.bg
PSD.bg.addSubLayer(PSD.menu)
PSD.bg.addSubLayer(PSD.text)
PSD.bg.addSubLayer(PSD.topbar)

PSD.bg.states.add
	down: {y:919}

PSD.navigation.y = -919
PSD.navigation.states.add
    visible: {y:0}

PSD.navigation.states.animationOptions = 
    curve: "spring(200,20,0)"

PSD.bg.states.animationOptions = 
    curve: "spring(200,20,0)"

PSD.menu.on Events.Click, ->
   	PSD.navigation.states.next()
   	PSD.bg.states.next()


initX = PSD.text.x
initMidX = PSD.text.midX
initY = PSD.text.y
windowHeight = window.innerHeight
windowWidth = window.innerHeight

# When the layer is being dragged, we change the speed (resistance) dynamically, based on how far away the cursor is from the starting point of the layer.
PSD.text.on Events.DragMove, (event) ->
  
  # Grab the delta for x distance (We do this for X and not for Y because the bobble is horizontally in the middle of the screen, so delta can be positive or negative
  deltaX = initMidX - event.x
  
  # Since the Y drag can basically only go in one direction, we can immediately map the range. This handy function takes the current y position and maps that from the initial Y to the maximum Y, in this case the window height to a 0.5 to 1 range. This means that the further away from the layer's initial position the drag is, the more resistance we add, such that if you drag all the way to the bottom of the view, the layer will eventually be unable to go further.
  speedY = Utils.mapRange(event.y, windowHeight, initY, 1, 1)
  
  # Since you can drag left or right, we need to map the range correctly. If deltaX is positive, we map from the start of the view to the mid point of the layer (everything left of the layer). If the deltaX is negative, we map from the mid point of the layer to the edge of the screen (everything right of the layer).
  if deltaX > 0
    speedX = Utils.mapRange(event.x, 0, initMidX, 1, 1)
  else
    speedX = Utils.mapRange(event.x, windowWidth, initMidX, 1, 1)
  
  # Set the speeds
  PSD.text.draggable.speedY = 0
  PSD.text.draggable.speedX = speedX

# When the drag is finished, snap back to initial position  
PSD.text.on Events.DragEnd, ->
  PSD.text.animate 
    properties:
      x: initX,
      y: initY
    curve: "spring(300,18,10)"
 
 



