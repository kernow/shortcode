require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'
require 'benchmark'

# Uncomment to run performace specs


# describe Shortcode do

#   let(:long_text)   { load_fixture :long_text }
#   let(:parser)      { Shortcode::Parser.new }
#   let(:transformer) { Shortcode::Transformer.new }

#   context "parser" do

#     before { long_text }

#     it "runs quickly" do
#       Benchmark.realtime {
#         parser.parse long_text
#       }.should < 1.5
#     end

#   end

#   context "transformer" do

#     let(:parsed_hash) { parser.parse long_text }

#     before { parsed_hash }

#     it "runs quickly" do
#       Benchmark.realtime {
#         transformer.apply(parsed_hash, additional_attributes: nil)
#       }.should < 0.1
#     end

#   end

# end
