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

    Gtk.Label character_name;
    Gtk.Label station_name;

    public Window () {
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        var title_label = new Gtk.Label ("EVE MinMon");
        vbox.add (title_label);
        character_name = new Gtk.Label ("-");
        vbox.add (character_name);
        add (vbox);
        station_name = new Gtk.Label ("-");
        vbox.add (station_name);
        add (vbox);
        show_all ();
    }

    public void setCharacterName (string title) {
        character_name.set_markup (title);
    }

    public void setStationId (string title) {
        station_name.set_markup (title);
    }
}
