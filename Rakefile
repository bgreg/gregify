require 'rake'

desc "install the dot files into user's home directory"
task :install do
  puts "Your shell is set to: #{ENV['SHELL']}"
  unless ENV['SHELL'] =~ /zsh/
    system('chsh -s /usr/local/bin/zsh')
  end

  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE id_dsa.pub].include?(file)
    
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
  
  # Need to do this to make vim use RVM's ruby version
  puts "Moving zshenv to zshrc"
  system %Q{sudo mv /etc/zshenv /etc/zshrc}

  system %Q{mkdir ~/.tmp}
  puts "Finished"
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end

