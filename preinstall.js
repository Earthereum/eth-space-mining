const {execSync} = require("child_process");

console.log("preparing renderer submodule...");
execSync("git submodule update --init --recursive", {stdio: "inherit"});
execSync("npm install; npm run build", {cwd: "./earthereum-planet-renderer", stdio: "inherit"});
