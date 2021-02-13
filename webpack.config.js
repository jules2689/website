// Add this to a webpack.config.js file
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: {
    site: ['./assets/javascripts/site.js'],
    style: ['./assets/stylesheets/site.css.scss'],
  },
  output: {
    publicPath: '',
    path: path.resolve(__dirname, '.tmp/dist'),
    filename: '[name].min.js',
  },
  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/i,
        use: [
          MiniCssExtractPlugin.loader,
          { loader: 'css-loader', options: { sourceMap: true, importLoaders: 1 } },
          { loader: 'postcss-loader', options: { sourceMap: true } },
          'resolve-url-loader',
          { loader: 'sass-loader', options: { sourceMap: true } }
        ]
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: [{
          loader: 'url-loader?limit=10000&mimetype=application/font-woff'
        }],
      },
      {
        test: /\.(ttf|eot|svg|gif|jpg|png)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: [{
          loader: 'file-loader'
        }]
      }
    ]
  },
  plugins: [new MiniCssExtractPlugin()],
};
