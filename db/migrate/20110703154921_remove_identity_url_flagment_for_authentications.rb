class RemoveIdentityUrlFlagmentForAuthentications < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      Authentication.where(:provider => %w(open_id google yahoo yahoo_japan mixi)).each do |auth|
        begin
          url = URI.parse(auth.uid)
        rescue URI::InvalidURIError
          # XRI
          puts "XXX #{auth.uid}"
          next
        end

        if url.fragment
          valid_url = auth.uid.gsub(/##{url.fragment}$/, '')
          puts "#{url} -> #{valid_url}"

          auth.update_attributes! :uid => valid_url
        end
      end
    end
  end

  def self.down
    # nothing todo
  end
end
