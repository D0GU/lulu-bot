require "sequel"
require "sqlite3"

def database_init()
    if File.exists?("luludb.db")
        $DB = Sequel.connect('sqlite://luludb.db')
        $PROXIES = $DB[:proxies]
        $WEBHOOK = $DB[:webhook]
    else
        db = SQLite3::Database.new "luludb.db"
        db.close
        $DB = Sequel.connect('sqlite://luludb.db')
        $DB.create_table :proxies do
            primary_key :id
            String :name
            String :prefix
            String :pfp
        end
        $DB.create_table :webhook do
            String :name
            String :id
            String :token
        end
        $PROXIES = $DB[:proxies]
        $WEBHOOK = $DB[:webhook]
    end
end
