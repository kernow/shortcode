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

  let(:shortcode) { Shortcode.new }
  let(:configuration) { shortcode.configuration }

  before do
    configuration.block_tags = [:rails_helper, :custom_helper]
    configuration.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
  end

  describe "erb" do

    it "are accessible within erb templates" do
      expect(shortcode.process(template).gsub("\n",'')).to eq(erb_output)
    end

  end

  describe "haml" do

    before do
      configuration.template_parser = :haml
      configuration.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
    end

    it "are accessible within haml templates" do
      expect(shortcode.process(template).gsub("\n",'')).to eq(haml_output)
    end

  end

  describe "slim" do

    before do
      configuration.template_parser = :slim
      configuration.template_path = File.join File.dirname(__FILE__), "support/templates/slim"
    end

    it "are accessible within slim templates" do
      expect(shortcode.process(template).gsub("\n",'')).to eq(slim_output)
    end

  end

  describe "using a custom helper module" do

    let(:template) { load_fixture :custom_helper }
    let(:output)   { load_fixture :custom_helper_output,  :html }

    before do
      configuration.helpers = [ShortcodeSpecViewHelper]
    end

    it "is accessible within templates" do
      expect(shortcode.process(template).gsub("\n",'')).to eq(output)
    end

  end

end
