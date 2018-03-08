int main (string[] args) {
    var config = new Config ();
    var net = new Net (config);
    net.get_access_token ();

    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    loop.run ();

    return 0;
}
