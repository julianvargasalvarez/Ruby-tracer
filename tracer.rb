# creates an array with all method definitions in the given paths
#
# myfile.rb      def my_method(a,b)
#
definitions = `grep -r "def " app/ lib/`.split("\n")

definitions.each do |definition|
  # extracts the method name in the definition found by the former grep
  # 
  # myfile.rb    def my_method!(a,b)            =>  my_method!
  # myfile.rb    def self.another_method?(d,e)  =>  another_method?
  #
  match = /def (self\.)*(?<method_name>\w+(\?|\!|))/.match(definition)

  next unless match

  method_name = match[:method_name]
  
  # search for the method name usage in the given paths
  method_results = `grep -r #{method_name} app/ lib/`.split("\n")

  # if there is only one result it should be the definition
  # therefore the method is not used anywhere
  puts "====>#{method_name}" if method_results.count == 1

end
