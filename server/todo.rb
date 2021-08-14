# TODO: implement a storage system / markup language to save and parse data
# TODO: events -> add whether they are generated or manually created
# so that it's easier to re-generate a schedule or strip non-manual entries
=begin
We need to use categories to take the amount of available time on Calendar
and generate events that fit in time slots in the Calendar
# TODO: try creating method callbacks with procs ? like automatic ones like Rails after_action
TODO: reduce all classes <= 100 lines
TODO: read up on when its good to raise_errors vs returning false/nil
TODO: on Event (display duration of event) (show in Hours & minutes)
TODO: show total available time
TODO: raise errors on incorrect usage of methods, return false when used correctly but failed
TODO: change Calendar to Schedule (calendar will hold [Day], and Day will hold [Schedule]
TODO: stub out methods and objects better in calendar_spec.rb
TODO: pull out #save, #create into IDable
=end
