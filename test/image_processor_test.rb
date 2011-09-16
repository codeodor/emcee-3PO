require 'test/unit'
require 'test_helper'
require_relative '../lib/image_processor'

class ImageProcessorTest < Test::Unit::TestCase
  def setup
    @ip = ImageProcessor.new('star_wars_main_title.jpg')
  end
  
  def test_number_of_rows_found_is_number_of_rows_in_image
    assert_equal @ip.image.rows, @ip.rows.count
  end
  
  def test_number_of_columns_found_is_number_of_rows_in_image
    assert_equal @ip.image.columns, @ip.columns.count
  end
  
  
  
end