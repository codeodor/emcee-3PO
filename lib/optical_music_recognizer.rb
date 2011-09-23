class OpticalMusicRecognizer
  LINES_PER_STAFF = 5
  
  def initialize(sheet_music_image)
    @image_processor = ImageProcessor.new(sheet_music_image)
  end
  
  def staves
    threshold = @image_processor.y_projection.inject(:+) / @image_processor.y_projection.count
    local_maxima = @image_processor.y_projection.local_maxima(threshold)
  
    stave_ranges = detect_stave_ranges(local_maxima)
    return stave_ranges
  end
  
  
  private
  def find_window_with_smallest_distance(windows)
    smallest_window = nil
    smallest_window_distance = 10000000
    windows.each do |window|
      cumulative_distance = 0
      window.each_index do |i|
        break if i == LINES_PER_STAFF - 1
        cumulative_distance += window[i+1] - window[i]
      end
      if smallest_window_distance > cumulative_distance
        smallest_window_distance = cumulative_distance
        smallest_window = window
      end
    end
    return smallest_window
  end
  
  
  def detect_stave_ranges(line_ranges)
    windows = [] 
    line_ranges.each_index{ |i| windows << line_ranges[i,5] }
    windows.reject!{ |x| x.size != 5 }
    stave_ranges = []
    while windows.count > 0 
      stave_ranges << find_window_with_smallest_distance(windows)
      stave_ranges[-1].each do |range|
        windows.reject!{|x| x.include?(range) }
      end
    end
    return stave_ranges
  end

end