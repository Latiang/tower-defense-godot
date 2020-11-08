extends Node


var code_source
var console_output_buffer = []

class CodeLine:
	var text
	var indent_size
	var line
	func _init(text, indent_size, line = null):
		self.text = text
		self.indent_size = indent_size
		self.line = line
		
var operators

var _eval_object

var _lines_left = 0
export var OPS_PER_RUN = 200

func _shoot(value):
	pass
	
func _dist(value):
	pass

func _negate(value):
	return -value

func _power(lhs, rhs):
	return pow(lhs, rhs)

func _multiply(lhs, rhs):
	return lhs * rhs
	
func _divide(lhs, rhs):
	return float(lhs) / rhs

func _add(lhs, rhs):
	return lhs + rhs
	
func _sub(lhs, rhs):
	return lhs - rhs

func _equals(lhs, rhs):
	return lhs == rhs

func _greater_than(lhs, rhs):
	return lhs > rhs
	
func _less_than(lhs, rhs):
	return lhs < rhs
	
func _and(lhs, rhs):
	return lhs and rhs
	
func _or(lhs, rhs):
	return lhs or rhs

func _find_print(text, index):
		var result = true
		var original_text = text
		text = text.right(index)
		if text.begins_with(" print "):
			return len(" print ")
		elif text.begins_with("print ") and index == 0:
			return len("print ")
		return 0
	
func _run_code():
	var lines = _lines_from_source()
	var statements = _statements_from_lines(lines)
	#for statement in statements:
		#print(statement.string())
	var scope = {}
	scope["_if_state"] = 0
	var res
	for statement in statements:
		res = statement.run(scope, self)
		while res is GDScriptFunctionState and res.is_valid():
			yield()
			res = res.resume()
		
func _print(val):
	print(val)
	return 0


class Statement:
	"""Base class for code elements"""
	
	func _init():
		pass
		
	func run(scope, parent):
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
	var binary
	var neutral_element
	var padding
	func _init(function_in, syntax_in, priority_in, require_padding=false, neutral_element_in=null):
		"""Creates a binary operator. syntax is a string that exactly matches 
		the syntax of the operator ie '+' or 'and'. function is the behaviour 
		of the operator and must take 2 arguments. Priority is used for order of
		operators and should be an int. Higher number means higher priority"""
		self.function = function_in
		self.binary = true
		self.syntax = syntax_in
		self.priority = priority_in
		self.neutral_element = neutral_element_in
		self.padding = require_padding
		
		
	func identify_operator(text, index):
		"""Checks if this operator starts at the specified index. If so the
		length of the index is returned. Otherwise 0"""
		if typeof(self.syntax) == TYPE_STRING:
			text = text.right(index)
			if self.padding:
				if text.begins_with(" " + self.syntax + " "):
					return len(self.syntax) + 2
				elif index == 0 and text.begins_with(self.syntax + " "):
					return len(self.syntax) + 1
			else:
				if text.begins_with(self.syntax):
					return len(self.syntax)
				else:
					return 0
		else:
			return self.syntax.call_func(text, index)
			
	func evaluate(lhs, rhs):
		if self.neutral_element != null:
			if typeof(lhs) == TYPE_STRING:
				lhs = neutral_element
		return self.function.call_func(lhs, rhs)


class UnaryOperator:
	"""Represents a unary operator"""
	var function
	var syntax
	var priority
	var binary
	var padding
	
	func _init(function_in, syntax_in, priority_in, require_padding=false):
		"""Creates a unary operator. syntax is a string that exactly matches 
		the syntax of the operator ie '+' or 'and'. function is the behaviour 
		of the operator and must take 1 argument. Priority is used for order of
		operators and should be an int. Higher number means higher priority"""
		self.function = function_in
		self.syntax = syntax_in
		self.binary = false
		self.priority = priority_in
		self.padding = require_padding
		
	func identify_operator(text, index):
		"""Checks if this operator starts at the specified index. If so the
		length of the index is returned. Otherwise 0"""
		if typeof(self.syntax) == TYPE_STRING:
			text = text.right(index)
			if self.padding:
				if text.begins_with(" " + self.syntax + " "):
					return len(self.syntax) + 2
				elif index == 0 and text.begins_with(self.syntax + " "):
					return len(self.syntax) + 1
			else:
				if text.begins_with(self.syntax):
					return len(self.syntax)
				else:
					return 0
		else:
			return self.syntax.call_func(text, index)
	
	func evaluate(value):
		"""Evaluates the operator"""
		return self.function.call_func(value)


