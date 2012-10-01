module ApplicationHelper
  def GetTimeFormat(time)
    "#{time/60}:#{((time%60 < 10)? "0":"")}#{time%60}"
  end
end
