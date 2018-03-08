int main (string[] args) {
    var config = new Config ();
    var net = new Net (config);

    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    net.get_access_token ((token) => {
        stdout.printf ("got token %s\n", token);
        var jo = net.api (token, "https://login.eveonline.com/oauth/verify");
        stdout.printf ("verify json: %s\n", jo.to_string ());
        var ko = net.api (token, "https://esi.tech.ccp.is/latest/characters/" + jo.get_string_member ("CharacterID"));
    });

    loop.run ();

    return 0;
}
