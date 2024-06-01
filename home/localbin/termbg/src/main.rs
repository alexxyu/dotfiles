use terminal_colorsaurus::{color_scheme, QueryOptions, ColorScheme};

fn main() {
    let theme = match color_scheme(QueryOptions::default()).unwrap() {
        ColorScheme::Dark => "dark",
        ColorScheme::Light => "light",
    };

    println!("{theme}");
}
