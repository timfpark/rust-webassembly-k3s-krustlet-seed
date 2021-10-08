use chrono::offset::Utc;
use chrono::DateTime;
use std::{thread, time};

fn main() {
    loop {
        let now = time::SystemTime::now();
        let datetime: DateTime<Utc> = now.into();

        println!("hello world @ {}", datetime.format("%d/%m/%Y %H:%M:%S"));

        let one_second = time::Duration::from_millis(1000);
        thread::sleep(one_second);
    }
}
