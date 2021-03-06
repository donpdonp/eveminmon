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
    Gtk.Image character_profile;
    Gtk.Image ship_image;
    Gtk.Label ship_name;

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
        character_profile = new Gtk.Image.from_file ("images/blank.png");
        vbox.add (character_profile);
        add (vbox);
        ship_image = new Gtk.Image.from_file ("images/blank.png");
        vbox.add (ship_image);
        add (vbox);
        ship_name = new Gtk.Label ("-");
        vbox.add (ship_name);
        add (vbox);
        show_all ();
    }

    public void setCharacterName (string title) {
        character_name.set_markup (title);
    }

    public void setStationId (string title) {
        station_name.set_markup (title);
    }

    public void setImage (int64 id) {
        var filename = "images/" + id.to_string () + ".jpg";
        stdout.printf ("setting img from file " + filename + "\n");
        character_profile.set_from_file (filename);
    }

    public void setShipImage (int64 id) {
        var filename = "images/" + id.to_string () + ".png";
        stdout.printf ("setting img from file " + filename + "\n");
        ship_image.set_from_file (filename);
    }

    public void setShipName (string name) {
        ship_name.set_markup (name);
    }
}
