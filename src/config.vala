using Json;

class Config {
    string url;
    string refresh_token;
    string access_token;

    public Config () {
        read_file ("settings.json");
    }

    void read_file (string filename) {
        // Load a file:
        Json.Parser parser = new Json.Parser ();
        try {
            parser.load_from_file (filename);
            // Get the root node:
            Json.Object settings = parser.get_root ().get_object ();
            url = settings.get_string_member ("oauth_url");
            stdout.printf ("%s oauth_url %s\n", filename, url);
        } catch (Error e) {
            stdout.printf ("Unable to parse `%s': %s\n", filename, e.message);
        }
    }
}

