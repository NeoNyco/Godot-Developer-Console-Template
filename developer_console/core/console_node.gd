##Automatically registers its parent as a Node for the developer console
class_name ConsoleNode extends Node



func _ready() -> void:
	var console : DeveloperConsole = get_tree().get_first_node_in_group("main_dev_console")
	var parent : Node = self.get_parent() as Node
	if parent and console:
		console.register_node(parent)
		
