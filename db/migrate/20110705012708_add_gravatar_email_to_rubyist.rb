class AddGravatarEmailToRubyist < ActiveRecord::Migration
  def self.up
    add_column :rubyists, :gravatar_email, :string
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("UPDATE rubyists SET gravatar_email = email")
    end
  end

  def self.down
    remove_column :rubyists, :gravatar_email
  end
end
