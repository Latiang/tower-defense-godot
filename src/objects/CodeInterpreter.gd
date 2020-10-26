extends Node



var code_source = """Very #good comment
	  			9 = 3
				8 == 5
	 
	\t
 a = 4
   hej din apa
   p = np?
nice"""

class CodeLine:
	extends Reference
	var text
	var indent_size
	var line
	func _init(text, indent_size, line = null):
		self.text = text
		self.indent_size = indent_size
		self.line = line


class NextStatement:
	"""Determines the next statement"""
	var conditional
	var statement
	var condition
	var conditional_statement
	
	func _init(statement, conditional_statement = null, condition = ""):
		self.statement = statement
		if conditional_statement:
			self.conditional = true
		else:
			self.conditional = false
		self.conditional_statement = conditional_statement
		self.condition = condition
		
	func access_index():
		if conditional:
			pass
		else:
			return statement
		

class Statement:
	"""Corresponds to one line of code. Contains a reference to the next line"""
	var next_statement
	var assignment
	var lhs
	var rhs
	
	func _init(rhs, next_statement, lhs = null):
		self.lhs = lhs
		if lhs:
			self.assignment = true
		else:
			self.assignment = false
		self.rhs = rhs
		self.next_statement = next_statement
		

class Evaluatable:
	var text
	
	func _init(text):
		self.text = text

func _count_leading_spaces(line):
	var count = 0
	for character in line:
		if character == " ":
			count += 1
		else:
			break
	return count

func _lines_from_source():
	var lines_text = code_source.split("\n");
	# Generate code from source, preferably 
	# expressions that link to new expressions
	var lines = []
	for index in range(len(lines_text)):
		var line = lines_text[index]
		
		var leading_spaces = _count_leading_spaces(line)
		var text = line
		text = text.split("#")
		text = text[0]
		text = text.split("//")
		text = text[0]
		text = text.strip_edges()
		if text == "":
			continue
		lines.append(CodeLine.new(text, leading_spaces, index + 1))
	return lines

func _statements_from_lines(lines):
	var statements = []
	# Statements need to cover loops as well in order to properly work
	# ToDo
	for index in range(len(lines)):
		var indent = lines[index].indent_size
		var line = lines[index].text
		var splits = line.split("=")
		if line.begins_with("while"):
			pass
		elif line.begins_with("for"):
			pass
		elif line.begins_with("if"):
			line = line.substr(2)
			var next_index = index + 1
			for i in range(index + 1, len(lines)):
				if lines[i].indent_size <= indent:
					next_index = i
					break
		elif line.begins_with("else"):
			pass
		elif line.begins_with("elif"):
			pass
		elif len(splits) % 2 == 0: #Even number implies odd number of =, means assignment
			var lhs = splits[0]
			var rhs = ""
			for split_index in range(1, len(splits)):
				rhs += splits[split_index] + "="
			rhs = rhs.substr(0, len(rhs) - 1)
			var next_statement = NextStatement.new(index + 1)
			statements.append(Statement.new(rhs, next_statement, lhs))
		else:	#Raw expression
			var next_statement = NextStatement.new(index + 1)
			statements.append(Statement.new(line, next_statement))
	return statements


func _ready():
	pass

# Run the code
func run():
	# Generate code from source, preferably 
	# expressions that link to new expressions
	var lines = _lines_from_source()
	var statements = _statements_from_lines(lines)
	for statement in statements:
		if statement.assignment:
			pass
			#print(statement.lhs,"=", statement.rhs)
		else:
			pass
			#print(statement.rhs)
	# Step 1: Find lines with actual code on it.
	
	
	# Interpret the code
	# Certain functions will have outside effects, which is done by:
	#get_parent().emit_signal("fire")
	#get_parent().emit_signal("rotate", 50)
	# The interpreting should be stopped after executing such a function until the
	# run() function is executed again
	# Some outside functions give a return value in a dictionary, t.ex a sensor raycast
	var result = {}
	get_parent().emit_signal("sensor_detect", result, 1)
	if result[0]:
		print("Sensor distance: %f" % result[0])

# The code interpreting should stop if:
# 1. A signal function is emitted
# 2. The total runtime exceeds some limit, maybe 5 ms?
# 3. The interpreting is complete
