import { List } from "./gleam.mjs";

export function load() {
  if (globalThis.Deno) {
    const runtime = Deno.execPath();
    const program = new URL(Deno.mainModule).pathname;
    const args = List.fromArray(Deno.args);
    return [runtime, program, args];
  }

  if (globalThis.process) {
    const specialArgs = ["-e", "--eval", "-p", "--print"];
    // In Node.js and Bun, when special arguments are specified, `process.argv[1]` is not a script path,
    // and command line arguments are stored starting from `process.argv[1]`.
    if (process.execArgv.some((x) => specialArgs.includes(x))) {
      const [runtime, ...args] = process.argv;
      return [runtime, "", List.fromArray(args)];
    } else {
      const [runtime, program, ...args] = process.argv;
      return [runtime, program, List.fromArray(args)];
    }
  }

  const runtime = "browser";
  const program = document.location.toString();
  const args = List.fromArray([]);
  return [runtime, program, args];
}
