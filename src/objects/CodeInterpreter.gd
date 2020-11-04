extends Node


var code_source

class CodeLine:
	extends Reference
	var text
	var indent_size
	var line
	func _init(text, indent_size, line = null):
		self.text = text
		self.indent_size = indent_size
		self.line = line
		
var operators

func _add(lhs, rhs):
	return lhs + rhs

func _print(val):
	print(val)
	return 0


class Statement:
	"""Base class for code elements"""
	
	func _init():
		pass
		
	func run(scope, operators):
		pass
		
	func string(start_string = ""):
		pass
		
	func compile(operators):
		pass
		
class BinaryOperator:
	"""Represents a binary operator"""
	var function
	var syntax
	var priority
	
	func _init(function_in, syntax_in, priority_in):
		"""Creates a binary operator. syntax is a string that exactly matches 
		the syntax of the operator ie '+' or 'and'. function is the behaviour 
		of the operator and must take 2 arguments. Priority is used for order of
		operators and should be an int. Higher number means higher priority"""
		self.function = function_in
		self.syntax = syntax_in
		self.priority = priority_in
		
	func identify_operator(text, index):
		"""Checks if this operator starts at the specified index. If so the
		length of the index is returned. Otherwise 0"""
		var result = true
		var offset = 0
		while true:
			if offset >= len(self.syntax):
				return true
			elif offset + index >= len(text):
				return false
			elif self.syntax[offset] != text[offset + index]:
				return false
			offset += 1 
			
	func evaluate(lhs, rhs):
		return self.function.call_func(lhs, rhs)


class UnaryOperator:
	"""Represents a unary operator"""
	var function
	var syntax
	var priority
	
	func _init(function_in, syntax_in, priority_in):
		"""Creates a unary operator. syntax is a string that exactly matches 
		the syntax of the operator ie '+' or 'and'. function is the behaviour 
		of the operator and must take 1 argument. Priority is used for order of
		operators and should be an int. Higher number means higher priority"""
		self.function = function_in
		self.syntax = syntax_in
		self.priority = priority_in
		
	func identify_operator(text, index):
		"""Checks if this operator starts at the specified index. If so the
		length of the index is returned. Otherwise 0"""
		var result = true
		var offset = 0
		while true:
			if offset >= len(self.syntax):
				return true
			elif offset + index >= len(text):
				return false
			elif self.syntax[offset] != text[offset + index]:
				return false
			offset += 1 
	
	func evaluate(value):
		"""Evaluates the operator"""
		return self.function.call_func(value)


class Evaluatable:
	"""Represents an expression with a determinable value"""
	extends Statement
	var expression
	var expressions
	var operator_order
	var compiled
	
	
	func _init(text):
		self.expression = text
		self.compiled = false
		
	func _compile(operators):
		var text = self.expression
		self.expressions = []
		var string_stor = ""
		var index = 0
		while index  < len(text):
			var offset = 0
			for operator in operators:
				offset = operator.identify_operator(text, index)
				if offset:
					self.expressions.push_back(string_stor)
					string_stor = ""
					self.operator_order.push_back(operator)
					index += offset
					break
			if offset == 0:
				if text[index] != " ":
					string_stor += text[index]
				index += 1
		if string_stor != "":
			self.expressions.push_back(string_stor)
		
	func run(scope, operators):
		if not self.compiled:
			self.compile(operators)
		var working_expressions = self.expressions.duplicate()
		var working_operators = self.operator_order.duplicate()
		for index in range(len(working_expressions)):
			if working_expressions[index] in scope:
				working_expressions[index] = scope[working_expressions[index]]
			elif '.' in working_expressions[index]:
				working_expressions[index] = float(working_expressions[index])
			else:
				working_expressions[index] = int(working_expressions[index])
		for operator in operators:
			var priority = operator.priority
			var index = 0
			while index < len(working_operators):
				var op = working_operators[index]
				if op.priority == priority:
					if typeof(op) == typeof(BinaryOperator):
						working_expressions[index] = op.evaluate(working_expressions[index], working_expressions[index + 1])
						working_expressions.remove(index + 1)
						working_operators.remove(index)
		
	func string(start_string = ""):
		return start_string + expression
		
class Assignment:
	"""Represents an assignment"""
	extends Statement
	var lhs
	var rhs
	
	func _init(lhs, rhs):
		self.lhs = lhs
		self.rhs = Evaluatable.new(rhs)
		
	func run(scope, operators):
		scope[self.lhs] = rhs.run(scope, operators)
		
	func string(start_string = ""):
		return start_string + lhs + " = " + rhs.string()
		
