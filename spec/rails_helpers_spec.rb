require 'spec_helper'

module ShortcodeSpecViewHelper
  def wrap_in_p(content)
    content_tag :p, content
  end
end

describe "rails helpers" do

  let(:template)    { load_fixture :rails_helper }

  let(:erb_output)  { load_fixture :rails_helper_output_erb,  :html }
  let(:haml_output) { load_fixture :rails_helper_output_haml, :html }
  let(:slim_output) { load_fixture :rails_helper_output_slim, :html }

  before(:each) do
    Shortcode.setup do |config|
      config.template_parser = :erb
      config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.attribute_quote_type = '"'
      config.use_attribute_quotes = true
      config.presenters = {}
    end
  end

  describe "erb" do

    it "are accessible within erb templates" do
      expect(Shortcode.process(template).gsub("\n",'')).to eq(erb_output)
    end

  end

  describe "haml" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :haml
        config.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
      end
    end

    it "are accessible within haml templates" do
      expect(Shortcode.process(template).gsub("\n",'')).to eq(haml_output)
    end

  end

  describe "slim" do

    before(:each) do
      Shortcode.setup do |config|
        config.template_parser = :slim
        config.template_path = File.join File.dirname(__FILE__), "support/templates/slim"
      end
    end

    it "are accessible within slim templates" do
      expect(Shortcode.process(template).gsub("\n",'')).to eq(slim_output)
    end

  end

  describe "using a custom helper module" do

    let(:template) { load_fixture :custom_helper }
    let(:output)   { load_fixture :custom_helper_output,  :html }

    before(:each) do
      Shortcode.setup do |config|
        config.helpers = [ShortcodeSpecViewHelper]
      end
    end

    it "is accessible within templates" do
      expect(Shortcode.process(template).gsub("\n",'')).to eq(output)
    end

  end

end