class Evaluatable:
	"""Represents an expression with a determinable value"""
	extends Statement
	var source
	var lhs
	var rhs
	var op
	var compiled
	#Needs to build a tree
	#Tree prefered in order to properly apply multiple unary operators with differeing
	#priority
	
	func _init(text):
		self.source = text
		self.compiled = false
		
	func _compile(operators):
		self.compiled = true
		self.source = self.source.strip_edges()
		while self.source != "" and self.source[0] == "(" and self.source[-1] == ")":
			self.source = self.source.right(1)
			self.source = self.source.left(len(self.source) - 1)
			self.source = self.source.strip_edges()
		#TODO:
		#	Determine if the source is surrounded by ()
		self.lhs = null
		self.rhs = null
		self.op = null
		#We want to find the last operator that is applied outside of
		#a parenthasis.
		#operators is sorted by priority so by iterating over
		#it in reverse order we start by looking for the operator
		#with the lowest priority
		var found_operator = false
		for index in range(len(operators) - 1, -1, -1):
			var operator = operators[index]
			var parenthasis_count = 0
			for char_index in range(len(self.source)):
				if self.source[char_index] == ")":
					parenthasis_count -= 1
				elif self.source[char_index] == "(":
					parenthasis_count += 1
				if parenthasis_count != 0:
					continue
				#We now want to find the first instance of the specific operator
				var offset = operator.identify_operator(self.source, char_index)
				if parenthasis_count != 0:
					offset = 0
				if offset:
					#Operator found
					self.op = operator #This is the operator we want to apply
					var end_index = char_index + offset
					found_operator = true
					#operator starts at char_index and ends at char_index + offset - 1
					self.lhs = self.source.left(char_index)
					self.rhs = self.source.right(char_index + offset)
					break
			if found_operator:
				break
		if found_operator:
			self.rhs = Evaluatable.new(self.rhs)
			if self.op.binary:
				self.lhs = Evaluatable.new(self.lhs)
			else: #Unary operator
				self.lhs = null
		else:	#No operator found
			if self.source.is_valid_integer():
				self.lhs = int(self.source)
			elif self.source.is_valid_float():
				self.lhs = int(self.source)
			else:
				self.lhs = self.source
				
	
	func run(scope, parent):
		parent._lines_left -= 1
		if parent._lines_left <= 0:
			yield()
		var left
		var right
		if not self.compiled:
			self._compile(parent.operators)
		if self.lhs == null: 
			#Unary operator
			right = self.rhs.run(scope, parent)
			while right is GDScriptFunctionState: #If it is invalide we have a problem
				yield()
				right = right.resume()
			return self.op.evaluate(right)
		elif self.op == null:
			#Expression contains a value
			if typeof(self.lhs) == TYPE_STRING && self.lhs != "":
				return scope[self.lhs]
			return self.lhs
		else:
			#BinaryOperator
			left = self.lhs.run(scope, parent)
			while left is GDScriptFunctionState:
				yield()
				left = left.resume()
			
			right = self.rhs.run(scope, parent)
			while right is GDScriptFunctionState:
				yield()
				right = right.resume()
			return self.op.evaluate(left, right)
		
	func string(start_string = ""):
		return start_string + self.source

