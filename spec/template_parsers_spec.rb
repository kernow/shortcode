require 'spec_helper'

describe "template parsers" do

  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  before do
    Shortcode.setup do |config|
      config.template_parser = :erb
      config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.attribute_quote_type = '"'
      config.use_attribute_quotes = true
    end
  end

  context "erb" do

    it "can render a template" do
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
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
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
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
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(simple_quote_output)
    end

  end

end
