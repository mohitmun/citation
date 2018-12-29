require 'json'
files = `ls spotify_recently_played*`.split("\n")
@result = {}
files.each do |file|
  json = JSON.parse(File.read(file).split("time_namelookup")[0])
  json["items"].each do | item|
    @result[item["played_at"]] = item
  end
end
f = File.open("final_res.json", "wb")
f.write(@result.to_json)
f.close
