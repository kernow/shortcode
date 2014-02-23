require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  context "simple_quote" do

    it "converts into html" do
      Shortcode.process(simple_quote).should == simple_quote_output
    end

  end

  context "erb templates" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :erb
        config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      end
    end

    it "converts into html" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output.gsub("\n",'')
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
