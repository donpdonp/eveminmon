int main (string[] args) {
    var config = new Config ();
    var net = new Net (config);

    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);


    net.get_access_token ((token) => {
        stdout.printf ("got token %s\n", token);
        name_check (token, net, window);
        Timeout.add (30000, () => name_check (token, net, window));
    });

    loop.run ();

    return 0;
}

bool name_check (string token, Net net, Window window) {
    var jo = net.api (token, "https://login.eveonline.com/oauth/verify");
    var name = jo.get_string_member ("CharacterName");
    stdout.printf ("Hello %s.\n", name);
    window.setCharacterName (name);
    net.getCharacterImage (jo.get_int_member ("CharacterID"));
    window.setImage (jo.get_int_member ("CharacterID"));
    var location = net.api (token, "https://esi.tech.ccp.is/latest/characters/" + jo.get_int_member ("CharacterID").to_string () + "/location/");
    var station = net.api (token, "https://esi.tech.ccp.is/latest/universe/stations/" + location.get_int_member ("station_id").to_string () + "/");
    var station_name_parts = station.get_string_member ("name").split ("-");
    window.setStationId (station_name_parts[0]);
    stdout.printf ("station name %s\n", station.get_string_member ("name"));
    var ship = net.api (token, "https://esi.tech.ccp.is/latest/characters/" + jo.get_int_member ("CharacterID").to_string () + "/ship/");
    net.getShipImage (ship.get_int_member ("ship_type_id"));
    window.setShipImage (ship.get_int_member ("ship_type_id"));
    window.setShipName (ship.get_string_member ("ship_name"));
    return true;
}
