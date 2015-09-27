# coding: utf-8
class Person
  def properties
    instance_variables.map(&->(v) { v.to_s[1..-1] })
  end

  def information
    self.properties.map{ |n| [n, send(n)] }.to_h
  end

  def present(indent=2)
    puts '{'
    profile = self.information
    max_len = profile.keys.map(&:length).max
    profile.each { |name, value|
      print "#{' ' * indent}#{name.to_sym.inspect}"
      print "#{' ' * (max_len - name.length)}"
      puts  " => #{value.inspect.encode('UTF-8')},"
    }
    puts '}'
  end

  def method_missing(method_name, *args)
    if /^(?<property>.+)=$/ =~ method_name
      var_name = "@#{property}"
      instance_variable_set(var_name, args[0])
      self.class.class_eval {
        define_method(property) {
          instance_variable_get(var_name)
        }
      } 
    end
  end
end

if __FILE__ == $0
  kzh001 = Person.new 
  
  kzh001.name = "kzh001"
  kzh001.age  = "**"

  kzh001.present
end

