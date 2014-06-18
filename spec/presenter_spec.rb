require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

class MyPresenter

  def self.for
    :quote
  end

  def initialize(attributes, content, additional_attributes)
    @content = content
    @additional_attributes = additional_attributes
  end

  def content
    @content
  end

  def attributes
    @additional_attributes || { title: "my custom title" }
  end
end

class MultiplePresenter

  def self.for
    [:quote, :item]
  end

  def initialize(attributes, content, additional_attributes)
    @content = content
    @additional_attributes = additional_attributes
  end

  def content
    @content
  end

  def attributes
    @additional_attributes || { title: "my custom title" }
  end
end

describe Shortcode::Presenter do

  let(:simple_quote)  { load_fixture :simple_quote }
  let(:item)          { load_fixture :item }

  describe "using a custom presenter" do

    let(:presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }

    before do
      Shortcode.register_presenter MyPresenter
    end

    it "uses the custom attributes" do
      expect(Shortcode.process(simple_quote).gsub("\n",'')).to eq(presenter_output)
    end

    it "passes through additional attributes" do
      expect(Shortcode.process(simple_quote, { title: 'Additional attribute title' }).gsub("\n",'')).to eq(attributes_output)
    end

  end

  describe "using a single presenter for multiple shortcodes" do

    let(:quote_presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
    let(:item_presenter_output)   { load_fixture :item_presenter_output,         :html }

    let(:quote_attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }
    let(:item_attributes_output)  { load_fixture :item_presenter_attributes_output,         :html }

    before do
      Shortcode.register_presenter MultiplePresenter
    end

    it "uses the custom attributes" do
      expect(Shortcode.process(simple_quote ).gsub("\n",'')).to eq(quote_presenter_output)
      expect(Shortcode.process(item         ).gsub("\n",'')).to eq(item_presenter_output)
    end

    it "passes through additional attributes" do
      expect(Shortcode.process(simple_quote, { title: 'Additional attribute title' }).gsub("\n",'')).to eq(quote_attributes_output)
      expect(Shortcode.process(item,         { title: 'Additional attribute title' }).gsub("\n",'')).to eq(item_attributes_output)
    end

  end

end
