require "pry"
class Interpreter
  attr_accessor :options
  def initialize
    @data = [0]*30000

    @instruction_pointer = 0
    @data_pointer = 0

    @jumps = []

    @output = ""
    @options = {step_by_step: false}

  end

  def reset_data_and_pointers
    @data = [0]*30000
    @instruction_pointer = 0
    @data_pointer = 0
    @jumps = []
    @output = ""
  end

  def run_program instructions
    while @instruction_pointer < instructions.length
      act_on_instruction(instructions[@instruction_pointer])
      update_display
      @instruction_pointer += 1
      gets if @options[:step_by_step]
    end
  end

  def interactive_mode
    reset_data_and_pointers
    while true
      puts "Enter one or more instructions, display [O]ptions, or go [B]ack"
      ins = gets.chomp.downcase.split ""
      case ins[0]
      when "o"
        interactive_options
      when "b"
        break
      else
        @instructions.concat ins
        run_program
      end
    end
  end

  def interactive_options
    options = ["[L]oad program", "[D]isplay program", "[S]ave program to file", "[R]un program from begining", "toggle [st]ep-by-step mode", "Go [B]ack"]
    while true
      puts options
      case gets.chomp.downcase
      when "st"
        @options[:step_by_step] = !@options[:step_by_step]
        puts "step-by-step is " + @options[:step_by_step].to_s
      when "l"
        load_program
      when "d"
        display_program
      when "s"
        puts "Enter the filename"
        save_program gets.chomp
      when "r"
        reset_data_and_pointers
        run_program
      when "b"
        break
      end
    end
  end

  def update_display
    puts `clear`
    puts "Jumps: #{@jumps}"
    begining = @instruction_pointer - 10
    begining = 0 if begining < 0
    ending = @instruction_pointer + 10
    ending = @instructions.length - 1 if ending >= @instructions.length
    puts @instructions[begining..ending].join
    puts " "*(@instructions[begining..ending].join.length/2) + "^"
    puts @data[0..20].join " "
    puts " "*(@data[0..@data_pointer].join(" ").length - 1) + "^"
    puts @output
  end

  def act_on_instruction(ins)
    case ins
    when ">"
      if @data_pointer + 1 >= @data.length
        @data.concat([0]*100)
      end
      @data_pointer += 1
    when "<"
      @data_pointer -= 1 if @data_pointer > 0
    when "+"
      @data[@data_pointer] += 1
      @data[@data_pointer] = 0 if @data[@data_pointer] > 255
    when "-"
      @data[@data_pointer] -= 1
      @data[@data_pointer] = 255 if @data[@data_pointer] < 0
    when "."
      o = @data[@data_pointer].chr
      @output += o if o
    when ","
      get_input
    when "["
      if @data[@data_pointer] == 0
        while @instructions[@instruction_pointer] != "]"
          @instruction_pointer += 1
        end
      else
        @jumps.push @instruction_pointer
      end
    when "]"
      if @data[@data_pointer] != 0
        @instruction_pointer = @jumps[-1]
      else
        @jumps.pop
      end
    end
  end

  def get_input
    puts "Enter a number 0-255"
    i = gets.to_i
    @data[@data_pointer] = i if i <= 255 && i >= 0
  end
end


