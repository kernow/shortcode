class OtherPresenter

  def self.for
    :other
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
