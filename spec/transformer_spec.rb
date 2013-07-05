require 'spec_helper'
require 'parslet/rig/rspec'
require 'pp'

describe Shortcode do

  let(:parser)      { Shortcode::Parser.new }
  let(:transformer) { Shortcode::Transformer.new }

  let(:simple_quote)      { load_fixture :simple_quote }
  let(:full_quote)        { load_fixture :full_quote }
  let(:quote_with_extras) { load_fixture :quote_with_extras }
  let(:simple_list)       { load_fixture :simple_list }
  let(:timeline_event)    { load_fixture :timeline_event }
  let(:timeline_info)     { load_fixture :timeline_info }
  let(:timeline_person)   { load_fixture :timeline_person }
  let(:complex_snippet)   { load_fixture :complex_snippet }

  let(:quotes)            { [simple_quote, full_quote, quote_with_extras] }
  let(:collapsible_lists) { [simple_list] }
  let(:timelines)         { [timeline_event, timeline_info, timeline_person] }

  let(:simple_quote_output)      { load_fixture :simple_quote_output, :html }
  let(:full_quote_output)        { load_fixture :full_quote_output, :html }
  let(:quote_with_extras_output) { load_fixture :quote_with_extras_output, :html }
  let(:simple_list_output)       { load_fixture :simple_list_output, :html }
  let(:timeline_event_output)    { load_fixture :timeline_event_output, :html }
  let(:timeline_info_output)     { load_fixture :timeline_info_output, :html }
  let(:timeline_person_output)   { load_fixture :timeline_person_output, :html }
  let(:complex_snippet_output)   { load_fixture :complex_snippet_output, :html }

  context "simple_quote" do

    it "converts into html" do
      obj = parser.parse(simple_quote)
      html = transformer.apply obj
      html.should == simple_quote_output
    end

  end

  context "full_quote" do

    it "converts into html" do
      html = transformer.apply(parser.parse(full_quote))
      html.should == full_quote_output
    end

  end

  context "quote_with_extras" do

    it "converts into html" do
      html = transformer.apply(parser.parse(quote_with_extras))
      html.should == quote_with_extras_output
    end

  end

  context "simple_list" do

    it "converts into html" do
      html = transformer.apply(parser.parse(simple_list))
      html.should == simple_list_output
    end

  end

  context "timeline_event" do

    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_event))
      html.should == timeline_event_output
    end

  end

  context "timeline_info" do

    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_info))
      html.should == timeline_info_output
    end

  end

  context "timeline_person" do

    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_person))
      html.should == timeline_person_output
    end

  end

  context "complex_snippet" do

    it "converts into html" do
      html = transformer.apply(parser.parse(complex_snippet))
      html.should == complex_snippet_output
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
      html = transformer.apply(parser.parse(simple_quote))
      html.gsub("\n",'').should == simple_quote_output.gsub("\n",'')
    end
  end
end
