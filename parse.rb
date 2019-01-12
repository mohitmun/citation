require 'json'
files = `ls spotify_recently_played*`.split("\n")
@result = {}
files.each do |file|
  puts "parsing #{file}"
  json = JSON.parse(File.read(file, :encoding => 'UTF-8').split("time_namelookup")[0])
  if json["items"]
    json["items"].each do | item|
      @result[item["played_at"]] = {item: item, track: item["track"]["name"]}
    end
  else
    puts "ERROR items is nil for #{file}"
  end
end
f = File.open("final_res.json", "wb")
f.write(@result.to_json)
f.close
