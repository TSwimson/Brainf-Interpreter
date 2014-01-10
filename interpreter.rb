class Interpreter

  def initialize
    @instructions = []
    @data = [0]*30000
    @instruction_pointer = 0
    @data_pointer = 0
    @output = ""
    start
  end

  def start
    prompt_mode
  end

  def prompt_mode
    while true
      #puts "[I]nteractive mode, Load [P]rogram, or [E]xit?"
      puts "Load [P]rogram or [E]xit?"
      case gets.chomp.downcase
      when "i"
      when "p"
        load_program
        prompt_to_run_program
      when "e"
        break
      end
    end
  end

  def prompt_to_run_program
    while true
      puts "Do you want to [R]un or [O]utput the program or go [B]ack?"
      case gets.chomp.downcase
      when "r"
        reset_data_and_pointers
        run_program
      when "o"
        print_program
      when "b"
        break
      end
    end
  end

  def print_program
    @instructions.each { |i| print i }
    puts
  end

  def reset_data_and_pointers
    @data = [0]*30000
    @instruction_pointer = 0
    @data_pointer = 0
    @output = ""
  end

  def run_program

    while @instruction_pointer < @instructions.length
      act_on_instruction(@instructions[@instruction_pointer])
      update_display
      @instruction_pointer += 1
    end
  end

  def interactive_mode
    puts "Enter one or more instructions"
    @instructions += gets.chomp.split ""
  end

  def update_display
    system "clear"
    puts @data[0..20].join
    puts " "*(@data[0..@data_pointer].join.length) + "^"
    puts @output
  end

  def get_file_name
    puts "Enter the name of file to open "
    gets.chomp
  end

  def load_program
    have_file = false
    @instructions = []
    until have_file

      file_name = get_file_name

      begin
        File.open(file_name) do |file|
          while i = file.getc
            @instructions.push i
          end
        end

        have_file = true

      rescue Errno::ENOENT => error
        puts "File not found: " + error.to_s
        have_file = false
      end
    end
  end

  def act_on_instruction(ins)
    case ins
    when ">"
      @data_pointer += 1 if @data_pointer + 1 < 30000
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
      end
    when "]"
      if @data[@data_pointer] != 0
        while @instructions[@instruction_pointer] != "["
          @instruction_pointer -= 1
        end
      end
    end
  end

  def get_input
    puts "Enter a number 0-255"
    i = gets.to_i
    @data[@data_pointer] = i if i <= 255 && i >= 0
  end
end

i = Interpreter.new
