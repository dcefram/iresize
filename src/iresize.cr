require "option_parser"

require "./iresize/*"

input_path = "./"
output_path = "./output"
height = nil
width = nil

OptionParser.parse! do |parser|
  parser.banner = "Usage: iresize [-i <PATH>] [-o <PATH>] [-h <SIZE>]"
  parser.on("-I PATH", "--input=PATH", "Path to the folder filled with images, or Path to the target image") { |path| input_path = path }
  parser.on("-O PATH", "--output=PATH", "Path to the output folder") { |path| output_path = path }
  parser.on("-H SIZE", "--height=SIZE", "Target height") { |size| height = size }
  parser.on("-W SIZE", "--width=SIZE", "Target width") { |size| width = size }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

resizer = IResize::Resizer.new({
  :input_path  => input_path,
  :output_path => output_path,
  :height      => height,
  :width       => width,
})

resizer.process
