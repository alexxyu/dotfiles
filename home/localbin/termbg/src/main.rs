use std::{
    env,
    error::Error,
    io::{self, Write},
    process::ExitCode,
    time::Duration,
};
use terminal_colorsaurus::{theme_mode, QueryOptions, ThemeMode};

fn run() -> Result<(), Box<dyn Error>> {
    let mut options = QueryOptions::default();
    // Keep the library's SSH-friendly default unless explicitly overridden.
    match env::var("TERMBG_TIMEOUT_MS") {
        Ok(value) => {
            let timeout = value
                .parse::<u64>()
                .ok()
                .filter(|&ms| ms > 0)
                .ok_or("TERMBG_TIMEOUT_MS must be a positive integer in milliseconds")?;
            options.timeout = Duration::from_millis(timeout);
        }
        Err(env::VarError::NotPresent) => {}
        Err(error) => return Err(error.into()),
    }

    let theme = match theme_mode(options)? {
        ThemeMode::Dark => "dark",
        ThemeMode::Light => "light",
    };

    writeln!(io::stdout().lock(), "{theme}")?;
    Ok(())
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("termbg: {error}");
            ExitCode::FAILURE
        }
    }
}
