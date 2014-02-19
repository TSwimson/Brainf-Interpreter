require './interpreter.rb'
require './program.rb'

def ok(msg = nil)
  puts msg if msg
  puts 'Enter to continue'
  gets
end
# A easy interface for the interpreter class allows for:
# loading programs and
# running them in different modes
class Interface
  def initialize(file = nil)
    @program = Program.new(file)
    @interpreter = Interpreter.new
    @menu = {
      'l'  => :load_program,     'i'  => :interactive,
      'r'  => :run_program,      'd'  => :display_program,
      's'  => :save_program,     'c'  => :clear_program,
      're' => :reset_data,       'o'  => :prompt_options,
      'e'  => :exit,             'b'  => :exit }
    @menu.default = :add_instruction
    prompt_main_menu
  end

  # this function will prompt the user for a filename
  # and attempt to load it, until the file loads succesfully
  def load_program(ins = nil)
    loop do
      puts 'Enter the name of the file to load '
      break if @program.load(gets.chomp)
    end
  end

  # Dispalys the main menu with
  # options to run or display a program if there is one
  def display_menu
    main_menu = ['[L]oad program', '[I]nteractive mode']
    main_menu.concat [
      '[R]un program',
      '[D]isplay program',
      '[S]ave as',
      '[C]lear program'
     ] if @program.instructions.length > 0
    main_menu.concat ['[O]ptions', '[Re]set data', '[E]xit']
    puts main_menu
  end

  # Display the menu and act on the user input
  def prompt_main_menu
    @quit = false
    until @quit
      puts `clear`
      display_menu
      ins = gets.chomp.downcase
      send(@menu[ins[0..1]], ins)
    end
  end

  def interactive(ins = nil)
    @quit = false
    until @quit
      puts `clear`
      puts 'Enter one or more instructions, [R]un, [D]isplay, [Re]set, [B]ack'
      ins = gets.chomp.downcase
      send(@menu[ins[0..1]], ins)
    end
    @quit = false
  end

  def prompt_options(ins = nil)
    until @quit
      puts [`clear`,
            "[S]tep by step mode is #{@interpreter.options[:step_by_step]}",
            '[B]ack']
      case gets.chomp.downcase
      when 's' then toggle_step_option
      when 'b' then exit
      end
    end
    @quit = false
  end

  private

  def exit(ins = nil)
    @quit = true
  end

  def toggle_step_option(ins = nil)
    new_setting = !@interpreter.options[:step_by_step]
    @interpreter.options[:step_by_step] = new_setting
    ok "Step by step is #{@interpreter.options[:step_by_step]}"
  end

  def run_program(ins = nil)
    if @program.instructions.size > 0
      @interpreter.run_program(@program.instructions)
    else
      puts 'No program to run'
    end
    ok
  end

  def reset_data(ins = nil)
    @interpreter.reset_data_and_pointers
    ok('Data reset')
  end

  def display_program(ins = nil)
    ok(@program.print)
  end

  def add_instruction(ins)
    @program.add(ins)
  end

  def save_program(ins = nil)
    puts 'Enter file name'
    @program.save(gets.chomp)
  end

  def clear_program(ins = nil)
    @program.clear
  end
end

Interface.new ARGV[0]
