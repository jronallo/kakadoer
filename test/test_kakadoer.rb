require 'helper'

class TestKakadoer < Test::Unit::TestCase
  context "create a batch of JP2s" do
    setup do
      @input_directory = 'test/tifs'
      @output_directory = 'test/tmp'
      @kakado = Kakadoer.new(@input_directory, @output_directory)
    end
    should "store an input and output directory" do
      assert /#{@input_directory}$/.match @kakado.input_directory
      assert /#{@output_directory}$/.match @kakado.output_directory
    end
    
    should "enumerate filenames in input directory" do
      assert ['first', 'second', 'third'], @kakado.filenames 
    end
    
    should "create JP2s without output" do
      @kakado.create_jp2s
      assert_equal 3, Dir.entries(@output_directory).size - 2
      FileUtils.rm( Dir.glob(File.join(@output_directory, '*'))) #clean up
    end
    
    should "create JP2s with output" do
      response = @kakado.create_jp2s_with_output
    end
    
    should "hold the number of tifs processed" do
      assert_equal 3, @kakado.create_jp2s.processed_num
    end
    
  end
end
