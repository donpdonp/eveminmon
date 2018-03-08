/*
 */

class Net {
    Config config;

    public Net (Config config) {
        this.config = config;
    }

    public bool get_access_token () {
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
        request.got_headers.connect (() => {
            stdout.printf ("%u\n", request.status_code);
            request.request_headers.foreach ((name, val) => {
                stdout.printf ("req wtf %s: %s\n", name, val);
            });
            request.response_headers.foreach ((name, val) => {
                stdout.printf ("req-resp wtf %s: %s\n", name, val);
            });
        });

        stdout.printf ("--request sent %s\n", url);
        session.queue_message (request, (sess, response) => {
            stderr.printf ("response status: %u\n", response.status_code);
            response.response_headers.foreach ((name, val) => {
                stdout.printf ("resp %s: %s\n", name, val);
            });

            string body = "";
            for (int i = 0; i < response.response_body.length; i++) {
                char newchar = (char) response.response_body.data[i];
                body += newchar.to_string ();
            }
            stdout.printf ("body: %" + uint64.FORMAT_MODIFIER + "d %s\n", response.response_body.length, body);
        });


        return true;
    }
}
