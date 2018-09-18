module IResize
  class Watcher
    def initialize(@input_path : String)
    end

    def start(&block : String -> Nil)
      # Verify that the input_path is a folder
      info = File.info(@input_path, true)

      if info.type != File::Type::Directory
        puts "Input path should be a directory if --watch flag is enabled"
        return
      end

      spawn do
        cache = [] of String
        # loop forever
        loop do
          files = Dir.children(@input_path)
          index = 0

          while index < files.size
            if !cache.includes?(files[index])
              cache.push files[index]
              block.call(File.join(@input_path.as(String), files[index]))
            end

            index += 1
          end
        end
      end

      sleep
    end
  end
end
