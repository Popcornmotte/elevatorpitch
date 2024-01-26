extends RichTextLabel
class_name ControlsLabel

enum LINE {exit, grab, secondary, selectModule, fling, chutes, toggleNet, moveNet}
enum HIGHLIGHT {disabled, normal, highlightA, highlightB}
var lines : PackedStringArray
var highlights : Array[HIGHLIGHT]
var highlightState = false

func _ready():
	return
	lines = text.split("\n")
	for line in lines:
		lines.append(line)
		highlights.append(HIGHLIGHT.normal)

func setHighlight(line : LINE, highlight : HIGHLIGHT):
	highlights[line] = highlight

func updateText():
	var newText = ""
	for i in range(0,lines.size()):
		var newLine = ""
		match (highlights[i]):
			HIGHLIGHT.disabled:
				newLine.append("[color=#A0A0A0]")
			HIGHLIGHT.normal:
				newLine.append("[color=#FFFFFF]")
			HIGHLIGHT.highlightA:
				highlights[i] = HIGHLIGHT.highlightB
				newLine.append("[color=#40FF20]")
			HIGHLIGHT.highlightB:
				highlights[i] = HIGHLIGHT.highlightA
				newLine.append("[color=#008000]")
		newLine.appaend(lines[i] + "[/color]")
	text = newText

func onHighlightTimerTimeout():
	highlightState = !highlightState
	#updateText()
