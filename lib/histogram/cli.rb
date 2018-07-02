# frozen_string_literal: true

require 'thor'
require 'histogram'
require 'histogram/chart'

class Histogram::CLI < Thor

  desc 'go', 'Prompts user for a list of terms'
  def go
    clear_screen!
    intro_prompt
    build_chart
  rescue => e
    say "\nUh oh! #{e.message}"
  ensure
    quit_softly
  end

  no_commands do
    def intro_copy
      <<~CPY
        Enter a list of space separated terms, ie:

        foo bar baz foo
      CPY
    end

    def intro_prompt
      say intro_copy
      input = ask '> '
      @terms = input.split(' ')
    end

    def build_chart
      say "\n\n"
      Histogram::Chart.new(@terms).to_chart
    end

    def clear_screen!
      return system 'cls' if Gem.win_platform?
      system 'clear'
    end

    def quit_softly
      say "\n\nexiting..."
      sleep 0.5
      exit!
    end
  end
end
