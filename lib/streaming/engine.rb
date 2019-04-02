module Streaming
  class Engine < ::Rails::Engine
    require 'mt_web'
    isolate_namespace MtWeb
    engine_name 'streaming'
  end
end
