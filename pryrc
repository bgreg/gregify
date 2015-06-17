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
def color(name, text)
  if Pry.color
    "\001#{Pry::Helpers::Text.send name, '{text}'}\002".sub '{text}', "\002#{text}\001"
  else
    text
  end
end

Pry.config.prompt = [
  proc do |object, nest_level, pry|
    prompt = ""
    prompt += "Ruby:#{RUBY_VERSION.to_s} "
    prompt += color(:bright_black, Pry.view_clip(object))
    prompt += ":#{nest_level}" if nest_level > 0
    "#{prompt} #{color(:cyan, ' » ')}"
  end, 
  proc { |object, nest_level, pry| colour :cyan, '» ' }
]

Pry.config.commands.import(
  Pry::CommandSet.new do
    command "copy", "copy [text to copy] will copy to system clip board"  do |string|
      IO.popen('pbcopy', 'w') { |f| f << string.to_s }
    end

    command "sql", "Send sql over ActiveRecord.", requires_gem: ['activerecord'] do |query|
      ActiveRecord::Base.connection.select_all(query)
    end

    command "caller_method", "reveal the caller of a given method" do |depth|
      depth = depth.to_i || 1
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth+1).first
        file = Regexp.last_match[1]
        line = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        output.puts [file, line, method]
      end
    end

    command "printx", "Pretty print xml strings" do |xml_string|
      doc = REXML::Document.new(xml_string) 
      output_string = ""
      doc.write(output_string, 1)
      output.puts(output_string)
    end

    command "array_toy", keep_retval: true do 
      Array.new(10) { |i| i+1 }
    end

    command "hash_toy", keep_retval: true  do
      Hash[("a".."j").to_a.zip((1..10).to_a)]
    end

    command "local_methods", keep_retval: true  do |object|
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

puts "Mavenlink toolbox loaded"

