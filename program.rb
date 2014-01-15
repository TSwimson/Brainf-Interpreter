class Program

  attr_reader :instructions

  def initialize
    @instructions = []
  end

  def display
    @instructions.inject { |sum, i| sum + i }
  end
  
  def add i
    @instructions.concat i
  end

  def save name
    begin
      File.open(name, "wb") do |file|
        file.write(@instructions.join)
      end
    rescue Errno::ENOENT => error
      puts "Error writing file " + error.to_s
    end
  end

  def load file_name
    have_file = false
    begin
      File.open(file_name) do |file|
        while i = file.getc
          @instructions.push i
        end
        have_file = true
      end
    rescue Errno::ENOENT => error
      puts "File not found: " + error.to_s
      have_file = false
    end
    return have_file
  end

end
