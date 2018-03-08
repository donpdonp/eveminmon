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
            if (!retrying) {
                stdout.printf ("Authentication required\n");
                // it isn't the real IDs ;)
                auth.authenticate (config.client_id, config.client_secret);
            }
        });

        var verb = "POST";
        var request = new Soup.Message (verb, config.oauth_url);

        var formdata = "grant_type=refresh_token&refresh_token=" + config.refresh_token;
        request.got_headers.connect (() => {
            stdout.printf ("%u\n", request.status_code);
        });

        return true;
    }
}
