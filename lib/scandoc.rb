require_relative "./scandoc/version"
require_relative "./scandoc/command_line_interface.rb"
require_relative "./documentation_data.rb"
require_relative "./scraper.rb"

class Scandoc::Start_program
  def self.run(user_input = nil)
    user_input = ARGV[0]

    if user_input == nil
      puts "Please type keyword:"
      user_input = gets.chomp
    end

    Scandoc::CommandLineInterface.new(user_input).run
  end
end
