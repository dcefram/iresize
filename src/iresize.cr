require "option_parser"

require "./iresize/*"

input_path = "./"
output_path = "./output"
height = nil
width = nil

OptionParser.parse! do |parser|
  parser.banner = "Usage: iresize [-i <PATH>] [-o <PATH>] [-h <SIZE>]"
  parser.on("-i PATH", "--input=PATH", "Path to the folder filled with images, or Path to the target image") { |path| input_path = path }
  parser.on("-o PATH", "--output=PATH", "Path to the output folder") { |path| output_path = path }
  parser.on("-h SIZE", "--height=SIZE", "Target height") { |size| height = size }
  parser.on("-w SIZE", "--width=SIZE", "Target width") { |size| width = size }
end

resizer = IResize::Resizer.new({
  :input_path  => input_path,
  :output_path => output_path,
  :height      => height,
  :width       => width,
})

resizer.process
