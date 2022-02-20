require "sequel"
require "sqlite3"

def database_init()
    if File.exists?("luludb.db")
        $DB = Sequel.connect('sqlite://luludb.db')
        $PROXIES = $DB[:proxies]
    else
        db = SQLite3::Database.new "luludb.db"
        db.close
        $DB = Sequel.connect('sqlite://luludb.db')
        $DB.create_table :proxies do
            primary_key :id
            String :name
            String :prefix
            String :pfp
        
        $PROXIES = $DB[:proxies]
        
        end
    end
end
