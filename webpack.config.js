// Add this to a webpack.config.js file
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const miniCss = MiniCssExtractPlugin.loader;
const cssLoader = { loader: 'css-loader', options: { sourceMap: true, importLoaders: 1 } };
const postcssLoader = { loader: 'postcss-loader', options: { sourceMap: true } };

module.exports = {
  entry: {
    site: ['./assets/javascripts/site.js'],
    style: ['./assets/stylesheets/style-entry.js'],
  },
  output: {
    /* Must be absolute from site root: Middleman serves bundles from /javascripts/.
       Empty publicPath breaks code-split chunks on deep URLs (e.g. /blog/2026/.../). */
    publicPath: '/javascripts/',
    path: path.resolve(__dirname, '.tmp/dist'),
    filename: '[name].min.js',
  },
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: [miniCss, cssLoader, postcssLoader],
      },
      {
        test: /\.(scss|sass)$/i,
        use: [
          miniCss,
          { loader: 'css-loader', options: { sourceMap: true, importLoaders: 2 } },
          postcssLoader,
          'resolve-url-loader',
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true,
              api: 'modern',
              sassOptions: {
                quietDeps: true,
              },
            },
          },
        ],
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: [{
          loader: 'url-loader?limit=10000&mimetype=application/font-woff',
        }],
      },
      {
        test: /\.(ttf|eot|svg|gif|jpg|png)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: [{
          loader: 'file-loader',
        }],
      },
    ],
  },
  plugins: [new MiniCssExtractPlugin()],
  performance: {
    hints: false,
  },
};
