extends RichTextLabel
class_name ControlsLabel

enum LINE {exit, grab, secondary, selectModule, fling, chutes, toggleNet, moveNet, close}
enum HIGHLIGHT {disabled, normal, highlight}
var lines : PackedStringArray
var highlights : Array[HIGHLIGHT]
var highlightState = false
var highlighted = 0
var hovered = false
var toggledVisible = true
var fade = 0.0
@export var fadeLocked = false

func _ready():
	lines = text.split("\n")
	for line in lines:
		highlights.append(HIGHLIGHT.normal)

func setHighlight(line : LINE, highlight : HIGHLIGHT):
	highlights[line] = highlight
	highlighted = 0
	for entry in highlights:
		if entry == HIGHLIGHT.highlight:
			highlighted += 1
	updateText()

func updateText():
	var newText = ""
	for i in range(0,lines.size()):
		var newLine = ""
		match (highlights[i]):
			HIGHLIGHT.disabled:
				newLine += "[color=#606060]"
			HIGHLIGHT.normal:
				newLine += "[color=#FFFFFF]"
			HIGHLIGHT.highlight:
				newLine += "[color=#40FF20]" if highlightState else "[color=#E0FF20]"
		newText += newLine + lines[i] + "[/color]\n"
	text = newText
	#print(newText)

func onHighlightTimerTimeout():
	if highlighted > 0:
		highlightState = !highlightState
		updateText()

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
	
func _process(delta):
	#if !fadeLocked:
		#if hovered:
			#fade = min(1.0,fade + 8*delta)
		#else:
			#fade = max(0.0, fade - delta/2)
		#get_parent().set_modulate(Color(1,1,1,0.1).lerp(Color(1,1,1,1), fade))
	if Input.is_action_just_pressed("ToggleLegend") and Global.elevator.controlArms:
		if highlights[LINE.close] != HIGHLIGHT.disabled:
			toggledVisible = !toggledVisible
		get_parent().visible = toggledVisible
