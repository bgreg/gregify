class Pryrc
  attr_reader :theme, :verbose

  def initialize(theme, verbose = false)
    @verbose = true
    @theme = theme
  end

  def prompt_theme
    case theme
    when 'dark'
      prompt(:purple, :yellow, :purple, :purple)
    when 'light'
      prompt(:blue, :red, :blue, :blue)
    else
      if verbose
        puts "A PRY_THEME has not been set in your shell. \n"\
             "You can choose between dark or light themes like this: \n"\
             "export PRY_THEME=light, or export PRY_THEME=dark"
      end
      exit
    end
  end

  private

  def custom_color(name, text)
    if Pry.color
      # wrap ANSI codes so Readline knows where the prompt ends
      "\001#{Pry::Helpers::Text.send name, '{text}'}\002".sub '{text}', "\002#{text}\001"
    else
      text
    end
  end

  #  Available colors
  #  ---------------
  # :black, :red, :green, :yellow, :blue, :purple, :magenta, :cyan, :white
  #
  def prompt(version_color, object_color, terminator_color, line_continuation_color)
    [
      lambda do |object, nest_level, pry|
        prompt = ""
        prompt += "Ruby:(#{ custom_color(version_color, "#{ RUBY_VERSION.to_s }") }) "
        prompt += "object:("
        prompt += custom_color(object_color, Pry.view_clip(object))
        if nest_level > 0
          prompt += ":#{nest_level}"
        end
        prompt += ")"
        "#{ prompt } #{ custom_color(terminator_color, '>> ') }"
      end,
      lambda { |object, nest_level, pry| custom_color(line_continuation_color , '>>') }
    ]
  end
end

%w[rubygems awesome_print].each do |gem|
  begin
    require gem
  rescue LoadError
    puts "You are missing a cool gem: #{gem}"
    exit
  end
end

# sets Awesome Print as the default printer for pry,
# remove to roll back to standard pry output
#
AwesomePrint.pry!

Pry.editor = 'vim'
Pry.config.color = true
Pry.config.pager = true
Pry.config.auto_indent = true
Pry.config.prompt = Pryrc.new(ENV['PRY_THEME']).prompt_theme
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
      require 'rexml/document'

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

puts "\n Toolbox loaded from ~/.pryrc. Type 'help' to see the available pry commands.\n\n"

