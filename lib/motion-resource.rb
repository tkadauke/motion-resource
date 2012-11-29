require "motion-resource/version"
require 'bubble-wrap'
Dir.glob(File.join(File.dirname(__FILE__), 'motion-resource/*.rb')).each do |file|
  BW.require file
end
