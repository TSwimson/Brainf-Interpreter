#This class interprets the given program and keeps
#track of the pointers and data

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

  #resets the data and pointers for rerunning a program
  def reset_data_and_pointers
    @data = [0]*30000
    @instruction_pointer = 0
    @data_pointer = 0
    @jumps = []
    @output = ""
  end

  #runs the given <instructions> optionally one at a time if the step by step option is true
  def run_program instructions
    update_display instructions
    while @instruction_pointer < instructions.length
      act_on_instruction(instructions[@instruction_pointer], instructions)
      update_display instructions
      @instruction_pointer += 1
      gets if @options[:step_by_step]
    end
  end

  def display_instructions_with_pointer instructions
    out = ""
    start = @instruction_pointer - 25
    start = 0 if start < 0
    ending = @instruction_pointer + 25
    ending += (25 - @instruction_pointer) if start == 0
    ending = instructions.length - 1 if ending > instructions.length - 1
    pointer = " "*(@instruction_pointer - start) + "^"
    out += instructions[start..ending].join + "\n"
    out += pointer + "\n"
  end

  #updates the display with the instructions, current instruction pointer, data, data_pointer, and output
  def update_display instructions
    puts `clear`
    out = ""
    # out += instructions.join
    # out += "\n" + (" "*(instructions[0...@instruction_pointer].join.length)) + "^"
    out += display_instructions_with_pointer instructions
    out += "\n#{@data[0..20].join " "}"
    out += "\n" + " "*(@data[0..@data_pointer].join(" ").length - 1) + "^"
    out += "\n" + @output
    puts out
  end

  #acts on any given instruction <ins> also takes <instructions> 
  def act_on_instruction(ins, instructions)
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
      open_b instructions
    when "]"
      close_b
    end
  end

  #[ and ] handling methods
  def open_b instructions   
    if @data[@data_pointer] == 0
      opens = 1
        while opens > 0
          @instruction_pointer += 1
          if instructions[@instruction_pointer] == "["
            opens += 1
          elsif instructions[@instruction_pointer] == "]"
            opens -= 1
          end
          
        end
      else
        @jumps.push @instruction_pointer
      end
  end

  def close_b
    if @data[@data_pointer] != 0
        @instruction_pointer = @jumps[-1]
      else
        @jumps.pop
    end
  end
  #get input from the user
  def get_input
    puts "Enter a number 0-255"
    i = gets.to_i
    @data[@data_pointer] = i if i <= 255 && i >= 0
  end
end


