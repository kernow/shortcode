require "support/presenters/parent_missing_initialize_presenter"

class ChildMissingInitializePresenter < ParentMissingInitializePresenter

  def self.for; end

  def content; end

  def attributes; end

end
