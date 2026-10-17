class_name GetNodeChildCount extends ConsoleCommand

func _init() -> void:
	command = "GetNodeChildCount"
	arguments.append(CommandArgument.new())
	description = "Returns the amount of children a node has"
	

func execute(args : Array) -> void:
	_get_node_child_count(args[0])

func _get_node_child_count(node : Node) -> void:
	if not node:
		console.output_error("Node does not exist")
		return
	console.output("White", "Childs of %s: %s" %[node, node.get_child_count()] )
