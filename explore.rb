#!/usr/bin/env ruby

require 'rubygems'
require 'commander'

require_relative './textadventure'

class MyApplication
  include Commander::Methods
  # include whatever modules you need

  def run
    program :name, 'tale'
    program :version, '0.0.1'
    program :description, 'Execute a hidden_treasures file as a text adventure.'
    default_command :read
    
    command :read do |c|
      c.syntax = 'tale read <tale>'
      c.description = 'Begins reading a tale'
      c.action do |args, options|
        file = args.first
        if !file
          puts 'No story to tell!'
          return
        end
        
        require File.join(Dir.pwd, file)
        
        say "Now reading '#{TextAdventure.tale.title}'"
        say 'Press Enter to begin...'
        $stdin.getc
        
        current_section = TextAdventure.tale.introduction
        say current_section.text
        while current_section.choices != :end
          $terminal.newline
          choice = choose color('What will you do?', :blue), *current_section.choices.keys
          current_section = TextAdventure.tale.sections[current_section.choices[choice]]
          say "\e[H\e[2J"
          say color(current_section.title, :red, :underline, :bold)
          say current_section.text
        end
        $terminal.newline
        say color('~fin', :yellow, :bold)
        $stdin.getc
      end
    end

    run!
  end
end

MyApplication.new.run if $0 == __FILE__
