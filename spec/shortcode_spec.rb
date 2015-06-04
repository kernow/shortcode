require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }
  let(:quote_with_extras)   { load_fixture :quote_with_extras }
  let(:quote_with_extras_stripped) { load_fixture :quote_with_extras_stripped }

  context "simple_quote" do

    it "converts into html" do
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end

    it "strips the shortcodes" do
      expect(Shortcode.strip(quote_with_extras)).to eq(quote_with_extras_stripped)
    end

  end

  context "erb templates" do

    it "converts into html" do
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end
  end

  context "configuration" do

    describe "block_tags" do

      before do
        Shortcode.setup do |config|
          config.block_tags = []
        end
      end

      it "handles an empty array" do
        expect { Shortcode.process(simple_quote) }.to_not raise_error
      end

    end

    describe "self_closing_tags" do

      before do
        Shortcode.setup do |config|
          config.self_closing_tags = []
        end
      end

      it "handles an empty array" do
        expect { Shortcode.process(simple_quote) }.to_not raise_error
      end

    end

  end

end
