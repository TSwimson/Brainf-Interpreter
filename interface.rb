require "./interpreter.rb"
require "./program.rb"
#A easy interface for the interpreter class allows for loading programs and running them in different modes
def ok
  puts "Enter to continue"
  gets
end

class Interface

  def initialize
    @program = Program.new
    @interpreter = Interpreter.new
    prompt_main_menu
  end

  #this function will prompt the user for a filename and attempt to load it until the file loads succesfully
  def load_program
    loop do
      puts "Enter the name of the file to load "
      break if @program.load gets.chomp
    end
  end

  #Dispalys the main menu with options to run or display a program if there is on
  def display_menu
    main_menu = ["[L]oad program", "[I]nteractive mode"]
    main_menu.concat ["[R]un program", "[D]isplay program", "[S]ave as", "[C]lear program"] if @program.instructions.length > 0
    main_menu.concat ["[O]ptions", "[Re]set data", "[E]xit"]
    puts main_menu
  end

  #Display the menu and act on the user input
  def prompt_main_menu
    while true
      puts `clear`
      display_menu
      case gets.chomp.downcase
      when "i"
        interactive
      when "o"
        prompt_options
      when "l"
        load_program
      when "re"
        @interpreter.reset_data_and_pointers
        puts "Data reset"
        ok
      when "c"
        @program.clear
      when "r"
        if @program.instructions.size > 0
          @interpreter.run_program @program.instructions
          ok
        else
          puts "No program to run"
        end
      when "d"
        puts @program.display
        ok
      when "s"
        puts "Enter file name"
        @program.save(gets.chomp)
      when "e"
        break
      else
        puts "Uknown command"
        ok
      end
    end
  end

  def interactive
    while true
      puts `clear`
      puts "Enter one or more instructions, [R]un, [D]isplay, [Re]set, [B]ack"
      ins = gets.chomp.downcase.split ""
      case ins[0..1].join
      when "r"
        @interpreter.run_program @program.instructions
          ok
      when "re"
        @interpreter.reset_data_and_pointers
        puts "Data reset"
        ok
      when "d"
        puts @program.display
        ok
      when "b"
        break
      else
        @program.add ins

      end
    end
  end

   def prompt_options
    while true
      puts `clear`
      puts ["[S]tep by step mode is #{@interpreter.options[:step_by_step]}", "[B]ack"]
      case gets.chomp.downcase
      when "s"
        @interpreter.options[:step_by_step] = !@interpreter.options[:step_by_step]
        puts "Step by step is #{@interpreter.options[:step_by_step]}"
        ok
      when "b"
        break
      end
    end
  end

end

i = Interface.new

