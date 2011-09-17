require 'test_helper'
require_relative '../lib/optical_music_recognizer'

class OpticalMusicRecognizerTest < Test::Unit::TestCase
  def setup 
    @omr = OpticalMusicRecognizer.new('test/clementine_sheet_music.gif')
  end
  
  def test_omr_recognizes_3_systems_in_my_darling_clementine
    assert_equal @omr.systems.count, 3
  end
end