require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  let(:shortcode) { Shortcode.new }
  let(:configuration) { shortcode.configuration }

  before do
    configuration.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
  end

  context "simple_quote" do

    before do
      configuration.block_tags = [:quote]
    end

    it "converts into html" do
      expect(shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end

  end

  context "erb templates" do

    before do
      configuration.block_tags = [:quote]
    end

    it "converts into html" do
      expect(shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end
  end

  context "configuration" do

    describe "block_tags" do

      before do
        configuration.block_tags = []
      end

      it "handles an empty array" do
        expect { shortcode.process(simple_quote) }.to_not raise_error
      end

    end

    describe "self_closing_tags" do

      before do
        configuration.self_closing_tags = []
      end

      it "handles an empty array" do
        expect { shortcode.process(simple_quote) }.to_not raise_error
      end

    end

  end

  context "multiple instances" do

    it "allows having multiple Shortcode instances that have independent configurations" do
      expect(Shortcode.new.configuration).to_not be(Shortcode.new.configuration)
    end

    context "configuration" do

      let(:shortcode1) { Shortcode.new }
      let(:shortcode2) { Shortcode.new }

      before do
        shortcode1.setup do |config|
          config.self_closing_tags << :quote
          config.templates = { quote: 'i am from shortcode 1' }
        end

        shortcode2.setup do |config|
          config.self_closing_tags << :quote
          config.templates = { quote: 'i am from shortcode 2' }
        end
      end

      it "uses the shortcode instance's configuration to process shortcodes" do
        expect(shortcode1.process('[quote]')).to eq('i am from shortcode 1')
        expect(shortcode2.process('[quote]')).to eq('i am from shortcode 2')
      end

    end

  end

end
