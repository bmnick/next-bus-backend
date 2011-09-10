require 'rubygems'
require 'icalendar'
require "date"
require "open-uri"

include Icalendar

def first_future_event array
  array.index do |event|
    time_suffix = event.dtstart.to_s.split("T")[1].gsub('+00:', '-04:')
    
    time_string = [@current_date_prefix, time_suffix].join('T')

    event_time = Time.parse time_string

    event_time > Time.now
  end
end

ical = open "https://www.google.com/calendar/ical/l2ir0r6otctlia2o4doj2aj04g@group.calendar.google.com/private-556cf4f747b608177ee188644b24fb19/basic.ics"

cal = Icalendar.parse(ical).first

sorted_events = cal.events.sort_by {|event| event.dtstart}

colony_busses, gleason_busses = sorted_events.partition {|event| event.summary == 'From Colony'}

@current_date_prefix = Time.now.to_s.split(' ')[0]

next_colony_index, next_gleason_index = [colony_busses, gleason_busses].collect do |array|
  first_future_event array
end

next_busses = [gleason_busses[next_gleason_index], colony_busses[next_colony_index]]

next_busses.each do |event|
  puts "Next bus #{event.summary} at: #{event.dtstart}"
end
