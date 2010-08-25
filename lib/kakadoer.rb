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
      response = kakado(file_path)
      @log << response if @logger_verbose
      @log << output_path(file_path) if @logger
      @processed_num += 1      
      @log << separator if @logger
    end
    self
  end  
  
  def separator
    "======"
  end
  
  def tif_files
    Dir.glob(File.expand_path(File.join(@input_directory, '*.tif')))
  end
  
  def filenames
    tif_files.sort.map{|path| filename(path)}
  end
  
  private
  
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
