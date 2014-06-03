require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

class MyPresenter

  def self.for
    :quote
  end

  def initialize(attributes, content, additional_attributes)
    @attributes = attributes
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

  let(:simple_quote)      { load_fixture :simple_quote }
  let(:presenter_output)  { load_fixture :simple_quote_presenter_output, :html }
  let(:attributes_output) { load_fixture :simple_quote_presenter_attributes_output, :html }

  describe "using a custom presenter" do

    before do
      Shortcode.register_presenter MyPresenter
    end

    it "uses the custom attributes" do
      Shortcode.process(simple_quote).gsub("\n",'').should == presenter_output
    end

    it "passes through additional attributes" do
      Shortcode.process(simple_quote, { title: 'Additional attribute title' }).gsub("\n",'').should == attributes_output
    end

  end

end
