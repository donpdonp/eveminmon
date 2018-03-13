using Json;

class Config {
    public string oauth_url;
    public string refresh_token;
    public string client_id;
    public string client_secret;

    public string config_filename = "settings.json";
    public string oauth_scope = "characterLocationRead characterNavigationWrite characterSkillsRead characterAccountRead esi-location.read_location.v1 esi-location.read_ship_type.v1 esi-skills.read_skills.v1 esi-skills.read_skillqueue.v1 esi-fittings.read_fittings.v1 esi-fittings.write_fittings.v1";

    public Config () {
        try {
            var jobject = read_file (config_filename);
            refresh_config (jobject);
        } catch (Error e) {
            stdout.printf ("Unable to parse `%s': %s\n", config_filename, e.message);
        }
    }

    public void set_refresh_token (string token) {
        stdout.printf ("set refresh %s\n", token);
        refresh_token = token;
        save_config ();
    }

    public void save_config () {
        try {
            var jobject = read_file (config_filename);
            freeze_config (jobject);
            write_file (jobject, config_filename);
        } catch (Error e) {
            stdout.printf ("Unable to parse `%s': %s\n", config_filename, e.message);
        }
    }

    public bool has_refresh_token () {
        return refresh_token != null && refresh_token.length > 0;
    }

    public void give_oauth_step1 () {
        var step1 = "https://login.eveonline.com/oauth/authorize/?response_type=code&redirect_uri=http://localhost:8081/&client_id=f523af04922f4256bbd3d295ce60ca89&scope="
                    + Soup.URI.encode (oauth_scope, "") + "&state=uniquestate123";
        stdout.printf ("%s\n", step1);
    }

    void refresh_config (Json.Object settings) {
        oauth_url = settings.get_string_member ("oauth_url");
        refresh_token = settings.get_string_member ("refresh_token");
        client_id = settings.get_string_member ("client_id");
        client_secret = settings.get_string_member ("client_secret");
    }

    Json.Object freeze_config (Json.Object settings) {
        settings.set_string_member ("refresh_token", refresh_token);
        return settings;
    }

    void write_file (Json.Object settings, string filename) throws GLib.Error {
        var gen = new Generator ();
        var wtfnode = new Json.Node (Json.NodeType.OBJECT);
        wtfnode.init_object (settings);
        gen.set_pretty (true);
        gen.set_root (wtfnode);
        size_t length;
        string json = gen.to_data (out length);
        stdout.printf ("write_file json: %s\n", json);
        GLib.FileUtils.set_contents (filename, json);
    }

    Json.Object read_file (string filename) throws GLib.Error {
        // Load a file:
        Json.Parser parser = new Json.Parser ();
        parser.load_from_file (filename);
        Json.Object settings = parser.get_root ().get_object ();
        return settings;
    }
}

