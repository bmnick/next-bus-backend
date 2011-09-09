require 'rubygems'
require 'icalendar'
require "date"
require "open-uri"

include Icalendar

ical = open "https://www.google.com/calendar/ical/l2ir0r6otctlia2o4doj2aj04g@group.calendar.google.com/private-556cf4f747b608177ee188644b24fb19/basic.ics"

cal = Icalendar.parse(ical).first

sorted_events = cal.events.sort_by {|event| event.dtstart}

colony_busses = sorted_events.find_all {|event| event.summary == "From Colony"}
gleason_busses = sorted_events.find_all {|event| event.summary == "From Gleason"}

current_date_prefix = Time.now.to_s.split(' ')[0]

print "Current date prefix is #{current_date_prefix}"

next_colony_index = colony_busses.index do |event|
  time_suffix = event.dtstart.to_s.split('T')[1].gsub('+00:', '-04:')
  
  time_string = [current_date_prefix, time_suffix].join('T')
  
  event_time = Time.parse time_string
  
  puts "event at: #{event_time.to_s} summary: #{event.summary}"
  puts "currently #{'not' if event_time < Time.now} beyond now: #{Time.now}"
  event_time > Time.now
end

next_gleason_index = gleason_busses.index do |event|
  time_suffix = event.dtstart.to_s.split('T')[1].gsub('+00:', '-04:')
  
  time_string = [current_date_prefix, time_suffix].join('T')
  
  event_time = Time.parse time_string
  
  puts "event at: #{event_time.to_s} summary: #{event.summary}"
  puts "currently #{'not' if event_time < Time.now} beyond now: #{Time.now}"
  event_time > Time.now
end

puts "Next bus from Gleason at: #{Time.parse gleason_busses[next_gleason_index].dtstart.to_s}"
puts "Next bus from Colony at: #{Time.parse colony_busses[next_colony_index].dtstart.to_s}"

