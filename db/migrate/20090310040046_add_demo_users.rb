class AddDemoUsers < ActiveRecord::Migration
  def self.up

    # Admin Role
    admin_role = Role.create(:name => 'admin')

    # Admin User
    admin = User.create do |u|
      u.login = 'admin'
      u.password = u.password_confirmation = 'admin'
      u.email = 'admin@example.com'
    end
    admin.activate!
    admin.roles << admin_role
    
    # Demo User
    demo = User.create do |u|
      u.login = 'demo'
      u.password = u.password_confirmation = 'demo'
      u.email = 'demo@example.com'
    end
    demo.activate!

  end

  def self.down
    User.find_by_login("admin").destroy
    User.find_by_login("demo").destory
  end
end
