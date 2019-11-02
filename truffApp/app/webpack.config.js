const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  mode: 'development',
  entry: "./src/index.js",
  output: {
    filename: "index.js",
    path: path.resolve(__dirname, "dist"),
  },
  plugins: [
    new CopyWebpackPlugin([{ from: "./src/index.html", to: "index.html" },{ from: "./src/participants.html", to: "participants.html" },{ from: "./src/manufacturer.html", to: "manufacturer.html" },
    { from: "./src/dealer.html", to: "dealer.html" }, { from: "./src/leasingagent.html", to: "leasingagent.html" }]),
  ],
  devServer: { contentBase: path.join(__dirname, "dist"), compress: true },
};
