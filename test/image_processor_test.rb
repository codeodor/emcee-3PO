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
  
  def test_y_projection_gives_accurate_count_of_dark_pixels_per_row
    assert @ip.y_projection.count == @ip.image.rows, "The y projection was not equal to the number of rows"
    @ip.y_projection.each_with_index do |count_in_row, i|
      assert_equal 0, count_in_row
    end
  end
  
  def test_x_projection_gives_accurate_count_of_dark_pixels_per_column
    assert @ip.x_projection.count == @ip.image.columns, "The x projection was not equal to the number of columns"
    @ip.x_projection.each_with_index do |count_in_row, i|
      assert_equal 0, count_in_row
    end
  end
  
  
end