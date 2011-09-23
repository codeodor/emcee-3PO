require 'test_helper'
require_relative '../lib/image_processor'

class ImageProcessorTest < Test::Unit::TestCase
  def setup
    @ip = ImageProcessor.new('test/projection_test.gif')
  end
  
  def test_number_of_rows_found_is_number_of_rows_in_image
    assert_equal @ip.image.rows, @ip.rows.count
  end
  
  def test_number_of_columns_found_is_number_of_rows_in_image
    assert_equal @ip.image.columns, @ip.columns.count
  end
  
  def test_y_projection_gives_accurate_count_of_dark_pixels_per_row
    assert @ip.y_projection.count == @ip.image.rows, "The y projection was not equal to the number of rows"
    assert_equal @ip.y_projection.to_a, [11, 6, 7, 1, 1, 12, 1, 1, 1, 2, 20, 2, 11, 2, 1, 8, 10, 2, 17, 0]
  end
  
  def test_x_projection_gives_accurate_count_of_dark_pixels_per_column
    assert @ip.x_projection.count == @ip.image.columns, "The x projection was not equal to the number of columns"
    assert_equal @ip.x_projection.to_a, [6, 5, 6, 7, 6, 5, 5, 5, 6, 6, 5, 5, 1, 19, 5, 4, 3, 6, 5, 6]    
  end
  
  
end