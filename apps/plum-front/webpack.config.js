const path = require('path');

module.exports = {
  entry: {
    index_login: './src/Index_login.bs.js' 
  },
  output: {
    path: path.join(__dirname, "../plum-back/public"),
    filename: '[name].js',
  },
  devtool: 'inline-source-map',
};
