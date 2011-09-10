require 'rubygems'
require 'icalendar'
require "date"
require "open-uri"

include Icalendar

def first_future_event_index cal_events
  cal_events.index do |event|
    # check if the event is in the future
    ical_correct(event.dtstart) > Time.now
  end
end

def first_future_event cal_events
  cal_events[first_future_event_index cal_events]
end

def countdown datetime
  difference = ical_correct(datetime) - Time.now
  
  hours = (difference / (60 * 60)).to_i
  
  minutes = ((difference / 60) - (hours * 60)).to_i
  
  "#{hours}h #{minutes}m"
end

def ical_correct datetime
  # rip apart the datetime string, pull out the second half, and tz correct it
  time_suffix = datetime.to_s.split("T")[1].gsub('+00:', '-04:')
  
  # Move the time of the event to the current day
  time_string = [@current_date_prefix, time_suffix].join('T')

  Time.parse time_string
end

open "https://www.google.com/calendar/ical/l2ir0r6otctlia2o4doj2aj04g@group.calendar.google.com/private-556cf4f747b608177ee188644b24fb19/basic.ics" do |ical|
  @cal = Icalendar.parse(ical).first
end

sorted_events = @cal.events.sort_by {|event| event.dtstart}

colony_busses, gleason_busses = sorted_events.partition {|event| event.summary == 'From Colony'}

@current_date_prefix = Time.now.to_s.split(' ')[0]

next_busses = [colony_busses, gleason_busses].collect do |events|
  first_future_event events
end

next_busses.each do |event|
  puts "Next bus #{event.summary} at: #{event.dtstart}, in: #{countdown event.dtstart}"
end
