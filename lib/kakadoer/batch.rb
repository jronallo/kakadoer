module Kakadoer
  class Batch
    include Shared
    attr_accessor :input_directory, :output_directory, :logger, :processed_num, :log

    def initialize(input_directory, output_directory)
      @input_directory = input_directory
      @output_directory = output_directory
      @processed_num = 0
      @logger = false
      @log = []
    end

    def create_jp2s_with_output(verbose=false)
      @logger = true
      @logger_verbose = verbose
      create_jp2s
    end

    def create_jp2s
      tif_files.each do |file_path|
        @log << file_path if @logger
        if !File.size? file_path
          next
        end
        # convert jpg to tif
        if is_a_jpg?(file_path) or compressed_tif?(file_path)
          file_path = tif_tempfile_path(file_path)
        end
        begin
          cmd = Command.new(file_path, @output_directory)
          response = cmd.kakado
        rescue
          @log << 'ERROR: ' + file_path
          next
        ensure
          cmd.remove_empty
        end
        if @logger_verbose
          @log << response
          puts file_path
          #puts response; puts
        end
        @log << output_path(file_path) if @logger
        @processed_num += 1
        @log << separator if @logger
        
        FileUtils.rm tempfile(file_path) if File.exists? tempfile(file_path)
      end
      self
    end

    def tif_tempfile_path(file_path)
      magick_image = Magick::Image.read(file_path).first
      magick_image.write('bmp:' + tempfile(file_path))
      # clean up for rmagick since it won't do it
      magick_image.destroy!
      GC.start
      tempfile(file_path)
    end

    def tempfile(file_path)
      File.expand_path(File.join(@input_directory, filename(file_path) + '.bmp'))
    end

    def is_a_jpg?(file_path)
      ['.JPG', '.jpg'].include? File.extname(file_path)
    end
    
    def compressed_tif?(file_path)
      if ['.tif', '.TIF'].include? extension(file_path)
        compression = `identify -format "%C" #{file_path}`.chomp
        if compression == 'None'
          false
        else
          true
        end
      else
        false
      end
    end

    def separator
      "======"
    end

    def tif_files
      Dir.glob(File.expand_path(File.join(@input_directory, '*.{tif,JPG,jpg}')))
    end

    def filenames
      tif_files.sort.map{|path| filename(path)}
    end

  end
end

