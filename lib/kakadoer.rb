require 'rubygems'
require 'RMagick'
require 'tempfile'

class Kakadoer
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
      # convert jpg to tif
      if is_a_jpg?(file_path)
        file_path = tif_tempfile_path(file_path)
      end
      response = kakado(file_path)
      if @logger_verbose
        @log << response
        puts file_path
        #puts response; puts
      end
      @log << output_path(file_path) if @logger
      @processed_num += 1
      @log << separator if @logger
      FileUtils.rm tif_tempfile_path(file_path) if File.exists? tif_tempfile_path(file_path)
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

  def separator
    "======"
  end

  def tif_files
    Dir.glob(File.expand_path(File.join(@input_directory, '*.{tif,JPG,jpg}')))
  end

  def filenames
    tif_files.sort.map{|path| filename(path)}
  end

  private

  # The general commandline that Djatoka uses to compress images is:
  # kdu_compress -quiet -i <tmpTiff> -o <outoutJP2> -slope 51651,51337,51186,50804,50548,50232 Cprecincts="{256,256},{256,256},{128,128}" Clayers=6 Corder=RPCL ORGtparts=R Cblk="{32,32}" ORGgen_plt=yes Creversible=yes

  def kakado(file_path)
    `kdu_compress -i #{file_path} -o #{output_path(file_path)} -rate 0.5 Clayers=1 Clevels=7 "Cprecincts={256,256},{256,256},{256,256},{128,128},{128,128},{64,64},{64,64},{32,32},{16,16}" "Corder=RPCL" "ORGgen_plt=yes" "ORGtparts=R" "Cblk={32,32}" Cuse_sop=yes`
  end

  def output_path(file_path)
    File.expand_path(File.join(@output_directory, filename(file_path) + '.jp2' ))
  end

  def extension(file_path)
    File.extname(file_path)
  end

  def filename(file_path)
    File.basename(file_path, extension(file_path) )
  end

end

