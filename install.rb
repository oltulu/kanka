#!/usr/bin/env ruby
require 'readline'


def ask(prompt="", newline=false)
  prompt += "\n" if newline
  Readline.readline(prompt, true).squeeze(" ").strip
end



INSTALL_LOC = Dir.home + '/kanka/'

if Dir.exist? INSTALL_LOC
  puts "Uyaro: ~/kanka zaten var!"
end

puts "Biz ~/kanka dizinine uygulamayı kuracağız .<shell>rc. Onaylıyorsanız <enter> tuşuna veya e tuşuna basınız."
STDOUT.flush
CONTINUE = ask "> "
if CONTINUE == "" || CONTINUE == "e"
    # copy to ~/kanka/
    if Dir.exist? INSTALL_LOC
      # raise "~/kanka already exists! Please manually remove if you want to proceed" 
    else
      COPY_COMMAND = 'cp -rf ' + Dir.pwd + ' ' + INSTALL_LOC
      print "`" + COPY_COMMAND + "` komutu Yürütülüyor \n"
      system COPY_COMMAND 
    end

    begin
      *junk, SHELL = `echo $SHELL`.split('/') 
    rescue Exception
       SHELL="bash" #ruby 1.8 (parsing exceptions are not rescued by default)
     end
    bash_config = '.' + SHELL.chomp + 'rc'
    bash_config = '.bash_profile' if RUBY_PLATFORM.match /darwin/ #and ... ?
    
    SHELLRC = (Dir.home + '/' + bash_config ).chomp
    print "`kanka` adlı bir takma ad" + SHELLRC + " dosyasına yazılıyor\n"
    open(SHELLRC, 'a') do |f|
      f.puts "\n"
      f.puts "######## Generated by kanka's install script"
      f.puts "alias kanka=\'#{ Dir.home }/kanka/main.rb\'"
    end
    
    puts "add auto-complete by typing"
    puts "complete -C #{INSTALL_LOC}autocomplete.rb kanka"
    `#{INSTALL_LOC}autocomplete.rb`
end

