require 'helper'

class TestKakadoer < Test::Unit::TestCase
  context "create a batch of JP2s from tifs" do
    setup do
      @input_directory = 'test/tifs'
      @output_directory = 'test/tmp'
      @kakado = Kakadoer.new(@input_directory, @output_directory)
    end
    teardown do
      FileUtils.rm( Dir.glob(File.join(@output_directory, '*'))) #clean up
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
      assert_equal 3, Dir.entries(@output_directory).size - 3 # delete 3 for ., .., and .gitignore
    end

    should "create JP2s with output" do
      response = @kakado.create_jp2s_with_output
    end

    should "hold the number of tifs processed" do
      assert_equal 3, @kakado.create_jp2s.processed_num
    end
  end

  context "create a batrch of JP2s from JPGs" do
    setup do
      @input_directory = 'test/jpgs'
      @output_directory = 'test/tmp'
      @kakado = Kakadoer.new(@input_directory, @output_directory)
    end
    teardown do
      FileUtils.rm( Dir.glob(File.join(@output_directory, '*'))) #clean up
    end
    should "store an input and output directory" do
      assert /#{@input_directory}$/.match @kakado.input_directory
      assert /#{@output_directory}$/.match @kakado.output_directory
    end

    should "enumerate filenames in input directory" do
      assert ['belltower', 'bubble'], @kakado.filenames
    end

    should "create JP2s without output" do
      @kakado.create_jp2s
      assert_equal 2, Dir.entries(@output_directory).size - 3 # delete 3 for ., .., and .gitignore
    end

    should "create a JP2 with actual content from a jpg" do
      @kakado.create_jp2s
      assert File.size? Dir.glob(File.join(@output_directory, '*jp2')).first
    end

    should "create JP2s with same names as originals" do
      @kakado.create_jp2s
      ['belltower', 'bubble'].each do |filename|
        assert File.exists? File.join(@output_directory, filename + '.jp2')
      end
    end

    should "remove the temporary bmp files that are created" do
      @kakado.create_jp2s
      ['belltower', 'bubble'].each do |filename|
        assert !File.exists?(File.join(@input_directory, filename + '.bmp'))
      end
    end

    should "create JP2s with output" do
      response = @kakado.create_jp2s_with_output
    end

    should "hold the number of jpgs processed" do
      assert_equal 2, @kakado.create_jp2s.processed_num
    end
  end


end

