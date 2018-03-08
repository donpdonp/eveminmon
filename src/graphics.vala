class Graphics {
    public static void setup (string[] args) {
        Gtk.init (ref args);
        try {
            Gtk.Window.set_default_icon_from_file ("icon.svg");
        } catch (GLib.Error e) {
        }
    }
}

class Window : Gtk.Window {

    public Window () {
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        var title_label = new Gtk.Label ("EVE MinMon");
        vbox.add (title_label);
        add (vbox);
        show_all ();
    }
}
