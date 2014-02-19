#This class is for loading, parsing and saving programs

class Program

  attr_reader :instructions

  def initialize(file = nil)
    @instructions = []
    load(file) if file
  end

  def print
    @instructions.join
  end

  #add either an array of instructions or a string of instructions <i>
  def add i
    if i.kind_of? Array
      @instructions.concat i
    elsif i.kind_of? String
      @instructions.concat i.split
    end
  end

  #attempt to save the current <@instructions> to a file <name>
  def save name
    begin
      File.open(name, "wb") do |file|
        file.write(@instructions.join)
      end
    rescue Errno::ENOENT => error
      puts "Error writing file " + error.to_s
    end
  end

  #empties the current program array
  def clear
    @instructions = []
  end

  #loads <file_name> into <@instructions> returns true if succesfull else returns false
  def load file_name
    have_file = false
    clear
    begin
      File.open(file_name) do |file|
        while i = file.getc
          add i
        end
        have_file = true
      end
    rescue
      puts "File not found: "
      have_file = false
    end
    return have_file
  end

end
