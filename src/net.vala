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
        var message = new Soup.Message ("get", url);
        message.got_headers.connect (() => {
            message.request_headers.foreach ((name, val) => {
// stdout.printf ("req wtf %s: %s\n", name, val);
            });
        });

        message.request_headers.replace ("Authorization", "Bearer " + token);
        stdout.printf ("Authorization: Bearer %s\n", token);
        session.send_message (message);
        message.response_headers.foreach ((name, val) => {
// stdout.printf ("resp %s: %s\n", name, val);
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
