class_name Help extends ConsoleCommand

func _init() -> void:
	command = "Help"
	description = "Returns the commands and what a description of what they do"

func execute(args : Array) -> void:
	console.output_commands()
