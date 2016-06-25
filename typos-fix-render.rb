require 'optparse'
require 'yaml'

def main

  options = {}
  option_parser = OptionParser.new do |opts|
    executable_name = File.basename($PROGRAM_NAME)
    opts.banner = <<BANNER
Convert yaml typos file to a readable format such as HTML, plain text format(markdown/org).

Usage: #{executable_name} [options] -i input_filename -o output_filename -f format
BANNER

    opts.on("-i input-file",
            "input file") do |name|
      options[:input_filename] = name
    end

    opts.on("-o output-file",
            "output file") do |name|
      options[:output_filename] = name
    end

    opts.on("-f output-format",
            "output format") do |name|
      options[:output_format] = name
    end
  end

  option_parser.parse!

  unless ARGV.empty?
    puts "ERROR: wrong command usages!"
    puts
    puts option_parser.help
  end

  input_file = File.open(options[:input_filename])
  output_file = File.open(options[:output_filename], "w+")
  typos = YAML::load(input_file)

  output = output_with_format(typos, options[:output_format])
  output_file.write(output)
  input_file.close
  output_file.close
end

def output_with_format(typos, output_format)
  output = ''
  case output_format
  when 'org'
    output = <<HEADER
|Typos|Fix|
|-----+---|
HEADER
    typos.each do |typo|
      case typo['typo']
      when String
        output += "|#{typo['typo']}|#{typo['fix']}|\n"
      when Array
        output += "|#{typo['typo'].join(', ')}|#{typo['fix']}|\n"
      end
    end
  end

  return output
end

if __FILE__ == $0
  main
end
