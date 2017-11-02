class MyPresenter

  def self.for
    :quote
  end

  def initialize(_attributes, content, additional_attributes)
    @content = content
    @additional_attributes = additional_attributes
  end

  attr_reader :content

  def attributes
    @additional_attributes || { title: "my custom title" }
  end

end
