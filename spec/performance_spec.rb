require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'
require 'benchmark'

# Uncomment to run performace specs


# describe Shortcode do

#  let(:configuration) {
#     Shortcode::Configuration.new.tap do |config|
#       config.template_parser = :erb
#       config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
#       config.templates = nil
#       config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
#       config.self_closing_tags = [:timeline_event, :timeline_info]
#       config.attribute_quote_type = '"'
#       config.use_attribute_quotes = true
#     end
#   }
#   let(:long_text)   { load_fixture :long_text }
#   let(:parser)      { Shortcode::Parser.new(configuration) }
#   let(:transformer) { Shortcode::Transformer.new(configuration) }
# 
#   context "parser" do
# 
#     before { long_text }
# 
#     it "runs quickly" do
#       Benchmark.realtime {
#         parser.parse long_text
#       }.should < 1.5
#     end
# 
#   end
# 
#   context "transformer" do
# 
#     let(:parsed_hash) { parser.parse long_text }
# 
#     before { parsed_hash }
# 
#     it "runs quickly" do
#       Benchmark.realtime {
#         transformer.apply(parsed_hash, additional_attributes: nil)
#       }.should < 0.1
#     end
# 
#   end
# 
# end
