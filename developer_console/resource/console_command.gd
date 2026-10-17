##A class for developer console commands.
class_name ConsoleCommand extends Resource

##What needs to be written for it to be executed.
@export var command : String
##The arguments required for it to work, make sure it matches what your function uses.
@export var arguments : Array[CommandArgument]
##The description of the command, useful when used with /Help.
@export_multiline var description : String

var console : DeveloperConsole

##The function that will be executed once the command has been executed, just override with your own.
func execute(args : Array) -> void:
	pass
