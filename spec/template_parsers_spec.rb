require 'spec_helper'

describe "template parsers" do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  let(:shortcode) { Shortcode.new }
  let(:configuration) { shortcode.configuration }

  context "erb" do

    before do
      configuration.block_tags = [:quote]
      configuration.template_parser = :erb
      configuration.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
    end

    it "can render a template" do
      expect(shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end

  end

  context "haml" do

    before do
      configuration.block_tags = [:quote]
      configuration.template_parser = :haml
      configuration.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
    end

    it "can render a template" do
      expect(shortcode.process(simple_quote).gsub("\n",'').gsub('>  <', '><')).to eq(simple_quote_output)
    end

  end

  context "slim" do

    before do
      configuration.block_tags = [:quote]
      configuration.template_parser = :slim
      configuration.template_path = File.join File.dirname(__FILE__), "support/templates/slim"
    end

    it "can render a template" do
      expect(shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end

  end

end
