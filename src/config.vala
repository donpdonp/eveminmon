using Json;

class Config {
    public string oauth_url;
    public string refresh_token;
    public string client_id;
    public string client_secret;

    public string oauth_scope = "characterNavigationWrite characterAccountRead esi-location.read_location.v1 esi-location.read_ship_type.v1 esi-fittings.read_fittings.v1 esi-fittings.write_fittings.v1";

    public Config () {
        read_file ("settings.json");
    }

    public void set_refresh_token (string token) {
        stdout.printf ("set refresh %s\n", token);
    }

    public bool has_refresh_token () {
        return refresh_token != null && refresh_token.length > 0;
    }

    public void give_oauth_step1 () {
        var step1 = "https://login.eveonline.com/oauth/authorize/?response_type=code&redirect_uri=http://localhost:8081/&client_id=f523af04922f4256bbd3d295ce60ca89&scope="
                    + Soup.URI.encode (oauth_scope, "") + "&state=uniquestate123";
        stdout.printf ("%s\n", step1);
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

