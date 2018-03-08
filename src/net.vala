/*
 */

class Net {
    Config config;

    public Net (Config config) {
        this.config = config;
    }

    public bool get_access_token () {
        var session = new Soup.Session ();

        session.authenticate.connect ((sess, msg, auth, retrying) => {
            stdout.printf ("Authentication bit\n");
            if (!retrying) {
                stdout.printf ("Authentication required\n");
                // it isn't the real IDs ;)
                auth.authenticate (config.client_id, config.client_secret);
            }
        });

        var verb = "POST";
        var url = config.oauth_url;
        var request = new Soup.Message (verb, url);


        var formdata = "grant_type=refresh_token&refresh_token=" + config.refresh_token;
        request.set_request ("application/x-www-form-urlencoded", Soup.MemoryUse.COPY, formdata.data);
        request.got_headers.connect (() => {
            stdout.printf ("%u\n", request.status_code);
        });

        stdout.printf ("--request sent %s\n", url);
        session.queue_message (request, (sess, response) => {
            stderr.printf ("response status: %u\n", response.status_code);
            response.response_headers.foreach ((name, val) => {
                stdout.printf ("%s: %s\n", name, val);
            });
        });


        return true;
    }
}
