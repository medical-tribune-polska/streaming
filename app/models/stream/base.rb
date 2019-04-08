require_dependency 'stream'

module Stream
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end
