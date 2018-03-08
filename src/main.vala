int main (string[] args) {
    var config = new Config ();

    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    loop.run ();

    return 0;
}
