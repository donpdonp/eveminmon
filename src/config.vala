using Json;

class Config {
    public string oauth_url;
    public string refresh_token;
    public string client_id;
    public string client_secret;


    public Config () {
        read_file ("settings.json");
    }

    void read_file (string filename) {
        // Load a file:
        Json.Parser parser = new Json.Parser ();
        try {
            parser.load_from_file (filename);
            Json.Object settings = parser.get_root ().get_object ();
            oauth_url = settings.get_string_member ("oauth_url");
            refresh_token = settings.get_string_member ("refresh_token");
            client_id = settings.get_string_member ("client_id");
            client_secret = settings.get_string_member ("client_secret");
        } catch (Error e) {
            stdout.printf ("Unable to parse `%s': %s\n", filename, e.message);
        }
    }
}

