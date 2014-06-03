require 'spec_helper'

describe "template parsers" do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  context "erb" do

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output
    end

  end

  context "haml" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :haml
        config.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
      end
    end

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output
    end

  end

  context "slim" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :slim
        config.template_path = File.join File.dirname(__FILE__), "support/templates/slim"
      end
    end

    it "can render a template" do
      Shortcode.process(simple_quote).gsub("\n",'').should == simple_quote_output
    end

  end

end