class Assignment:
	"""Represents an assignment"""
	extends Statement
	var lhs
	var rhs
	
	func _init(lhs, rhs):
		self.lhs = lhs.strip_edges()
		self.rhs = Evaluatable.new(rhs)
		
	func run(scope, parent):
		parent._lines_left -= 1
		if parent._lines_left <= 0:
			yield()
		var inp = rhs.run(scope, parent)
		while inp is GDScriptFunctionState:
			yield()
			inp = inp.resume()
		scope[self.lhs] = inp
		
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
	
	func run(scope, parent):
		parent._lines_left -= 1
		var exe
		if parent._lines_left <= 0:
			yield()
		var cond_val = condition.run(scope, parent)
		while cond_val is GDScriptFunctionState:
			yield()
			cond_val = cond_val.resume()
		while cond_val:
			for line in code:
				exe = line.run(scope, parent)
				while exe is GDScriptFunctionState and exe.is_valid():
					yield()
					exe = exe.resume()
			if end_action != null:
				exe = end_action.run(scope, parent)
				while exe is GDScriptFunctionState:
					yield()
					exe = exe.resume()
			cond_val = condition.run(scope, parent)
			while cond_val is GDScriptFunctionState:
				yield()
				cond_val = cond_val.resume()
				
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
		
	func run(scope, parent):
		parent._lines_left -= 1
		if parent._lines_left <= 0:
			yield()
		var cond = false
		var start_if_state = scope["_if_state"]
		if expected_if_state == null or expected_if_state == scope["_if_state"]:
			cond = self.condition.run(scope, parent)
			while cond is GDScriptFunctionState:
				yield()
				cond = cond.resume()
			if cond:
				for line in code:
					var exe = line.run(scope, parent)
					while exe is GDScriptFunctionState and exe.is_valid():
						yield()
						exe = exe.run()
				scope["_if_state"] = 1
			elif expected_if_state == null:
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
	operators.push_back(BinaryOperator.new(funcref(self, "_power"),
										"^", 
										30))
	operators.push_back(BinaryOperator.new(funcref(self, "_multiply"),
										"*", 
										20))
	operators.push_back(BinaryOperator.new(funcref(self, "_divide"),
										"/", 
										20))
	operators.push_back(BinaryOperator.new(funcref(self, "_add"),
										"+", 
										10,
										false,
										0))
	operators.push_back(BinaryOperator.new(funcref(self, "_sub"),
										"-", 
										10,
										false,
										0))
	operators.push_back(UnaryOperator.new(funcref(self, "_print"), 
										"print",
										-1000,
										true))
	operators.push_back(BinaryOperator.new(funcref(self, "_equals"),
										"==", 
										-100))
	operators.push_back(BinaryOperator.new(funcref(self, "_less_than"),
										"<", 
										-100))
	operators.push_back(BinaryOperator.new(funcref(self, "_greater_than"),
										">", 
										-100))
	operators.push_back(BinaryOperator.new(funcref(self, "_and"),
										"and",
										-101,
										true))
	operators.push_back(BinaryOperator.new(funcref(self, "_or"),
										"or",
										-102,
										true))
	operators.sort_custom(self, "operator_cmp")
	for operator in operators:
		print(operator.syntax)
	self._eval_object = null
# Run the code
func run():
	self._lines_left += self.OPS_PER_RUN
	code_source = """
n = 0
while 1
	print n
	n = n + 1
"""
	if self._eval_object == null:
		self._eval_object = self._run_code()
	else:
		if self._eval_object is GDScriptFunctionState and self._eval_object.is_valid():
			self._eval_object = self._eval_object.resume()
	
	# Generate code from source, preferably 
	# expressions that link to new expressions
	
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
		console_output_buffer.append("Sensor 1 distance: %f" % result[0])
	
	
func ready_code():
	self._eval_object = null
# The code interpreting should stop if:
# 1. A signal function is emitted
# 2. The total runtime exceeds some limit, maybe 5 ms?
# 3. The interpreting is complete
