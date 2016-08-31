class Parser < ActiveRecord::Base

  def self.parse(file)
    CSV.foreach(file.tempfile, headers: true, :header_converters => lambda { |h| h.try(:downcase).tr(" ", "_") }) do |row|
      binding.pry
    end
  end

  # def self.create_player_hash(row)
  #   player_hash = row.to_hash
  #   header_map = {"fppg" => "averageppg", "injury_indicator" => "injury_status"}
  #   player_hash.keys.each { |k| player_hash[ header_map[k] ] = player_hash.delete(k) if header_map[k] }
  #   player_hash["name"] =  "#{player_hash['first_name']} #{player_hash['last_name']}"
  #   p = player_hash.except("first_name", "last_name", "played", "", "game", "id", "injury_details")
  # end

  # def self.create_player_from_hash(player_hash)
  #   p = Player.find_or_create_by(name: player_hash[:name])
  #   p.update(player_hash)
  #   p.save
  # end
end