class Loop:
	"""Represents a loopdiloop"""
	extends Statement
	var condition
	var end_action
	var code
	
	func _init(condition, code, end_action = null):
		self.condition = Evaluatable.new(condition)
		if end_action != null:
			self.end_action = Evaluatable.new(end_action)
		else:
			self.end_action = null
		self.code = code
	
	func run(scope, operators):
		while condition.run(scope, operators):
			for line in code:
				line.run(scope, operators)
			if end_action != null:
				end_action.run(scope, operators)
				
	func string(start_string = ""):
		var text = start_string + "while " + condition.string() + "\n"
		for line in code:
			text = text + line.string(start_string + "\t") + "\n"
		return text
				
				
class Conditional:
	"""Represents a conditional statement"""
	extends Statement
	var condition
	var code
	var expected_if_state
	
	func _init(condition, code, expected_if_state=null):
		self.expected_if_state = expected_if_state
		self.code = code
		self.condition = Evaluatable.new(condition)
		
	func run(scope, operators):
		if ((expected_if_state == null or expected_if_state == scope["_if_state"]) 
				and condition.run(scope, operators)):
			for line in code:
				line.run(scope, operators)
			scope["_if_state"] = 1
		elif expected_if_state != null:
			scope["_if_state"] = 0

	func string(start_string = ""):
		var text = start_string
		
		if expected_if_state != null:
			if condition.string() == "1":
				text += "else\n"
			else:
				text += "elif " + condition.string() + "\n" 
		else:
			text += "if " + condition.string() + "\n"
		
		for line in code:
			text = text + line.string(start_string + "\t") + "\n"
		return text

		
func _count_leading_spaces(line):
	var count = 0
	for character in line:
		if character == " ":
			count += 1
		else:
			break
	return count

func _lines_from_source():
	
	var lines_text = code_source.split("\t");
	lines_text = lines_text.join("    ")
	lines_text = lines_text.split("\n")
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
	var index = 0
	while index < len(lines):
		var indent = lines[index].indent_size
		var line = lines[index].text
		var splits = line.split("=")
		if line.begins_with("while "):
			var condition = line.substr(6)
			var next_index = len(lines)
			for i in range(index + 1, len(lines)):
				if lines[i].indent_size <= indent:
					next_index = i
					break
			var code = lines.slice(index + 1, next_index - 1)
			code = _statements_from_lines(code)
			index = next_index - 1
			statements.append(Loop.new(condition, code))
		elif line.begins_with("for "):
			pass
		elif line.begins_with("if "):
			var condition = line.substr(3)
			var next_index = len(lines)
			for i in range(index + 1, len(lines)):
				if lines[i].indent_size <= indent:
					next_index = i
					break
			var code = lines.slice(index + 1, next_index - 1)
			code = _statements_from_lines(code)
			index = next_index - 1
			statements.append(Conditional.new(condition, code))
		elif line.begins_with("else") and len(line) == 4:
			if typeof(statements[-1]) != typeof(Conditional):
				print("error")
			var condition = "1"
			var next_index = len(lines)
			for i in range(index + 1, len(lines)):
				if lines[i].indent_size <= indent:
					next_index = i
					break
			var code = lines.slice(index + 1, next_index - 1)
			code = _statements_from_lines(code)
			index = next_index - 1
			statements.append(Conditional.new(condition, code, 0))
		elif line.begins_with("elif "):
			if typeof(statements[-1]) != typeof(Conditional):
				print("error")
			var condition = line.substr(5)
			var next_index = len(lines)
			for i in range(index + 1, len(lines)):
				if lines[i].indent_size <= indent:
					next_index = i
					break
			var code = lines.slice(index + 1, next_index - 1)
			code = _statements_from_lines(code)
			index = next_index - 1
			statements.append(Conditional.new(condition, code, 0))
		elif len(splits) % 2 == 0: #Even number implies odd number of =, means assignment
			var lhs = splits[0]
			var rhs = ""
			for split_index in range(1, len(splits)):
				rhs += splits[split_index] + "="
			rhs = rhs.substr(0, len(rhs) - 1)
			statements.append(Assignment.new(lhs, rhs))
		else:	#Raw expression
			statements.append(Evaluatable.new(line))
		index += 1
	return statements

func operator_cmp(lhs, rhs):
	return (lhs.priority >= rhs.priority)

func _ready():
	operators = []
	operators.push_back(BinaryOperator.new(funcref(self, "_add"), "+", 10))
	operators.push_back(UnaryOperator.new(funcref(self, "_print"), " print ", 1000))
	operators.sort_custom(self, "operator_cmp")
# Run the code
func run():
	# Generate code from source, preferably 
	# expressions that link to new expressions
	code_source = """
while a >    5
	print("hye")
	lalala = 7
	if apa
		while apa
			eat food
a = 5
while b > 5
	print a
"""
	var lines = _lines_from_source()
	var statements = _statements_from_lines(lines)
	for statement in statements:
		print(statement.string())

	
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
		print("[Interpreter] Sensor distance: %f" % result[0])
	
# The code interpreting should stop if:
# 1. A signal function is emitted
# 2. The total runtime exceeds some limit, maybe 5 ms?
# 3. The interpreting is complete
