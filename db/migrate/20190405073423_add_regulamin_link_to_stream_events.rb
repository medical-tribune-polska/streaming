class AddRegulaminLinkToStreamEvents < ActiveRecord::Migration
  def change
    add_column :stream_events, :regulamin_link, :string
  end
end
