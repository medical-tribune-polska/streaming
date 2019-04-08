module StreamHelper
  def stream_date(event)
    starting = event.starting
    finishing = event.finishing
    return if event.starting.nil?

    if starting.month == finishing.month
      if starting.day == finishing.day
        I18n.l(starting, format: '%d %B', locale: :pl_months_genitive)
      else
        t_start = starting.day.to_s
        t_finish = I18n.l(finishing, format: '%d %B', locale: :pl_months_genitive)
        [t_start, t_finish].join(' - ')
      end
    else
      t_start = I18n.l(starting, format: '%d %B', locale: :pl_months_genitive)
      t_finish = I18n.l(finishing, format: '%d %B', locale: :pl_months_genitive)
      [t_start, t_finish].join(' - ')
    end
  end
end
