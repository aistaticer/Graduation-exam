console.log('webpack.config.js is loaded');

const path = require('path');
const os = require('os');

module.exports = {
  mode: 'development',
  entry: [
    'webpack-dev-server/client?http://' + os.hostname() + ':9090/',
    './app/javascript/packs/application.js', // ここにはあなたのメインのJavaScriptファイルのパスを入れてね
    './app/javascript/packs/new.js',
    './app/javascript/packs/show.js',
    './app/javascript/packs/evolution.js',
    './app/javascript/packs/index.js',
    './app/javascript/packs/copy.js',
    './app/javascript/packs/user_show.js',
  ],
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),

  },
  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    compress: true,
    host: '0.0.0.0',
    port: 7090,
    publicPath: '/packs/js/'
  },
  // babel-loaderの設定を追加
  module: {
    rules: [
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'fonts/',
            },
          },
        ],
      },
      {
        test: /\.js$/,
        exclude: /node_modules\/(?!@hotwired\/turbo)/, // @hotwired/turboを除外から除外
        use:
          {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            plugins: [
              "@babel/plugin-proposal-optional-chaining",
              "@babel/plugin-proposal-nullish-coalescing-operator",
              "@babel/plugin-proposal-logical-assignment-operators" // これを追加
            ]
          }
        }
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader', // スタイルをDOMに適用する
          'css-loader',   // CSSをCommonJSに変換する
          'sass-loader'   // SassをCSSにコンパイルする
        ]
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      }
    ]
  }
  // その他の設定...
	
};