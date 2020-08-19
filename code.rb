class Animal
	attr_reader :type
	
	def initialize(type)
		@type = type
	end

	def is_a_peacock?
		if type == "peacock"
			return true
		else
			return false
		end
	end
end
