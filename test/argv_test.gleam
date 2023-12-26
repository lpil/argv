import gleam/io
import argv

pub fn main() {
  let argv = argv.load()
  io.debug(argv)
  let assert [] = argv.load().arguments
}
