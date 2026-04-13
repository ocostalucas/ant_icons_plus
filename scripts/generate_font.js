// Font generation wrapper for Windows compatibility.
// fantasticon's glob breaks on Windows backslash paths.
// This script reads SVGs manually and calls the font pipeline directly.

const fs = require("fs");
const path = require("path");
const { generateFonts } = require("fantasticon");

const inputDir = process.argv[2] || ".tmp/svgs";
const outputDir = process.argv[3] || ".tmp/font";
const fontName = process.argv[4] || "AntIcons";

// Ensure output dir exists
fs.mkdirSync(outputDir, { recursive: true });

// Override getIconId to use the file basename without extension
const config = {
  inputDir: inputDir.split(path.sep).join("/"),
  outputDir: outputDir.split(path.sep).join("/"),
  name: fontName,
  fontTypes: ["ttf"],
  assetTypes: ["json"],
  normalize: true,
  fontHeight: 1024,
};

// Monkey-patch path.join temporarily to use forward slashes for glob
const originalJoin = path.join;
path.join = function (...args) {
  return originalJoin.apply(this, args).split(path.sep).join("/");
};

generateFonts(config)
  .then((results) => {
    path.join = originalJoin;
    console.log(`Generated font: ${fontName}.ttf`);
  })
  .catch((err) => {
    path.join = originalJoin;
    console.error("Font generation failed:", err.message || err);
    process.exit(1);
  });
