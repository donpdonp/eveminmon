/*
 */
using Json;

delegate void TokenCall (string a);

class Net {
    Config config;

    public Net (Config config) {
        this.config = config;
    }

    public Json.Object api (string token, string url) {
        var session = new Soup.Session ();
        stdout.printf ("api %s\n", url);
        var message = new Soup.Message ("GET", url);
        message.got_headers.connect (() => {
            message.request_headers.foreach ((name, val) => {
            });
        });

        message.request_headers.replace ("Authorization", "Bearer " + token);
        session.send_message (message);
        message.response_headers.foreach ((name, val) => {
        });
        stdout.printf ("api body: %s\n", bodyToData (message.response_body));
        string body = bodyToData (message.response_body);
        var node = strToObject (body);
        return node;
    }

    public bool get_access_token (TokenCall tcall) {
        var session = new Soup.Session ();

        var verb = "post";
        var url = config.oauth_url;
        var authUri = new Soup.URI (url);
        authUri.set_user (config.client_id);
        authUri.set_password (config.client_secret);

        var request = new Soup.Message.from_uri (verb, authUri);


        var formdata = "grant_type=refresh_token&refresh_token=" + config.refresh_token;
        request.request_headers.replace ("Authorization", "Basic YTpi");

        request.set_request ("application/x-www-form-urlencoded", Soup.MemoryUse.COPY, formdata.data);

        session.queue_message (request, (sess, response) => {
            stderr.printf ("token refresh status: %u\n", response.status_code);
            if (response.status_code != 200) {
                response.response_headers.foreach ((name, val) => {
                    stdout.printf ("resp %s: %s\n", name, val);
                });
            }

            string body = bodyToData (response.response_body);
            var node = strToObject (body);
            tcall (node.get_string_member ("access_token"));
        });

        return true;
    }

    public void getCharacterImage (int64 id) {
        getImage ("Character", id, "jpg");
    }

    public void getShipImage (int64 id) {
        getImage ("Render", id, "png");
    }

    public void getImage (string section, int64 id, string imgtype) {
        var filename = "images/" + id.to_string () + "." + imgtype;
        var file = File.new_for_path (filename);
        if (!file.query_exists ()) {
            stdout.printf ("Character image %s missing. requesting. \n", filename);
            var session = new Soup.Session ();
            var url = "https://imageserver.eveonline.com/" + section + "/" + id.to_string () + "_128." + imgtype;
            stdout.printf ("%s \n", url);
            var message = new Soup.Message ("GET", url);
            session.send_message (message);
            try {
                GLib.FileUtils.set_data (filename, message.response_body.data);
                stdout.printf ("file write %s: %d bytes\n", filename, (int) message.response_body.length);
            } catch (GLib.FileError e) {
                stdout.printf ("file write err `%s': %s\n", filename, e.message);
            }
        }
    }

    Json.Object strToObject (string json) {
        var obj = new Json.Object ();
        try {
            Json.Parser parser = new Json.Parser ();
            parser.load_from_data (json);
            return parser.get_root ().get_object ();
        } catch (Error e) {
            stdout.printf ("Unable to parse `%s': %s\n", json, e.message);
        }
        return obj;
    }

    // Get the root node:
    string bodyToData (Soup.MessageBody body) {
        string bodystr = "";
        for (int i = 0; i < body.length; i++) {
            char newchar = (char) body.data[i];
            bodystr += newchar.to_string ();
        }
        return bodystr;
    }
}
