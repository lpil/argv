import gleam/io
import argv

pub fn main() {
  io.debug(argv.load())
}
