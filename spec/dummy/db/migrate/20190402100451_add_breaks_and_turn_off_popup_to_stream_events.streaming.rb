# This migration comes from streaming (originally 20190311102414)
class AddBreaksAndTurnOffPopupToStreamEvents < ActiveRecord::Migration
  def change
    add_column :stream_events, :breaks, :json, default: {}
    add_column :stream_events, :show_popup, :boolean, default: true
  end
end
