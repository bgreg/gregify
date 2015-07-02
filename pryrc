%w[rubygems awesome_print rexml/document].each do |gem|
  begin
    require gem
  rescue LoadError
    puts "You are missing a cool gem: #{gem}"
    exit 
  end
end

AwesomePrint.pry!

# Pry.editor = 'vim'
Pry.config.color = true
Pry.config.pager = true
Pry.config.auto_indent = true

# wrap ANSI codes so Readline knows where the prompt ends
def custom_color(name, text)
  if Pry.color
    "\001#{Pry::Helpers::Text.send name, '{text}'}\002".sub '{text}', "\002#{text}\001"
  else
    text
  end
end

Pry.config.prompt = [
  proc do |object, nest_level, pry|
    prompt = ""
    prompt += "Ruby:(#{custom_color(:purple, "#{RUBY_VERSION.to_s}")}) "
    prompt += "object:("
    prompt += custom_color(:yellow, Pry.view_clip(object))
    prompt += ":#{nest_level}" if nest_level > 0
    prompt += ")"
    "#{prompt} #{custom_color(:purple, '>> ')}"
  end, 
  proc { |object, nest_level, pry| custom_color( :cyan, '>>' ) }
]

Pry.config.commands.import(
  Pry::CommandSet.new do
    command "copy", "Copies any supplied string to the system clip board"  do |string|
      IO.popen('pbcopy', 'w') { |f| f << string.to_s }
    end

    command "sql", 
            "Send any supplied SQL statement to the currently connected ActiveRecord database.", 
            requires_gem: ['activerecord'] do |query|
      ActiveRecord::Base.connection.select_all(query)
    end

    command "caller_method", "Reveal the caller of the current method." do |depth|
      depth = depth.to_i || 1
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth+1).first
        file = Regexp.last_match[1]
        line = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        output.puts [file, line, method]
      end
    end

    command "printx", "Pretty print any given XML string." do |xml_string|
      doc = REXML::Document.new(xml_string) 
      output_string = ""
      doc.write(output_string, 1)
      output.puts(output_string)
    end

    command "array_toy",
            "Returns an Array object keyed from 1 to 10. This is helpful for experimenting with the Array library.", 
            keep_retval: true do
      Array.new(10) { |i| i+1 }
    end

    command "hash_toy", 
            "Returns a hash object keyed from 'a' to 'j'. This is helpful for experimenting with the hash library.", 
            keep_retval: true do
      Hash[("a".."j").to_a.zip((1..10).to_a)]
    end

    command "local_methods", "Shows the local methods of the current object", keep_retval: true  do |object|
      case object.class
      when Class
        object.public_methods.sort - Object.public_methods
      when Module
        object.public_methods.sort - Module.public_methods
      else
        object.public_methods.sort - Object.new.public_methods
      end
    end
  end
)

puts "Mavenlink toolbox loaded. Type 'help' to see the available pry commands."

