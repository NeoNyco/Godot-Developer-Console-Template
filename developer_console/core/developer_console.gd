class_name DeveloperConsole extends Node

@export var _command_submmit_key : StringName = &"enter"
@export var _history : RichTextLabel
@export var _input_field : CodeEdit
@export var console_commands : Array[ConsoleCommand]
	
var _nodes : Dictionary[String, Node]

func _enter_tree() -> void:
	self.add_to_group("main_dev_console")

func register_node(node : Node) -> void:
	if _nodes.has(node.name):
		output_error("Tried to register %s but it is already registered." %node.name)
		return
	_nodes[node.name] = node
	output_success("Node '%s' registered" %node.name)

func output_error(msg : String) -> void:
	output("red", msg)

func output_success(msg : String) -> void:
	output("green", msg)

func output(color : String, msg : String) -> void:
	if _history == null:
		push_error("No history assigned to the dev shit.")
		return
	_history.append_text("\n[color=%s]%s.[/color]" %[color, msg])	


func output_commands() -> void:
	if console_commands.is_empty():
		output_error("There no commands yet")
		return;
	for console_command : ConsoleCommand in console_commands:
		if not console_command:
			continue
		var description : String = (
			"No description" if console_command.description.is_empty() 
			else console_command.description
			)
		
		output("white", "/%s - %s" %[console_command.command, description])

func _get_splitted_command(raw_command : String) -> PackedStringArray:
	if not raw_command.begins_with("/"):
		return PackedStringArray()
	return raw_command.trim_prefix("/").split(" ", false)


func _get_actual_user_command(raw_command : String) -> String:
	return _get_splitted_command(raw_command)[0]

func _get_user_arguments(raw_command : String) -> PackedStringArray:
	return _get_splitted_command(raw_command).slice(1)


func _get_console_command_match(command : String) -> ConsoleCommand:
	var command_match : ConsoleCommand 
	
	for console_command : ConsoleCommand in console_commands:
		if not console_command:
			continue
		if console_command.command == command:
			command_match = console_command
			break
			
	return command_match

func _get_expected_arguments(console_command : ConsoleCommand) -> Array[CommandArgument.ArgumentType]:
	var result : Array[CommandArgument.ArgumentType]
	for console_argument in console_command.arguments:
		if not console_argument:
			continue
		result.append(console_argument.argument_type)
	return result

func _process_command() -> void:
	var raw_command : String = _input_field.text.strip_edges()
	_input_field.clear()

	var splitted : PackedStringArray = _get_splitted_command(raw_command)
	if splitted.is_empty():
		return  

	var actual_command : String = splitted[0]
	var user_arguments : PackedStringArray = splitted.slice(1)

	var console_command : ConsoleCommand = _get_console_command_match(actual_command)
	if not console_command:
		output_error("Unknown command '%s'. Use /Help to see the list of commands" % actual_command.replace("[", "[lb]"))
		return
		
	console_command.console = self
	
	var expected_arguments : Array[CommandArgument.ArgumentType] = _get_expected_arguments(console_command)
	if expected_arguments.size() != user_arguments.size():
		output_error("Command '%s' expected %s arguments but got %s"
				% [actual_command, expected_arguments.size(), user_arguments.size()])
		return

	var final_args : Array = []

	for i : int in expected_arguments.size():
		var raw : String = user_arguments[i]

		match expected_arguments[i]:   
			CommandArgument.ArgumentType.NODE:
				if not _nodes.has(raw):
					output_error("No node found for argument %s ('%s')" % [i + 1, raw])
					return
				final_args.append(_nodes[raw])

			CommandArgument.ArgumentType.INT:
				if not raw.is_valid_int():
					output_error("Argument %s expected an Int" % [i + 1])
					return
				final_args.append(raw.to_int())

			CommandArgument.ArgumentType.FLOAT:
				if not raw.is_valid_float():
					output_error("Argument %s expected a Float" % [i + 1])
					return
				final_args.append(raw.to_float())

			CommandArgument.ArgumentType.STRING:
				final_args.append(raw)

	console_command.call("execute", final_args) 


func _input(event: InputEvent) -> void:
	if _input_field == null or not _input_field.has_focus():
		return
	if not event.is_action(_command_submmit_key):
		return

	get_viewport().set_input_as_handled()

	if event.is_pressed() and not event.is_echo():
		_process_command()
