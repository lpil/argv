import argv

pub fn main() {
  let argv = argv.load()
  echo argv
  let assert [] = argv.load().arguments
}
