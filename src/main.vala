int main (string[] args) {
    var config = new Config ();
    var net = new Net (config);

    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    net.get_access_token ((token) => {
        stdout.printf ("got token %s\n", token);
    });

    loop.run ();

    return 0;
}
