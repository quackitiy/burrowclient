"use strict";

// electron-builder's settings for the linux packages (the windows wizard is
// burrow.nsi). tools/build.sh hands over the staged app, the electron to use
// and where to put the result.
const path = require("path");

const root = path.join(__dirname, "..");
const flash = path.join(root, "flash");

module.exports = {
  appId: "software.burrow.client",
  productName: "Burrow",
  copyright: "",
  electronVersion: "11.5.0",
  electronDist: process.env.BURROW_ELECTRON,
  directories: {app: process.env.BURROW_APP, output: process.env.BURROW_OUT},
  // the client finds flash beside its own folder (app/main.js), so no asar
  asar: false,
  npmRebuild: false,
  nodeGypRebuild: false,
  publish: null,
  // the .deb and .rpm want a homepage and a maintainer; the server's address
  // stands in when the build was given one
  extraMetadata: {
    // the package's name in apt and dnf
    name: "burrow",
    homepage: process.env.BURROW_HOMEPAGE || "https://play.burrow.moe",
    author: {name: "Burrow", email: "burrow@burrow.moe"},
    desktopName: "burrow.desktop",
  },

  linux: {
    target: [{target: "AppImage", arch: ["x64"]}, {target: "deb", arch: ["x64"]}, {target: "rpm", arch: ["x64"]}],
    icon: path.join(root, "app", "icon.png"),
    category: "Game",
    maintainer: "Burrow",
    synopsis: "The client for the Burrow server",
    description: "The client for Burrow, an AJ Classic private server.",
    executableName: "burrow",
    // the 2019 flash plugin cannot start inside chromium's sandbox on linux
    executableArgs: ["--no-sandbox"],
    extraResources: [{from: flash, to: "flash", filter: ["libpepflashplayer.so", "manifest.json"]}],
  },
  appImage: {artifactName: "Burrow-x86_64.AppImage"},
  deb: {artifactName: "burrow_amd64.deb"},
  rpm: {artifactName: "burrow.x86_64.rpm"},
};
