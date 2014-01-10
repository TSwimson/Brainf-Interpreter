user_wants_to_exit = false
#Main loop to allow the loading of multiple programs
until user_wants_to_exit

  have_file = false
  instructions = []
  puts "[I]nteractive mode or load [P]rogram?"
  #loops to get file succesfully
  until have_file

    puts "Enter the name of file to open "
    file_name = gets.chomp

    begin
      File.open(file_name) do |file|
        while i = file.getc
          instructions.push i
        end
      end
      puts "File Loaded: " + instructions.to_s
      have_file = true

    rescue Errno::ENOENT => error
      puts "File not found: " + error.to_s
      have_file = false
    end
  end
  #file has been retrieve now beginning to run the program
  #wrapper loop to allow restarting program
  run_program = true
  while run_program
    instruction_pointer = 0
    data = [0]*30000
    data_pointer = 0
    output = ""
    #big case statement for each instruction
    while instruction_pointer < instructions.length
      case instructions[instruction_pointer]
      when ">"
        data_pointer += 1 if data_pointer + 1 < 30000
      when "<"
        data_pointer -= 1 if data_pointer > 0
      when "+"
        data[data_pointer] += 1
        data[data_pointer] = 0 if data[data_pointer] > 255
      when "-"
        data[data_pointer] -= 1
        data[data_pointer] = 255 if data[data_pointer] < 0
      when "."
        o = data[data_pointer].chr
        output += o if o
      when ","
        puts "Enter a number 0-255"
        i = gets.to_i
        data[data_pointer] = i if i <= 255 && i >= 0
      when "["
        if data[data_pointer] == 0
          while instructions[instruction_pointer] != "]"
            instruction_pointer += 1
          end
        end
      when "]"
        if data[data_pointer] != 0
          while instructions[instruction_pointer] != "["
            instruction_pointer -= 1
          end
        end
      end
      #to show whats going on update the display with data array after each instruction
      system "clear"
      data[0..10].each { |x| print x.to_s + " "}
      puts
      instruction_pointer += 1
    end
    puts output
    puts "Do you want to restart the program [y/n]"
    run_program = gets.chomp == "y"
  end

  puts "Exit? [y/n]"
  user_wants_to_exit = gets.chomp == "y"
end
