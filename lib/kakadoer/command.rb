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
    end

    # The general commandline that Djatoka uses to compress images is:
    # kdu_compress -quiet -i <tmpTiff> -o <outoutJP2> -slope 51651,51337,51186,50804,50548,50232 Cprecincts="{256,256},{256,256},{128,128}" Clayers=6 Corder=RPCL ORGtparts=R Cblk="{32,32}" ORGgen_plt=yes Creversible=yes
    def kakado_cmd
      "kdu_compress -i #{file_path} -o #{output_path(file_path, output_dir)} #{KAKADU_OPTIONS}"
    end

    def check_file
      output = `identify #{file_path} 2>&1`
      raise if output.include?("identify: ")
    end

  end
end

