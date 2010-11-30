module Kakadoer
  class Command
    include Shared
    attr_accessor :file_path, :output_dir

    def initialize(file_path, output_dir=nil)
      @file_path = file_path
      @output_dir = output_dir
    end

    def kakado
      check_file
      `#{kakado_cmd}`
      remove_empty
    end

    # The general commandline that Djatoka uses to compress images is:
    # kdu_compress -quiet -i <tmpTiff> -o <outoutJP2> -slope 51651,51337,51186,50804,50548,50232 Cprecincts="{256,256},{256,256},{128,128}" Clayers=6 Corder=RPCL ORGtparts=R Cblk="{32,32}" ORGgen_plt=yes Creversible=yes
    def kakado_cmd
      "kdu_compress -i #{file_path} -o #{output_path(file_path, output_dir)} #{KAKADU_OPTIONS} 2>&1"
    end

    def check_file
      #FIXME: this fails if file_path includes spaces, but this isn't the right place to fix it.
      # It _should_fail if it has spaces, but should never get to this point having spaces.
      output = `identify #{file_path} 2>&1` 
      if output.include?("identify: ") and !output.include?('wrong data type 7 for "RichTIFFIPTC"; tag ignored.')
        raise Kakadoer::MalformedImageError
      end
    end
    
    def remove_empty
      if File.exists? output_path(file_path, output_dir) and !File.size? output_path(file_path, output_dir)
        FileUtils.rm(output_path(file_path, output_dir)) 
      end
    end

  end
end

