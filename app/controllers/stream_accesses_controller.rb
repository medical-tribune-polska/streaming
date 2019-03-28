class StreamAccessesController < ApplicationController
  def show
    @stream_access = StreamAccess.find_by!(slug: params[:slug])
  end
end
