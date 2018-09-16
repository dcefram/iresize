require "file"
require "magickwand-crystal"

VALID_EXTS = [
  ".jpg", ".jpeg",
  ".png",
  # @TODO: Maybe support additional image extensions...
]

module IResize
  class Resizer
    def initialize(@options : Hash(Symbol, String | Nil))
      LibMagick.magickWandGenesis     # lib init
      @wand = LibMagick.newMagickWand # lib init
    end

    def process
      input_type = self.get_path_type @options[:input_path]
      output_type = self.get_path_type @options[:output_path]
      input_path = @options[:input_path].as(String)
      output_path = @options[:output_path].as(String)

      if output_type == File::Type::Unknown
        # create output folder if it does not exist
        Dir.mkdir_p(output_path, 755)
      end

      if input_type == File::Type::Directory || input_type == File::Type::Symlink
        images = self.list_files

        iter = images.each { |img|
          if LibMagick.magickReadImage @wand, File.join(input_path, img)
            if @options[:width].nil? || @options[:height].nil?
              orig_height = LibMagick.magickGetImageHeight(@wand).to_f32
              orig_width = LibMagick.magickGetImageWidth(@wand).to_f32

              dimensions = self.calculate_with_aspect_ratio({
                :width  => orig_width,
                :height => orig_height,
              })
            else
              dimensions = {
                :width  => @options[:width].as(String).to_i32,
                :height => @options[:height].as(String).to_i32,
              }
            end

            LibMagick.magickScaleImage @wand, dimensions[:width], dimensions[:height]
            LibMagick.magickWriteImage @wand, File.join(output_path, img)
            puts File.join(output_path, img)
          end
        }
      elsif input_type === File::Type::File && self.is_valid_ext input_path
        if LibMagick.magickReadImage @wand, input_path
          if @options[:width].nil? || @options[:height].nil?
            orig_height = LibMagick.magickGetImageHeight(@wand).to_f32
            orig_width = LibMagick.magickGetImageWidth(@wand).to_f32

            dimensions = self.calculate_with_aspect_ratio({
              :width  => orig_width,
              :height => orig_height,
            })
          else
            dimensions = {
              :width  => @options[:width].as(String).to_i32,
              :height => @options[:height].as(String).to_i32,
            }
          end

          LibMagick.magickScaleImage @wand, dimensions[:width], dimensions[:height]
          LibMagick.magickWriteImage @wand, File.join(output_path, input_path)
          puts File.join(output_path, input_path)
        end
      else
        puts "Invalid path supplied to `-i` or `--input`: #{@options[:input_path].as(String)} of type #{input_type}"
      end
    end

    def get_path_type(path : String | Nil)
      if path.is_a?(String)
        info = File.info(path, false)

        info.type
      else
        File::Type::Unknown
      end
    rescue
      File::Type::Unknown
    end

    def calculate_with_aspect_ratio(dimensions : Hash(Symbol, Float32))
      height = @options[:height].nil? ? 720 : @options[:height].as(String).to_i32
      orig_height = dimensions[:height]
      orig_width = dimensions[:width]

      if @options[:width].nil?
        new_width = (orig_width / orig_height) * height
        return {:width => new_width.to_i32, :height => height}
      end

      width = @options[:width].as(String).to_i32
      new_height = (orig_height / orig_width) * width
      return {:width => width, :height => new_height.to_i32}
    end

    def list_files
      input_path = @options[:input_path].as(String)
      files = Dir.children(input_path)

      # Filter only valid image extensions
      filtered = [] of String
      index = 0
      while index < files.size
        if self.is_valid_ext File.join(input_path, files[index])
          filtered.push(files[index])
        end

        index += 1
      end

      filtered
    end

    def is_valid_ext(path : String)
      extname = File.extname path

      return VALID_EXTS.includes? extname
    end
  end
end
