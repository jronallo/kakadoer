module Kakadoer
  module Shared
    def output_path(file_path, output_dir=nil)
      out = choose_output_directory(output_dir)
      File.expand_path(File.join(out, filename(file_path) + '.jp2' ))
    end

    def choose_output_directory(output_dir=nil)
      if output_dir
        output_dir
      else
        if @output_directory
          @output_directory
        else
          Dir.pwd
        end
      end
    end

    def extension(file_path)  
      File.extname(file_path)
    end

    def filename(file_path)
      File.basename(file_path, extension(file_path) )
    end

  end
end

