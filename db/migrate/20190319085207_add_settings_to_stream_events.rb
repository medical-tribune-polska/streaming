class AddSettingsToStreamEvents < ActiveRecord::Migration
  def up
    add_column :stream_events, :settings, :json, default: {
      education_points: nil,
      place: nil,
      info_color: nil,
      show_popup: true,
      popup_time: 30
    }

    Stream::Event.find_each do |event|
      event.update(settings: {
        education_points: event.education_points,
        place: event.place,
        info_color: event.info_color,
        show_popup: event.show_popup
      })
    end

    remove_column :stream_events, :education_points
    remove_column :stream_events, :place
    remove_column :stream_events, :info_color
    remove_column :stream_events, :show_popup
  end

  def down
    add_column :stream_events, :education_points, :string
    add_column :stream_events, :place, :string
    add_column :stream_events, :info_color, :string
    add_column :stream_events, :show_popup, :boolean, default: true

    Stream::Event.find_each do |event|
      event.update(
        education_points: event.settings['education_points'],
        place: event.settings['place'],
        info_color: event.settings['info_color'],
        show_popup: event.settings['show_popup']
      )
    end

    remove_column :stream_events, :settings
  end
end
